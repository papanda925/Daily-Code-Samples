#!/usr/bin/env python3
"""Read-only ZIP metadata preflight. It never extracts archive members."""
import argparse
from collections import Counter
from pathlib import PureWindowsPath
import stat
import sys
from zipfile import BadZipFile, ZipFile


def audit_zip(path, max_entries=1000, max_bytes=100_000_000, max_ratio=100):
    """Return (entry_count, declared_uncompressed_bytes, findings)."""
    findings = []
    names = Counter()
    total = 0
    with ZipFile(path, "r") as archive:
        entries = archive.infolist()  # metadata only: no read(), extract(), or extractall()
        if len(entries) > max_entries:
            findings.append(f"entry_count_exceeded:{len(entries)}>{max_entries}")
        for info in entries:
            name = info.filename
            total += info.file_size
            normalized = name.replace("\\", "/").rstrip("/")
            parts = normalized.split("/")
            # Windows drive/UNC and POSIX absolute paths need separate checks.
            windows = PureWindowsPath(name)
            if not name or name.startswith(("/", "\\")) or windows.drive or windows.root:
                findings.append(f"absolute_or_drive_path:{name!r}")
            if any(part in ("", ".", "..") or ":" in part for part in parts):
                findings.append(f"unsafe_path_component:{name!r}")
            # Windows commonly uses case-insensitive filenames; flag potential collisions.
            key = normalized.casefold()
            names[key] += 1
            if names[key] > 1:
                findings.append(f"duplicate_or_case_collision:{name!r}")
            if info.create_system == 3 and stat.S_ISLNK(info.external_attr >> 16):
                findings.append(f"unix_symlink:{name!r}")
            if info.file_size > 0 and info.file_size / max(info.compress_size, 1) > max_ratio:
                findings.append(f"compression_ratio_exceeded:{name!r}")
        if total > max_bytes:
            findings.append(f"declared_size_exceeded:{total}>{max_bytes}")
    return len(entries), total, findings


def main(argv=None):
    parser = argparse.ArgumentParser(description="Inspect ZIP metadata without extracting")
    parser.add_argument("zip_path", help="Existing ZIP archive to inspect")
    parser.add_argument("--max-entries", type=int, default=1000)
    parser.add_argument("--max-bytes", type=int, default=100_000_000)
    parser.add_argument("--max-ratio", type=float, default=100)
    args = parser.parse_args(argv)
    if args.max_entries < 1 or args.max_bytes < 1 or args.max_ratio < 1:
        parser.error("limits must be positive (>=1)")
    try:
        count, total, findings = audit_zip(args.zip_path, args.max_entries, args.max_bytes, args.max_ratio)
    except (OSError, BadZipFile, ValueError) as exc:
        print(f"ERROR: {type(exc).__name__}: {exc}", file=sys.stderr)
        return 2
    print(f"entries={count} declared_uncompressed_bytes={total}")
    for finding in findings:
        print(f"WARN: {finding}")
    print("RESULT=REVIEW_REQUIRED" if findings else "RESULT=NO_METADATA_FLAGS")
    return 1 if findings else 0


if __name__ == "__main__":
    raise SystemExit(main())
