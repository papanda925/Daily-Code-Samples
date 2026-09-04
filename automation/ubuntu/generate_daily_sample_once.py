#!/usr/bin/env python3
"""1日1本だけ新しい Daily Code sample を作るためのオーケストレーター。

重要:
- このスクリプト自身が教材コードを捏造するのではなく、Codex CLIへ作成条件を渡します。
- Codexが変更してよい場所を新しい sample フォルダーだけに限定します。
- 生成後に品質検査とPublic safety checkを通し、成功時だけcommit/pushします。
- 同じ日に2回実行されても、既定では2本作らないよう状態ファイルで止めます。

本番固有のパスや認証情報は環境変数・Git設定側に置き、この公開ファイルへ書きません。
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


def run(args: list[str], cwd: Path, *, check: bool = True, input_text: str | None = None):
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


def state_path() -> Path:
    base = Path(os.getenv("XDG_STATE_HOME", str(Path.home() / ".local" / "state")))
    return Path(os.getenv(
        "DAILY_SAMPLE_GENERATOR_STATE",
        str(base / "daily-code-generator" / "state.json"),
    )).expanduser()


def load_state(path: Path) -> dict:
    if not path.exists():
        return {}
    return json.loads(path.read_text(encoding="utf-8"))


def save_state(path: Path, data: dict) -> None:
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
    ids = [int(re.match(r"^(\d+)-", p.name).group(1)) for p in sample_dirs(repo)]
    return max(ids, default=0) + 1


def recent_titles(repo: Path, count: int = 40) -> list[str]:
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
    # Trackを固定順で回すことで、Excelだけ・Securityだけなどの偏りを避けます。
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

必ず守ること:
1. 作成してよいのは samples/{sid:03d}-<english-slug>/ 配下だけ。
2. README.md、sample.json、実際に試せるコードファイルを作る。
3. TODO、疑似コードだけ、空の関数、後で実装、は不可。
4. 1サンプル1概念。コードは短く保つ。
5. コードコメントを多めにする。
   - 何をするか
   - なぜそのAPI/書き方を使うか
   - 初心者が誤解しやすい点
   をコード内コメントで説明する。
6. READMEは SAMPLE_STYLE_GUIDE.md と samples/_template/README.md に従う。
7. READMEにテスト1、テスト2を必ず入れる。
8. sample.json:
   - id = "{sid:03d}"
   - status = "sample"
   - maturity = "experimental"
   - article_ready = false
   - track = "{track}"
   - changes_pc_settings / requires_admin を正しく設定
9. Windows / Office標準機能だけでできる場合は追加ソフトを要求しない。
10. Security / Networkは自分のPC・自分のデータ・localhost・自分のネットワークの観察に限定。
11. 実際の認証情報、秘密情報、実在する振込データ等は入れない。
12. 全銀等を題材にする場合は教育用ダミーであることを明記。
13. READMEには「今回触っている技術の層」を必ず入れる。
14. 実行環境差がある場合は Windows PowerShell 5.1 / PowerShell 7 / Windows版などを明記。

作成後、自分でREADMEとコードを読み直し、説明不足の箇所にはコメントを追加してください。
Git commit、git push、catalog更新、READMEルート更新は行わないでください。
"""


def changed_paths(repo: Path) -> list[str]:
    output = git(repo, "status", "--porcelain").stdout
    result = []
    for line in output.splitlines():
        if not line.strip():
            continue
        # porcelainはXYの後にパスが続きます。
        result.append(line[3:].strip().split(" -> ")[-1])
    return result


