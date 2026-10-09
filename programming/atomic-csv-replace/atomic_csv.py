"""Safe CSV replacement for a single writer, Python 3.10+."""
from __future__ import annotations

import csv
import os
import tempfile
from pathlib import Path
from collections.abc import Iterable, Mapping

COLUMNS = ("id", "status")


def replace_csv(target: Path, rows: Iterable[Mapping[str, str]]) -> None:
    """Write a complete CSV in target's directory, then replace its name.

    Does not guarantee that a rename survives sudden loss of power.
    Concurrent writers and external file locks require separate handling.
    """
    target = Path(target)
    temporary: Path | None = None
    try:
        with tempfile.NamedTemporaryFile(
            mode="w", encoding="utf-8", newline="", delete=False,
            dir=target.parent, prefix=f".{target.name}.", suffix=".tmp"
        ) as fp:
            temporary = Path(fp.name)
            writer = csv.DictWriter(fp, fieldnames=COLUMNS, extrasaction="raise")
            writer.writeheader()
            for row in rows:
                if set(row) != set(COLUMNS):
                    raise ValueError("CSV row must have exactly id and status")
                writer.writerow(row)
            fp.flush()
            os.fsync(fp.fileno())
        os.replace(temporary, target)
        temporary = None
    finally:
        if temporary is not None:
            temporary.unlink(missing_ok=True)


if __name__ == "__main__":
    with tempfile.TemporaryDirectory(prefix="csv-atomic-demo-") as folder:
        csv_path = Path(folder) / "batch.csv"
        csv_path.write_text("id,status\nold,OLD\n", encoding="utf-8")
        replace_csv(csv_path, (
            {"id": "A-001", "status": "DONE"},
            {"id": "A-002", "status": "PENDING"},
        ))
        with csv_path.open(newline="", encoding="utf-8") as fp:
            entries = list(csv.DictReader(fp))
        print(f"[RESULT] rows={len(entries)} ids={[x['id'] for x in entries]}")
