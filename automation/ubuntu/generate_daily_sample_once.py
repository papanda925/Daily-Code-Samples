#!/usr/bin/env python3
"""1日1本だけ新しい Daily Code sample を作る品質ゲート付きオーケストレーター。

設計上のポイント:
- mainの作業ツリーをAIへ直接触らせません。
- 一時git worktreeでCodexを動かし、品質検査に成功したcommitだけmainへ反映します。
- 同日二重生成を状態ファイルで防ぎます。
- 失敗しても既存ブログ処理やmainブランチを汚しません。
- コード量より、コメント・実験手順・「なぜ」の説明を優先します。
"""
from __future__ import annotations

import argparse
import csv
import datetime as dt
import json
import os
import re
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

SCRIPT_DIR = Path(__file__).resolve().parent
ROOT0 = SCRIPT_DIR.parents[1]

TRACKS = [
    "Daily Practical",
    "OS Fundamentals Lab",
    "Windows & Device Trace Lab",
    "Network & Wireless Lab",
    "Visual Security Lab",
    "Architecture & Algorithm Lab",
    "VBA Deep Dive",
    "PowerShell / WinRT / .NET Lab",
    "Legacy Data & File Format Lab",
    "Binary / Hex / Encoding Lab",
    "Language Basics Lab",
    "Built-in Tools & Scripting Map",
]


def run(
    args: list[str],
    cwd: Path,
    *,
    check: bool = True,
    input_text: str | None = None,
):
    """外部コマンドを実行し、stdout/stderrを必ず記録できる形で返す。"""
    return subprocess.run(
        args,
        cwd=cwd,
        text=True,
        input=input_text,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        check=check,
    )


def git(repo: Path, *args: str, check: bool = True):
    return run(["git", *args], repo, check=check)


def default_state_path() -> Path:
    base = Path(os.getenv("XDG_STATE_HOME", str(Path.home() / ".local" / "state")))
    return base / "daily-code-generator" / "state.json"


def load_state(path: Path) -> dict:
    if not path.exists():
        return {}
    return json.loads(path.read_text(encoding="utf-8"))


