import csv
import tempfile
import unittest
from pathlib import Path
from atomic_csv import replace_csv


class TestCsv(unittest.TestCase):
    def test_new_and_existing(self):
        with tempfile.TemporaryDirectory() as t:
            path = Path(t) / "x.csv"
            replace_csv(path, [{"id": "A", "status": "DONE"}])
            replace_csv(path, [{"id": "B", "status": "WAIT"}])
            with path.open(encoding="utf-8", newline="") as f:
                self.assertEqual(list(csv.DictReader(f)), [
                    {"id": "B", "status": "WAIT"}
                ])

    def test_exception_preserves_existing_and_cleans_temporary(self):
        with tempfile.TemporaryDirectory() as t:
            path = Path(t) / "x.csv"
            path.write_text("id,status\nOLD,OK\n", encoding="utf-8")
            with self.assertRaises(ValueError):
                replace_csv(path, [
                    {"id": "A", "status": "DONE"}, {"id": "MISSING"}
                ])
            self.assertEqual(path.read_text(encoding="utf-8"),
                             "id,status\nOLD,OK\n")
            self.assertEqual(sorted(x.name for x in Path(t).iterdir()),
                             ["x.csv"])

    def test_multiline_field_quoted(self):
        with tempfile.TemporaryDirectory() as t:
            path = Path(t) / "x.csv"
            replace_csv(path, [{"id": "A", "status": "line1\nline2"}])
            with path.open(encoding="utf-8", newline="") as f:
                self.assertEqual(next(csv.DictReader(f))["status"],
                                 "line1\nline2")


if __name__ == "__main__":
    unittest.main()
