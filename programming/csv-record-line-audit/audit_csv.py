"""Count physical CSV lines and logical records without exposing cell contents."""

import argparse
import csv
import io
import re
from pathlib import Path

MAX_BYTES = 1024 * 1024  # 教材用: 最大1 MiB。大きな実データは扱わない。


class InvalidCsv(Exception):
    """入力形式が期待するCSVの条件を満たさない。"""


def audit(path: Path) -> dict[str, int]:
    # 元ファイルは読み取り専用。サイズ上限を確認してからメモリへ読む。
    if path.stat().st_size > MAX_BYTES:
        raise OSError("TOO_LARGE")
    raw = path.read_bytes()
    if len(raw) > MAX_BYTES:
        raise OSError("TOO_LARGE")

    # BOM付きUTF-8にも対応。置換デコードで不正なバイトを隠さない。
    text = raw.decode("utf-8-sig")
    # CRLFは1つの改行と数える。引用符内の改行も物理行として数える。
    breaks = len(re.findall(r"\r\n|\r|\n", text))
    physical = breaks + int(bool(text) and not text.endswith(("\r", "\n")))

    # csv.readerは引用符内の改行を1レコードの一部として処理する。
    reader = csv.reader(io.StringIO(text, newline=""), strict=True)
    header = next(reader, None)
    if not header:
        raise InvalidCsv("EMPTY_OR_NO_HEADER")

    records = 0
    multiline = 0
    previous_line = reader.line_num
    for row in reader:
        records += 1
        if len(row) != len(header):
            raise InvalidCsv("FIELD_COUNT_MISMATCH")
        if reader.line_num - previous_line > 1:
            multiline += 1
        previous_line = reader.line_num
    return {
        "physical_lines": physical,
        "csv_records": records,  # ヘッダーを除くデータレコード数
        "header_columns": len(header),
        "multiline_records": multiline,
    }


def main() -> int:
    parser = argparse.ArgumentParser(description="CSVの物理行数とレコード数を比較")
    parser.add_argument("file", type=Path, help="UTF-8 CSVのパス（読取りのみ）")
    args = parser.parse_args()
    try:
        result = audit(args.file)
    except (InvalidCsv, csv.Error, UnicodeError) as exc:
        # CSVの値や実ファイルパス、例外の本文は表示しない。
        issue = str(exc) if isinstance(exc, InvalidCsv) else "PARSE_OR_ENCODING_ERROR"
        print(f"STATUS=INVALID_CSV ISSUE={issue}")
        return 2
    except OSError as exc:
        issue = "TOO_LARGE" if str(exc) == "TOO_LARGE" else "READ_ERROR"
        print(f"STATUS=READ_ERROR ISSUE={issue}")
        return 3
    print("STATUS=OK")
    for key, value in result.items():
        print(f"{key.upper()}={value}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
