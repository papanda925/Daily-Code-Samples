#!/usr/bin/env python3
from __future__ import annotations

import argparse
import datetime as dt
import json
import os
import re
import subprocess
import sys
import tempfile
from pathlib import Path
from urllib.parse import urlparse

SCRIPT_DIR = Path(__file__).resolve().parent
REPO0 = SCRIPT_DIR.parents[1]
WP0 = Path("/var/www/wordpress")
EXT = {
    ".ps1": "powershell", ".bas": "vb", ".cls": "vb", ".py": "python",
    ".js": "javascript", ".json": "json", ".xml": "xml", ".html": "html",
    ".css": "css", ".sql": "sql", ".m": "text", ".txt": "text", ".csv": "csv",
}
FENCE = chr(96) * 3

def cmd(args, check=True):
    return subprocess.run(args, text=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, check=check)

def git(repo, *args, check=True):
    return cmd(["git", "-C", str(repo), *args], check)

def default_state_path():
    base = Path(os.getenv("XDG_STATE_HOME", str(Path.home() / ".local" / "state")))
    return base / "daily-code-wordpress" / "state.json"

def load(path):
    if not path.exists():
        return {"version": 1, "samples": {}}
    data = json.loads(path.read_text(encoding="utf-8"))
    data.setdefault("samples", {})
    return data