def append_catalog(repo: Path, sample: Path) -> None:
    meta = json.loads((sample / "sample.json").read_text(encoding="utf-8-sig"))
    catalog = repo / "catalog" / "samples.csv"
    rows = list(csv.reader(catalog.open(encoding="utf-8-sig", newline="")))
    if any(row and row[0] == str(meta["id"]) for row in rows[1:]):
        return

    apps = " / ".join(str(v) for v in meta.get("apps", []))
    methods = " / ".join(str(v) for v in meta.get("methods", []))
    rows.append([
        str(meta["id"]),
        dt.date.today().isoformat(),
        str(meta.get("track", "")),
        str(meta.get("title", "")),
        apps,
        methods,
        str(meta.get("level", "")),
        f"{meta.get('estimated_minutes', '')}分",
        str(sample.relative_to(repo)).replace("\\", "/"),
    ])

    with catalog.open("w", encoding="utf-8", newline="") as handle:
        csv.writer(handle).writerows(rows)


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--dry-run", action="store_true")
    parser.add_argument("--no-push", action="store_true")
    parser.add_argument("--force-today", action="store_true",
                        help="同日実行ガードを無視する。通常運用では使わない。")
    args = parser.parse_args()

    repo = Path(os.getenv("DAILY_CODE_REPO", str(ROOT0))).expanduser().resolve()
    branch = os.getenv("GIT_BRANCH", "main")
    codex = os.getenv("CODEX_BIN", "codex")
    state_file = state_path()
    today = dt.date.today().isoformat()

    # 自動生成前に必ず最新mainへ合わせます。
    pull = git(repo, "pull", "--ff-only", "origin", branch, check=False)
    if pull.returncode:
        raise SystemExit("git pull failed: " + pull.stderr.strip())

    # 人が作業中の差分へAIの変更を混ぜないため、clean treeを必須にします。
    if changed_paths(repo):
        raise SystemExit("working tree is not clean; daily generation is skipped")

    state = load_state(state_file)
    if state.get("last_generated_date") == today and not args.force_today:
        print(json.dumps({
            "result": "already_generated_today",
            "sample_id": state.get("last_generated_sample"),
        }, ensure_ascii=False))
        return 0

    sid = next_id(repo)
    track = target_track(sid)
    prompt = generation_prompt(repo, sid, track)

    if args.dry_run:
        print(json.dumps({
            "result": "dry_run",
            "next_id": f"{sid:03d}",
            "track": track,
            "prompt_chars": len(prompt),
        }, ensure_ascii=False))
        return 0

    if shutil.which(codex) is None:
        raise SystemExit(f"Codex CLI not found: {codex}")

    # workspace-writeに限定します。生成処理にホスト全体への権限は不要です。
    result = run(
        [codex, "exec", "--ask-for-approval", "never",
         "--sandbox", "workspace-write", "-"],
        repo,
        check=False,
        input_text=prompt,
    )
    if result.returncode:
        raise SystemExit("Codex generation failed:\n" + result.stderr[-4000:])

    prefix = f"samples/{sid:03d}-"
    changed = changed_paths(repo)
    if not changed:
        raise SystemExit("Codex completed but no sample files were created")

    # AIが指示外ファイルへ触れた場合は自動pushを止めます。
    unexpected = [p for p in changed if not p.replace("\\", "/").startswith(prefix)]
    if unexpected:
        raise SystemExit(
            "unexpected files changed; review required: " + ", ".join(unexpected)
        )

    candidates = [
        p for p in sample_dirs(repo)
        if p.name.startswith(f"{sid:03d}-")
    ]
    if len(candidates) != 1:
        raise SystemExit(f"expected exactly one sample folder for {sid:03d}")
    sample = candidates[0]

    # #301以降の厳格ルールを満たさなければcommitしません。
    validate = run(
        [sys.executable, "tools/validate_sample.py",
         "--sample", str(sample.relative_to(repo)), "--strict"],
        repo,
        check=False,
    )
    if validate.returncode:
        raise SystemExit(validate.stdout + validate.stderr)

    safety = run(
        [sys.executable, "tools/check_public_safety.py"],
        repo,
        check=False,
    )
    if safety.returncode:
        raise SystemExit(safety.stdout + safety.stderr)

    append_catalog(repo, sample)

    # catalog更新後にも意図しない変更がないことを再確認します。
    allowed = {str(sample.relative_to(repo)).replace("\\", "/"), "catalog/samples.csv"}
    for path in changed_paths(repo):
        norm = path.replace("\\", "/")
        if not any(norm == a or norm.startswith(a + "/") for a in allowed):
            raise SystemExit(f"unexpected change after validation: {norm}")

    git(repo, "add", str(sample.relative_to(repo)), "catalog/samples.csv")
    git(repo, "commit", "-m", f"feat: add Daily Code sample {sid:03d}")
    if not args.no_push:
        git(repo, "push", "origin", branch)

    state.update({
        "last_generated_date": today,
        "last_generated_sample": f"{sid:03d}",
        "last_track": track,
        "pushed": not args.no_push,
        "updated_at": dt.datetime.now(dt.timezone.utc).isoformat(),
    })
    save_state(state_file, state)

    print(json.dumps({
        "result": "generated",
        "sample_id": f"{sid:03d}",
        "track": track,
        "sample_dir": sample.name,
        "pushed": not args.no_push,
    }, ensure_ascii=False))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
