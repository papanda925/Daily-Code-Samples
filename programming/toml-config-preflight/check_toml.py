#!/usr/bin/env python3
"""Read-only, privacy-preserving preflight for a small demo TOML config.

Only [app] with name (nonempty str), enabled (bool), retries (int 0..10)
is required. Unknown keys are allowed and their values are never displayed.
"""
from __future__ import annotations

import argparse
from pathlib import Path
import sys
import tomllib

MAX_BYTES = 64 * 1024


def validate_data(data: object) -> str | None:
    """Return a stable issue code, never a configuration value."""
    if not isinstance(data, dict):
        return "INVALID_DOCUMENT"
    app = data.get("app")
    if not isinstance(app, dict):
        return "MISSING_APP_TABLE"
    if "name" not in app:
        return "MISSING_NAME"
    if not isinstance(app["name"], str) or not app["name"].strip():
        return "INVALID_NAME"
    if "enabled" not in app:
        return "MISSING_ENABLED"
    if type(app["enabled"]) is not bool:
        return "INVALID_ENABLED"
    if "retries" not in app:
        return "MISSING_RETRIES"
    # bool is a subclass of int in Python; exact type comparison is intentional.
    if type(app["retries"]) is not int or not 0 <= app["retries"] <= 10:
        return "INVALID_RETRIES"
    return None


def check_path(path: Path) -> tuple[int, str]:
    """Return (exit status, safe one-line output). Never print file contents."""
    if path.is_symlink():
        return 2, "STATUS=INVALID ISSUE=SYMLINK_NOT_ALLOWED"
    try:
        if not path.is_file():
            return 3, "STATUS=IO_ERROR ISSUE=NOT_REGULAR_FILE"
        with path.open("rb") as stream:
            raw = stream.read(MAX_BYTES + 1)
    except OSError:
        return 3, "STATUS=IO_ERROR ISSUE=READ_FAILED"
    if len(raw) > MAX_BYTES:
        return 2, "STATUS=INVALID ISSUE=FILE_TOO_LARGE"
    try:
        data = tomllib.loads(raw.decode("utf-8"))
    except UnicodeDecodeError:
        return 2, "STATUS=INVALID ISSUE=INVALID_UTF8"
    except tomllib.TOMLDecodeError:
        return 2, "STATUS=INVALID ISSUE=INVALID_TOML"
    issue = validate_data(data)
    if issue:
        return 2, f"STATUS=INVALID ISSUE={issue}"
    return 0, "STATUS=VALID CHECKS=APP_NAME_ENABLED_RETRIES"


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description="Read-only TOML preflight; never prints values")
    parser.add_argument("path", type=Path, help="Path to a local demo TOML file")
    args = parser.parse_args(argv)
    code, line = check_path(args.path)
    print(line)
    return code


if __name__ == "__main__":
    sys.exit(main())