def save(path, data):
    path.parent.mkdir(parents=True, exist_ok=True)
    tmp = path.with_suffix(".tmp")
    tmp.write_text(json.dumps(data, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    tmp.replace(path)

def sample_id(path):
    match = re.match(r"^(\d{3,})-", path.name)
    if not match:
        raise ValueError(f"sample id not found: {path.name}")
    return match.group(1)

def sample_dirs(repo):
    result = []
    for path in (repo / "samples").iterdir():
        match = re.match(r"^(\d{3,})-", path.name)
        if path.is_dir() and match:
            result.append((int(match.group(1)), path))
    return [path for _, path in sorted(result)]

def title_of(markdown, sid):
    match = re.search(r"^#\s+(.+)$", markdown, re.M)
    title = match.group(1).strip() if match else f"Daily Code #{sid}"
    return re.sub(rf"^{re.escape(sid)}\s*[:：-]\s*", "", title)

def body_of(markdown):
    markdown = re.sub(r"^#\s+.*\n", "", markdown, count=1)
    markdown = re.sub(r"\n##\s+関連記事\s*\n.*\Z", "", markdown, flags=re.S)
    return markdown.strip()

def github_repo_slug(repo):
    configured = os.getenv("GITHUB_REPOSITORY", "").strip()
    if configured:
        return configured.removesuffix(".git")
    remote = git(repo, "remote", "get-url", "origin", check=False).stdout.strip()
    ssh = re.match(r"git@github\.com:([^/]+/[^/]+?)(?:\.git)?$", remote)
    if ssh:
        return ssh.group(1).removesuffix(".git")
    if remote.startswith("http"):
        parsed = urlparse(remote)
        if parsed.hostname == "github.com":
            return parsed.path.strip("/").removesuffix(".git")
    raise RuntimeError("Set GITHUB_REPOSITORY=owner/repository.")

def metadata_lines(metadata):
    """Turn sample.json's editorial metadata into a compact article brief."""
    labels = []
    for key, label in (("audience", "対象"), ("purposes", "目的"), ("apps", "環境"), ("methods", "方法"), ("tags", "タグ")):
        values = metadata.get(key) or []
        if isinstance(values, list) and values:
            labels.append(f"- {label}：{'、'.join(str(v) for v in values)}")
    if metadata.get("level"):
        labels.append(f"- 難しさ：{metadata['level']}")
    if metadata.get("estimated_minutes"):
        labels.append(f"- 所要時間：約{metadata['estimated_minutes']}分")
    return "\n".join(labels)

def article(sample, slug):
    sid = sample_id(sample)
    readme = (sample / "README.md").read_text(encoding="utf-8")
    metadata = sample["metadata"]
    title = f"Daily Code #{sid}：{title_of(readme, sid)}"
    brief = metadata_lines(metadata)
    output = [
        f"# {title}", "",
        "日々の事務作業や学習でそのまま試せる小さなサンプルを紹介する「Daily Code」です。",
        "", "## この記事の対象と前提", "", brief,
        "", body_of(readme),
    ]
    code_blocks = []
    for path in sorted(sample.iterdir()):
        if not path.is_file() or path.name.lower() in {"readme.md", "sample.json"} or path.name.startswith("."):
            continue
        try:
            text = path.read_text(encoding="utf-8")
        except UnicodeDecodeError:
            continue
        if len(text) > 120000:
            continue
        code_blocks += [f"### {path.name}", "", FENCE + EXT.get(path.suffix.lower(), "text"), text.rstrip(), FENCE, ""]
    if code_blocks:
        output += ["", "## サンプルコード", ""] + code_blocks
    url = f"https://github.com/{slug}/tree/main/samples/{sample.name}"
    output += [
        "", "## GitHubで確認する", "",
        f"最新のREADMEとソースコードは [Daily-Code-Samples #{sid}]({url}) で確認できます。",
        "", "## まとめ", "",
        "まずはそのまま動かし、次に値や条件を少し変えて試してください。業務利用時は実行環境と元データを十分確認してください。",
    ]
    return title, "\n".join(output).strip() + "\n"

def serialize(markdown, bot_root):
    if not bot_root.exists():
        raise RuntimeError("POSTBOT_ROOT is not configured or does not exist.")
    sys.path.insert(0, str(bot_root))
    # Use the production common entrance: normalizer -> Mermaid 11.9 parser
    # -> Gutenberg/MerPress serializer -> preflight. No Daily Code serializer.
    from utils.wordpress_content import prepare_markdown_for_wordpress, preflight_wordpress_content
    content = prepare_markdown_for_wordpress(markdown)
    preflight_wordpress_content(content)
    return content

def category(wp, wp_path):
    slug = os.getenv("DAILY_CODE_CATEGORY_SLUG", "daily-code")
    name = os.getenv("DAILY_CODE_CATEGORY_NAME", "Daily Code")
    result = cmd([wp, f"--path={wp_path}", "term", "get", "category", slug, "--by=slug", "--field=term_id"], False)
    if result.returncode == 0 and result.stdout.strip().isdigit():
        return int(result.stdout)
    return int(cmd([wp, f"--path={wp_path}", "term", "create", "category", name, f"--slug={slug}", "--porcelain"]).stdout)

def daily_slug(sid):
    return f"daily-code-{sid}"

def existing_post(wp, wp_path, sid):
    """Recover a prior post when local state was lost after WordPress success."""
    result = cmd([wp, f"--path={wp_path}", "post", "list", f"--name={daily_slug(sid)}",
                  "--post_status=any", "--format=json"], check=False)
    if result.returncode:
        raise RuntimeError("WordPress duplicate lookup failed")
    rows = json.loads(result.stdout or "[]")
    if len(rows) > 1:
        raise RuntimeError(f"multiple WordPress posts use Daily Code sample ID {sid}")
    if not rows:
        return None
    post_id = int(rows[0]["ID"])
    url = cmd([wp, f"--path={wp_path}", "eval", f"echo get_permalink({post_id});"]).stdout.strip()
    if not url.startswith("http"):
        raise RuntimeError("existing Daily Code post has no valid permalink")
    return post_id, url

def publish(wp, wp_path, title, content, status, category_id):
    with tempfile.NamedTemporaryFile("w", encoding="utf-8", suffix=".html", delete=False) as handle:
        handle.write(content)
        tmp = Path(handle.name)
    try:
        post_id = int(cmd([
            wp, f"--path={wp_path}", "post", "create", str(tmp),
            "--post_type=post", f"--post_status={status}",
            f"--post_title={title}", f"--post_name={daily_slug(re.search(r"Daily Code #(\d+)", title).group(1))}",
            f"--post_category={category_id}", "--porcelain",
        ]).stdout)
        actual = cmd([wp, f"--path={wp_path}", "post", "get", str(post_id), "--field=post_status"]).stdout.strip()
        if actual != status:
            raise RuntimeError(f"status mismatch: {actual}")
        url = cmd([wp, f"--path={wp_path}", "eval", f"echo get_permalink({post_id});"]).stdout.strip()
        if not url.startswith("http"):
            raise RuntimeError(f"bad permalink: {url}")
        return post_id, url
    finally:
        tmp.unlink(missing_ok=True)

def writeback(repo, sample, sid, url, branch, push=True):
    root = repo / "README.md"
    lines = root.read_text(encoding="utf-8").splitlines()
    changed = False
    for index, line in enumerate(lines):
        if re.match(rf"^\|\s*(?:\[{re.escape(sid)}\][^|]*|{re.escape(sid)})\s*\|", line):
            cells = [cell.strip() for cell in line.strip("|").split("|")]
            if len(cells) >= 6:
                cells[-1] = f"[記事]({url})"
                lines[index] = "| " + " | ".join(cells) + " |"
                changed = True
            break
    if changed:
        root.write_text("\n".join(lines) + "\n", encoding="utf-8")

    sample_readme = sample / "README.md"
    text = sample_readme.read_text(encoding="utf-8")
    link = f"[ブログの解説記事]({url})"
    updated = re.sub(r"(?:[A-Za-z0-9.-]+\\s*に)?解説記事を追加予定です。", link, text)
    if updated == text and link not in text:
        updated = text.rstrip() + "\n\n## 関連記事\n\n" + link + "\n"
    if updated != text:
        sample_readme.write_text(updated if updated.endswith("\n") else updated + "\n", encoding="utf-8")
        changed = True

    # Even when the link was already written by a failed prior attempt,
    # stage and retry any pending writeback diff.
    git(repo, "add", "README.md", str(sample_readme.relative_to(repo)))
    diff = git(repo, "diff", "--cached", "--quiet", check=False)
    if diff.returncode:
        git(repo, "commit", "-m", f"docs: add blog link for sample {sid}")
    if push:
        git(repo, "push", "origin", branch)
    return {"changed": True, "pushed": push}

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--dry-run", action="store_true")
    parser.add_argument("--no-push", action="store_true")
    parser.add_argument("--status", default=os.getenv("DAILY_CODE_WP_STATUS", "draft"), choices=["draft", "publish", "private"])
    args = parser.parse_args()

    repo = Path(os.getenv("DAILY_CODE_REPO", str(REPO0))).expanduser()
    bot_value = os.getenv("POSTBOT_ROOT", "").strip()
    bot_root = Path(bot_value).expanduser() if bot_value else Path("/nonexistent")
    wp_path = Path(os.getenv("WP_PATH", str(WP0))).expanduser()
    wp = os.getenv("WP_BIN", "wp")
    branch = os.getenv("GIT_BRANCH", "main")
    state_path = Path(os.getenv("DAILY_CODE_STATE", str(default_state_path()))).expanduser()

    pull = git(repo, "pull", "--ff-only", "origin", branch, check=False)
    if pull.returncode:
        raise SystemExit("git pull failed: " + pull.stderr.strip())

    state = load(state_path)
    sample = next((path for path in sample_dirs(repo)
                   if not state["samples"].get(sample_id(path), {}).get("wordpress_post_id")
                   or not state["samples"].get(sample_id(path), {}).get("github_writeback")), None)
    if not sample:
        print(json.dumps({"result": "no_pending_sample"}, ensure_ascii=False))
        return 0

    sid = sample_id(sample)
    row = state["samples"].setdefault(sid, {})

    if row.get("wordpress_post_id") and row.get("wordpress_url"):
        if args.dry_run:
            print(json.dumps({"result": "would_retry_writeback", "sample_id": sid}, ensure_ascii=False))
            return 0
        result = writeback(repo, sample, sid, row["wordpress_url"], branch, not args.no_push)
        row["github_writeback"] = bool(result["pushed"] or args.no_push)
        save(state_path, state)
        print(json.dumps({"result": "writeback_ok", "sample_id": sid, **result}, ensure_ascii=False))
        return 0

    title, markdown = article(sample, github_repo_slug(repo))
    if args.dry_run:
        print(json.dumps({
            "result": "dry_run", "sample_id": sid, "title": title,
            "markdown_chars": len(markdown), "wordpress_status": args.status,
        }, ensure_ascii=False))
        return 0

    content = serialize(markdown, bot_root)
    recovered = existing_post(wp, wp_path, sid)
    if recovered:
        post_id, url = recovered
        row.update({"sample_dir": sample.name, "wordpress_post_id": post_id,
                    "wordpress_url": url, "wordpress_status": args.status,
                    "github_writeback": False})
        save(state_path, state)
        result = writeback(repo, sample, sid, url, branch, not args.no_push)
        row["github_writeback"] = bool(result["pushed"] or args.no_push)
        save(state_path, state)
        print(json.dumps({"result": "recovered_existing_post", "sample_id": sid,
                          "post_id": post_id, "url": url, "github": result}, ensure_ascii=False))
        return 0
    post_id, url = publish(wp, wp_path, title, content, args.status, category(wp, wp_path))
    row.update({
        "sample_dir": sample.name, "wordpress_post_id": post_id,
        "wordpress_url": url, "wordpress_status": args.status,
        "published_at": dt.datetime.now(dt.timezone.utc).isoformat(),
        "github_writeback": False,
    })
    save(state_path, state)

    result = writeback(repo, sample, sid, url, branch, not args.no_push)
    row["github_writeback"] = bool(result["pushed"] or args.no_push)
    save(state_path, state)
    print(json.dumps({
        "result": "publish_ok", "sample_id": sid, "post_id": post_id,
        "url": url, "github": result,
    }, ensure_ascii=False))
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