def save_state(path: Path, data: dict) -> None:
    """途中でOSが止まっても壊れにくいよう、一時ファイルから置き換える。"""
    path.parent.mkdir(parents=True, exist_ok=True)
    tmp = path.with_suffix(".tmp")
    tmp.write_text(
        json.dumps(data, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )
    tmp.replace(path)


def sample_dirs(repo: Path) -> list[Path]:
    result = []
    for path in (repo / "samples").iterdir():
        match = re.match(r"^(\d{3,})-", path.name)
        if path.is_dir() and match:
            result.append((int(match.group(1)), path))
    return [path for _, path in sorted(result)]


def next_id(repo: Path) -> int:
    ids = [
        int(re.match(r"^(\d+)-", path.name).group(1))
        for path in sample_dirs(repo)
    ]
    return max(ids, default=0) + 1


def recent_titles(repo: Path, count: int = 50) -> list[str]:
    """直近タイトルをPromptへ渡し、似たテーマの連続生成を減らす。"""
    titles = []
    for path in sample_dirs(repo)[-count:]:
        meta = path / "sample.json"
        if not meta.exists():
            continue
        try:
            data = json.loads(meta.read_text(encoding="utf-8-sig"))
        except (json.JSONDecodeError, OSError):
            continue
        if data.get("title"):
            titles.append(str(data["title"]))
    return titles


def target_track(sid: int) -> str:
    """同じ分野ばかり増えないよう、12 Trackを順番に回す。"""
    return TRACKS[(sid - 301) % len(TRACKS)]


def generation_prompt(repo: Path, sid: int, track: str) -> str:
    recent = "\n".join(f"- {title}" for title in recent_titles(repo))
    return f"""Daily-Code-Samples に新しいサンプル #{sid:03d} を1本だけ追加してください。

Track:
{track}

目的:
初心者・学生・オフィスワーカーが、短時間で実際に動かし、
「何が起きたか」「なぜそうなるか」を自分の目で確認できる教材を作る。

既存テーマとの重複を避けること。直近のタイトル:
{recent}

必須条件:
1. 作成してよいのは samples/{sid:03d}-<english-slug>/ 配下だけ。
2. README.md、sample.json、実際に試せるコードファイルを作る。
3. TODO、疑似コードだけ、空の関数、後で実装、は不可。
4. 1サンプル1概念。5〜30分で試せる大きさにする。
5. コードコメントを多めにする。
   - 何をしているか
   - なぜそのAPI・型・書き方を選んだか
   - 初心者が誤解しやすい点
   をコメントで説明する。
6. READMEは SAMPLE_STYLE_GUIDE.md と samples/_template/README.md に従う。
7. READMEにテスト1、テスト2を必ず入れる。
8. sample.json:
   - id = "{sid:03d}"
   - status = "sample"
   - maturity = "experimental"
   - article_ready = false
   - track = "{track}"
9. Windows / Office標準機能でできる場合は追加ソフトを要求しない。
10. Security / Networkは自分のPC・自分のデータ・localhost・自分のネットワークの観察に限定。
11. 実際の認証情報、秘密情報、実在する振込データ等は入れない。
12. 全銀等を題材にする場合は教育用ダミーであることを明記。
13. READMEに「今回触っている技術の層」を必ず入れる。
14. Windows PowerShell 5.1 / PowerShell 7 / Windows版など環境差を明記する。
15. コードを最後に読み直し、処理理由がコメントだけでも追える程度まで説明を追加する。

Git commit、git push、catalog更新、ルートREADME更新は行わないでください。
"""


def changed_paths(repo: Path) -> list[str]:
    output = git(repo, "status", "--porcelain").stdout
    result = []
    for line in output.splitlines():
        if not line.strip():
            continue
        result.append(line[3:].strip().split(" -> ")[-1])
    return result


def ensure_clean(repo: Path) -> None:
    if changed_paths(repo):
        raise RuntimeError(
            "main working tree is not clean; generation is skipped to protect manual work"
        )


def append_catalog(repo: Path, sample: Path) -> None:
    """validated sampleだけを検索カタログへ追加する。"""
    meta = json.loads((sample / "sample.json").read_text(encoding="utf-8-sig"))
    catalog = repo / "catalog" / "samples.csv"

    with catalog.open(encoding="utf-8-sig", newline="") as handle:
        rows = list(csv.reader(handle))

    if any(row and row[0] == str(meta["id"]) for row in rows[1:]):
        return

    rows.append([
        str(meta["id"]),
        dt.date.today().isoformat(),
        str(meta.get("track", "")),
        str(meta.get("title", "")),
        " / ".join(str(v) for v in meta.get("apps", [])),
        " / ".join(str(v) for v in meta.get("methods", [])),
        str(meta.get("level", "")),
        f"{meta.get('estimated_minutes', '')}分",
        str(sample.relative_to(repo)).replace("\\", "/"),
    ])

    with catalog.open("w", encoding="utf-8", newline="") as handle:
        csv.writer(handle).writerows(rows)


def validate_generated(worktree: Path, sample: Path) -> None:
    """README品質・秘密情報・想定外変更をcommit前に止める。"""
    quality = run(
        [
            sys.executable,
            "tools/validate_sample.py",
            "--sample",
            str(sample.relative_to(worktree)),
            "--strict",
        ],
        worktree,
        check=False,
    )
    if quality.returncode:
        raise RuntimeError(quality.stdout + quality.stderr)

    # check_public_safety.py はgit ls-filesを見るため、
    # 新規ファイルを一度stageしてから検査します。まだcommitはしません。
    git(
        worktree,
        "add",
        str(sample.relative_to(worktree)),
        "catalog/samples.csv",
    )
    safety = run(
        [sys.executable, "tools/check_public_safety.py"],
        worktree,
        check=False,
    )
    if safety.returncode:
        raise RuntimeError(safety.stdout + safety.stderr)


def create_in_worktree(
    main_repo: Path,
    codex: str,
    sid: int,
    track: str,
) -> tuple[str, str]:
    """一時worktreeで生成し、成功したcommit SHAとsample dirを返す。"""
    head = git(main_repo, "rev-parse", "HEAD").stdout.strip()

    with tempfile.TemporaryDirectory(prefix="daily-code-generator-") as temp_dir:
        worktree = Path(temp_dir) / "work"

        # mainを直接AIに編集させないことが最重要です。
        git(main_repo, "worktree", "add", "--detach", str(worktree), head)
        try:
            prompt = generation_prompt(worktree, sid, track)
            result = run(
                [
                    codex,
                    "exec",
                    "--ask-for-approval",
                    "never",
                    "--sandbox",
                    "workspace-write",
                    "-",
                ],
                worktree,
                check=False,
                input_text=prompt,
            )
            if result.returncode:
                raise RuntimeError(
                    "Codex generation failed:\n"
                    + (result.stderr or result.stdout)[-4000:]
                )

            prefix = f"samples/{sid:03d}-"
            changed = changed_paths(worktree)
            if not changed:
                raise RuntimeError("Codex completed but no sample was created")

            unexpected = [
                path for path in changed
                if not path.replace("\\", "/").startswith(prefix)
            ]
            if unexpected:
                raise RuntimeError(
                    "Codex changed files outside the new sample: "
                    + ", ".join(unexpected)
                )

            candidates = [
                path for path in sample_dirs(worktree)
                if path.name.startswith(f"{sid:03d}-")
            ]
            if len(candidates) != 1:
                raise RuntimeError(
                    f"expected exactly one sample folder for {sid:03d}"
                )
            sample = candidates[0]

            # sample自体を検査してからカタログへ追加します。
            quality = run(
                [
                    sys.executable,
                    "tools/validate_sample.py",
                    "--sample",
                    str(sample.relative_to(worktree)),
                    "--strict",
                ],
                worktree,
                check=False,
            )
            if quality.returncode:
                raise RuntimeError(quality.stdout + quality.stderr)

            append_catalog(worktree, sample)

            # Catalog以外へ追加変更が広がっていないことをもう一度確認します。
            allowed_root = str(sample.relative_to(worktree)).replace("\\", "/")
            for path in changed_paths(worktree):
                norm = path.replace("\\", "/")
                if norm == "catalog/samples.csv":
                    continue
                if norm == allowed_root or norm.startswith(allowed_root + "/"):
                    continue
                raise RuntimeError(f"unexpected generated change: {norm}")

            validate_generated(worktree, sample)

            git(
                worktree,
                "commit",
                "-m",
                f"feat: add Daily Code sample {sid:03d}",
            )
            commit_sha = git(worktree, "rev-parse", "HEAD").stdout.strip()
            return commit_sha, sample.name
        finally:
            # 失敗時も一時worktreeを削除し、mainへ未完了差分を残しません。
            git(
                main_repo,
                "worktree",
                "remove",
                "--force",
                str(worktree),
                check=False,
            )


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--dry-run", action="store_true")
    parser.add_argument("--no-push", action="store_true")
    parser.add_argument(
        "--force-today",
        action="store_true",
        help="同日実行ガードを無視する。通常運用では使わない。",
    )
    args = parser.parse_args()

    repo = Path(os.getenv("DAILY_CODE_REPO", str(ROOT0))).expanduser().resolve()
    branch = os.getenv("GIT_BRANCH", "main")
    codex = os.getenv("CODEX_BIN", "codex")
    state_file = Path(
        os.getenv("DAILY_SAMPLE_GENERATOR_STATE", str(default_state_path()))
    ).expanduser()
    today = dt.date.today().isoformat()

    pull = git(repo, "pull", "--ff-only", "origin", branch, check=False)
    if pull.returncode:
        raise SystemExit("git pull failed: " + pull.stderr.strip())
    ensure_clean(repo)

    state = load_state(state_file)
    if state.get("last_generated_date") == today and not args.force_today:
        print(json.dumps({
            "result": "already_generated_today",
            "sample_id": state.get("last_generated_sample"),
        }, ensure_ascii=False))
        return 0

    sid = next_id(repo)
    track = target_track(sid)

    if args.dry_run:
        print(json.dumps({
            "result": "dry_run",
            "next_id": f"{sid:03d}",
            "track": track,
            "recent_titles": len(recent_titles(repo)),
        }, ensure_ascii=False))
        return 0

    if shutil.which(codex) is None:
        raise SystemExit(f"Codex CLI not found: {codex}")

    try:
        commit_sha, sample_name = create_in_worktree(repo, codex, sid, track)

        if args.no_push:
            # テスト運用ではremoteへ送らず、ローカルmainだけfast-forwardします。
            git(repo, "merge", "--ff-only", commit_sha)
        else:
            # detached worktreeで作った検証済みcommitだけをmainへ送ります。
            git(
                repo,
                "push",
                "origin",
                f"{commit_sha}:refs/heads/{branch}",
            )
            git(repo, "pull", "--ff-only", "origin", branch)

        state.update({
            "last_generated_date": today,
            "last_generated_sample": f"{sid:03d}",
            "last_track": track,
            "last_commit": commit_sha,
            "pushed": not args.no_push,
            "updated_at": dt.datetime.now(dt.timezone.utc).isoformat(),
        })
        state.pop("last_failure", None)
        save_state(state_file, state)

        print(json.dumps({
            "result": "generated",
            "sample_id": f"{sid:03d}",
            "track": track,
            "sample_dir": sample_name,
            "commit": commit_sha,
            "pushed": not args.no_push,
        }, ensure_ascii=False))
        return 0

    except Exception as exc:
        # 後から原因を追えるよう、秘密情報を含まない範囲で失敗要約をstateへ残します。
        state["last_failure_at"] = dt.datetime.now(dt.timezone.utc).isoformat()
        state["last_failure"] = str(exc)[-3000:]
        save_state(state_file, state)
        print(f"Daily sample generation failed: {exc}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
