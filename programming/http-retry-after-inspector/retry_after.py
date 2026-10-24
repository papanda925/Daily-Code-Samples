#!/usr/bin/env python3
"""Inspect an HTTP Retry-After header without network access or sleeping."""

import argparse
import json
import re
import sys
from datetime import datetime, timedelta, timezone
from email.utils import parsedate_to_datetime
from math import ceil

IMF_FIXDATE = re.compile(
    r"(?:Mon|Tue|Wed|Thu|Fri|Sat|Sun), "
    r"\d{2} (?:Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec) "
    r"\d{4} \d{2}:\d{2}:\d{2} GMT\Z"
)
SECONDS = re.compile(r"[0-9]+\Z")


def parse_retry_after(value: str, now: datetime) -> tuple[int, datetime, str]:
    """Return (whole seconds to wait, UTC target, representation).

    Supports non-negative delay-seconds and IMF-fixdate (a common HTTP-date form).
    Rejects obsolete HTTP-date forms rather than guessing their meaning.
    """
    if now.tzinfo is None or now.utcoffset() is None:
        raise ValueError("now must have a timezone offset")
    now = now.astimezone(timezone.utc)
    value = value.strip(" \t")
    if SECONDS.fullmatch(value):
        seconds = int(value)
        try:
            target = now + timedelta(seconds=seconds)
        except OverflowError as exc:
            raise ValueError("delay-seconds exceeds supported datetime range") from exc
        return seconds, target, "delay-seconds"
    if not IMF_FIXDATE.fullmatch(value):
        raise ValueError("expected non-negative integer or IMF-fixdate ending in GMT")
    try:
        target = parsedate_to_datetime(value)
    except (TypeError, ValueError, OverflowError) as exc:
        raise ValueError("invalid IMF-fixdate") from exc
    if target is None or target.tzinfo is None:
        raise ValueError("invalid timezone in HTTP-date")
    target = target.astimezone(timezone.utc)
    # parsedate_to_datetime does not enforce weekday consistency: check explicitly.
    if target.strftime("%a") != value[:3]:
        raise ValueError("weekday does not match calendar date")
    return max(0, ceil((target - now).total_seconds())), target, "http-date"


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("value", help="Retry-After header value, e.g. 120")
    parser.add_argument("--now", help="fixed ISO 8601 reference instant with offset, for testing")
    args = parser.parse_args(argv)
    try:
        now = datetime.fromisoformat(args.now) if args.now else datetime.now(timezone.utc)
        seconds, target, kind = parse_retry_after(args.value, now)
    except ValueError as exc:
        print(f"INVALID_RETRY_AFTER: {exc}", file=sys.stderr)
        return 2
    print(json.dumps({
        "kind": kind,
        "wait_seconds": seconds,
        "target_utc": target.isoformat().replace("+00:00", "Z"),
        "action": "inspect_only_no_sleep_no_request",
    }, ensure_ascii=False))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
