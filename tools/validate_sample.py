#!/usr/bin/env python3
"""Daily Code のサンプル構造と教材品質を確認する。

#001〜#300 は既存資産なので基本検査を行い、
#301以降は新しい作成ルールに合わせて厳格検査を行います。

このスクリプトの目的は「コードが絶対に正しい」と証明することではありません。
自動生成で起きやすい、README不足、ID不一致、コメント不足、TODO残りなどを
mainへ入る前に止めるための品質ゲートです。
"""
from __future__ import annotations

import argparse
import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SAMPLES = ROOT / "samples"

CODE_SUFFIXES = {".ps1", ".bas", ".cls", ".py", ".js", ".m"}
PLACEHOLDERS = ("TODO", "TBD", "あとで実装", "後で実装", "準備中")
STRICT_SECTIONS = (
    "## このサンプルで体験すること",
    "## なぜこの方法を使うのか",
    "## 実行前に確認すること",
    "## 実行手順",
    "## コードの流れ",
    "## 結果の見方",
    "### テスト1",
    "### テスト2",
    "## うまくいかないとき",
    "## 安全性",
    "## 今回触っている技術の層",
)


def folder_id(path: Path) -> str:
    match = re.match(r"^(\d{3,})-", path.name)
    if not match:
        raise ValueError(f"IDを読み取れません: {path.name}")
    return match.group(1)


def code_comment_count(path: Path, text: str) -> int:
    if path.suffix.lower() == ".ps1":
        return sum(1 for line in text.splitlines()
                   if line.strip().startswith("#") and not line.strip().startswith("#requires"))
    if path.suffix.lower() in {".bas", ".cls"}:
        return sum(1 for line in text.splitlines()
                   if line.strip().startswith("'"))
    if path.suffix.lower() in {".py", ".m"}:
        return sum(1 for line in text.splitlines() if line.strip().startswith("#"))
    if path.suffix.lower() == ".js":
        return sum(1 for line in text.splitlines()
                   if line.strip().startswith("//"))
    return 0


def validate(path: Path, strict: bool) -> list[str]:
    problems: list[str] = []
    sid = folder_id(path)
    readme_path = path / "README.md"
    meta_path = path / "sample.json"

    if not readme_path.exists():
        return [f"{path.name}: README.md がありません"]
    if not meta_path.exists():
        return [f"{path.name}: sample.json がありません"]

    readme = readme_path.read_text(encoding="utf-8-sig")
    try:
        meta = json.loads(meta_path.read_text(encoding="utf-8-sig"))
    except json.JSONDecodeError as exc:
        return [f"{path.name}: sample.json が不正です: {exc}"]

    if str(meta.get("id", "")) != sid:
        problems.append(f"{path.name}: sample.json id とフォルダーIDが一致しません")

    code_files = [
        p for p in path.iterdir()
        if p.is_file() and p.suffix.lower() in CODE_SUFFIXES
    ]
    if not code_files:
        problems.append(f"{path.name}: 実行・学習用コードファイルがありません")

    if not strict:
        return problems

    # #301以降は、READMEだけ読んでも実験できることを要求します。
    for section in STRICT_SECTIONS:
        if section not in readme:
            problems.append(f"{path.name}: READMEに必須見出しがありません: {section}")

    for placeholder in PLACEHOLDERS:
        if placeholder in readme:
            problems.append(f"{path.name}: READMEに未完成表現が残っています: {placeholder}")

    if meta.get("maturity") not in {"experimental", "stable"}:
        problems.append(f"{path.name}: maturity は experimental/stable のどちらかにします")
    if not isinstance(meta.get("article_ready"), bool):
        problems.append(f"{path.name}: article_ready は true/false で明記します")

    for key in ("track", "summary", "safety_scope"):
        if not str(meta.get(key, "")).strip():
            problems.append(f"{path.name}: sample.json の {key} が空です")

    for code_path in code_files:
        text = code_path.read_text(encoding="utf-8-sig")
        nonblank = [line for line in text.splitlines() if line.strip()]
        comments = code_comment_count(code_path, text)

        # Daily Codeは短いサンプルを基本にします。大きくなったら複数サンプルへ分割します。
        if len(nonblank) > 180:
            problems.append(
                f"{path.name}/{code_path.name}: {len(nonblank)}行あります。1概念1サンプルへ分割を検討してください"
            )

        # コメントなしの「動けばよい」コードを自動生成しないための最低ラインです。
        if len(nonblank) >= 8 and comments < 3:
            problems.append(
                f"{path.name}/{code_path.name}: 解説コメントが{comments}行しかありません。最低3行入れてください"
            )

        if not any(word in text for word in ("ため", "理由", "ここでは", "なぜ", "注意")):
            problems.append(
                f"{path.name}/{code_path.name}: 『なぜこの処理をするか』が分かるコメントを追加してください"
            )

        for placeholder in PLACEHOLDERS:
            if placeholder in text:
                problems.append(
                    f"{path.name}/{code_path.name}: 未完成表現が残っています: {placeholder}"
                )

    return problems


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--sample", help="samples/301-... またはフォルダー名")
    parser.add_argument("--strict", action="store_true")
    parser.add_argument("--all", action="store_true")
    args = parser.parse_args()

    if args.sample:
        path = Path(args.sample)
        if not path.is_absolute():
            if path.parts and path.parts[0] == "samples":
                path = ROOT / path
            else:
                path = SAMPLES / path
        targets = [path]
    elif args.all:
        targets = sorted(
            p for p in SAMPLES.iterdir()
            if p.is_dir() and re.match(r"^\d{3,}-", p.name)
        )
    else:
        parser.error("--sample または --all を指定してください")

    problems: list[str] = []
    for path in targets:
        sid = int(folder_id(path))
        # 明示的な --strict、または新ルール開始の#301以降を厳格検査します。
        strict = args.strict or sid >= 301
        problems.extend(validate(path, strict))

    if problems:
        print("Sample quality check FAILED:")
        for problem in problems:
            print(f" - {problem}")
        return 1

    print(f"Sample quality check OK: {len(targets)} sample(s)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
