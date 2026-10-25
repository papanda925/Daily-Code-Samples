#!/usr/bin/env python3
"""Read-only line-ending audit; never changes input files."""
import argparse
from pathlib import Path


def count_endings(data: bytes) -> dict[str, int]:
    crlf = data.count(b'\r\n')
    lf = data.count(b'\n') - crlf
    cr = data.count(b'\r') - crlf
    return {'CRLF': crlf, 'LF': lf, 'CR': cr}


def main() -> int:
    parser = argparse.ArgumentParser(description='Inspect CRLF/LF/CR in a file without editing it')
    parser.add_argument('path', type=Path)
    args = parser.parse_args()
    try:
        data = args.path.read_bytes()
    except OSError as exc:
        parser.error(str(exc))
    result = count_endings(data)
    for kind, number in result.items():
        print(f'{kind}: {number}')
    return 1 if sum(value > 0 for value in result.values()) > 1 else 0


if __name__ == '__main__':
    raise SystemExit(main())
