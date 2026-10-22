#!/usr/bin/env python3
"""CSVの列名衝突を、データを変更せずに確認する。Python 3.10+。"""
from __future__ import annotations

import argparse
import csv
import sys
import unicodedata
from pathlib import Path


def audit(path: Path, *, exact: bool = False) -> tuple[int, list[int], list[tuple[int, int]]]:
    # newline="" はcsvモジュールが改行と引用符を扱うために必要。
    # utf-8-sig はUTF-8 BOMがあっても先頭列名にBOMを混ぜない。
    with path.open("r", encoding="utf-8-sig", newline="") as stream:
        header = next(csv.reader(stream, strict=True), None)
    if header is None:
        raise ValueError("CSVにヘッダー行がありません")

    first: dict[str, int] = {}
    blanks: list[int] = []
    duplicates: list[tuple[int, int]] = []
    for position, label in enumerate(header, 1):
        # 既定では全角・半角や大小文字などの表記揺れも衝突候補にする。
        # この正規化は業務上の列名同一性を保証しないため、--exactも用意する。
        key = label if exact else unicodedata.normalize("NFKC", label).strip().casefold()
        if not key:
            blanks.append(position)
        elif key in first:
            duplicates.append((first[key], position))
        else:
            first[key] = position
    return len(header), blanks, duplicates


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description="CSVのヘッダー列名衝突を読み取り専用で検査")
    parser.add_argument("csv_file", type=Path, help="UTF-8 CSVファイル")
    parser.add_argument("--exact", action="store_true", help="正規化せず完全一致だけ検査")
    args = parser.parse_args(argv)
    try:
        count, blanks, duplicates = audit(args.csv_file, exact=args.exact)
    except (OSError, UnicodeError, csv.Error, ValueError) as exc:
        # 元ファイルの内容や秘密情報をエラー出力へ複製しない。
        print(f"ERROR: CSVを検査できません ({type(exc).__name__})", file=sys.stderr)
        return 2
    if blanks or duplicates:
        print(f"FAILED: columns={count} blank_positions={blanks} duplicate_pairs={duplicates}")
        return 1
    print(f"OK: columns={count} duplicate_pairs=[] blank_positions=[]")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
