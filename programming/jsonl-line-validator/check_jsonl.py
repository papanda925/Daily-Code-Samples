#!/usr/bin/env python3
"""Read-only JSON Lines validator; never prints the input records."""
import argparse
import json
import sys
from pathlib import Path

MAX_LINE_BYTES = 1024 * 1024


def reject_nonfinite(value):
    """Python accepts NaN/Infinity by default, but JSON does not."""
    raise ValueError("non-finite JSON number")


def validate(path, max_errors=20):
    """Return (valid_lines, total_lines, issues). No input content is logged."""
    if max_errors < 1:
        raise ValueError("max_errors must be positive")
    issues = []
    valid = total = 0
    with Path(path).open("rb") as stream:
        while True:
            raw = stream.readline(MAX_LINE_BYTES + 1)
            if not raw:
                break
            total += 1
            if len(raw) > MAX_LINE_BYTES:
                issues.append((total, "LINE_TOO_LONG"))
                break  # Cannot safely recover a line boundary after the limit.
            if total == 1 and raw.startswith(b"\xef\xbb\xbf"):
                issues.append((total, "UTF8_BOM"))
                raw = raw[3:]
            if not raw.strip():
                issues.append((total, "BLANK_LINE"))
            else:
                try:
                    text = raw.decode("utf-8", errors="strict")
                except UnicodeDecodeError:
                    issues.append((total, "INVALID_UTF8"))
                else:
                    try:
                        json.loads(text, parse_constant=reject_nonfinite)
                    except json.JSONDecodeError:
                        issues.append((total, "INVALID_JSON"))
                    except ValueError:
                        issues.append((total, "NONFINITE_NUMBER"))
                    else:
                        valid += 1
            if len(issues) >= max_errors:
                break
    if total == 0:
        issues.append((0, "EMPTY_FILE"))  # Tool policy, not a JSON Lines format rule.
    return valid, total, issues


def main(argv=None):
    parser = argparse.ArgumentParser(description="Read-only JSONL line validator")
    parser.add_argument("file", type=Path, help="Existing .jsonl file to inspect")
    parser.add_argument("--max-errors", type=int, default=20)
    args = parser.parse_args(argv)
    if args.max_errors < 1:
        parser.error("--max-errors must be 1 or greater")
    try:
        valid, total, issues = validate(args.file, args.max_errors)
    except OSError as exc:
        print(f"STATUS=READ_ERROR ERROR_TYPE={type(exc).__name__}")
        return 3
    for line, reason in issues:
        print(f"LINE={line} ISSUE={reason}")
    print(f"STATUS={'INVALID' if issues else 'VALID'} VALID={valid} READ={total} ERRORS={len(issues)}")
    return 2 if issues else 0


if __name__ == "__main__":
    sys.exit(main())
