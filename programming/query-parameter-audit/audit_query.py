#!/usr/bin/env python3
"""Inspect a dummy URL query string without making requests or printing values."""

from __future__ import annotations

import argparse
from collections import Counter
from dataclasses import dataclass
from urllib.parse import parse_qsl

MAX_CHARS = 4096
MAX_FIELDS = 100
_HEX = frozenset("0123456789abcdefABCDEF")


class QueryProblem(ValueError):
    """A fixed error code that never includes query data."""


def _check_percent_escapes(query: str) -> None:
    # parse_qsl does not reject malformed percent escapes, so check separately.
    for i, ch in enumerate(query):
        if ch == "%" and (
            i + 2 >= len(query)
            or query[i + 1] not in _HEX
            or query[i + 2] not in _HEX
        ):
            raise QueryProblem("INVALID_PERCENT_ESCAPE")


@dataclass(frozen=True)
class Summary:
    fields: int
    unique_keys: int
    duplicate_keys: int
    extra_occurrences: int
    blank_values: int


def audit(query: str) -> Summary:
    """Validate only a query component, preserving repeated keys and blanks."""
    if not isinstance(query, str):
        raise QueryProblem("INVALID_INPUT")
    if len(query) > MAX_CHARS:
        raise QueryProblem("QUERY_TOO_LONG")
    if query.count("&") + 1 > MAX_FIELDS and query:
        raise QueryProblem("FIELD_LIMIT")
    _check_percent_escapes(query)
    try:
        pairs = parse_qsl(
            query,
            keep_blank_values=True,
            strict_parsing=True,
            encoding="utf-8",
            errors="strict",
            max_num_fields=MAX_FIELDS,
            separator="&",
        )
    except UnicodeDecodeError as exc:
        raise QueryProblem("INVALID_UTF8") from exc
    except ValueError as exc:
        # Do not leak the library's exception message, which may include input.
        raise QueryProblem("INVALID_FIELD") from exc

    if any(not key for key, _ in pairs):
        raise QueryProblem("EMPTY_KEY")
    counts = Counter(key for key, _ in pairs)
    return Summary(
        fields=len(pairs),
        unique_keys=len(counts),
        duplicate_keys=sum(n > 1 for n in counts.values()),
        extra_occurrences=sum(n - 1 for n in counts.values()),
        blank_values=sum(value == "" for _, value in pairs),
    )


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(
        description="Inspect a dummy query string locally (no network; no values printed)."
    )
    parser.add_argument(
        "--query", required=True,
        help="Query component only, without '?' (use dummy data, not tokens).",
    )
    args = parser.parse_args(argv)
    try:
        result = audit(args.query)
    except QueryProblem as exc:
        print(f"STATUS=INVALID ISSUE={exc}")
        return 2
    print(
        f"STATUS=VALID FIELDS={result.fields} UNIQUE_KEYS={result.unique_keys} "
        f"DUPLICATE_KEYS={result.duplicate_keys} "
        f"EXTRA_OCCURRENCES={result.extra_occurrences} "
        f"BLANK_VALUES={result.blank_values}"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
