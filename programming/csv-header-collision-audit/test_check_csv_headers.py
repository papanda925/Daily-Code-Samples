"""外部ファイルを書き換えず、使い捨てのCSVで境界条件を検証する。"""
import tempfile
import unittest
from pathlib import Path
from check_csv_headers import audit, main


class CsvHeaderAuditTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.path = Path(self.temp.name) / "sample.csv"

    def write(self, data: bytes):
        self.path.write_bytes(data)

    def test_unique(self):
        self.write(b"id,name,amount\n1,A,3\n")
        self.assertEqual(audit(self.path), (3, [], []))
        self.assertEqual(main([str(self.path)]), 0)

    def test_duplicate_exact(self):
        self.write(b"id,name,id\n")
        self.assertEqual(audit(self.path), (3, [], [(1, 3)]))
        self.assertEqual(main([str(self.path)]), 1)

    def test_normalized_collision_and_exact_override(self):
        self.write("Code,ＣＯＤＥ\n".encode("utf-8"))
        self.assertEqual(audit(self.path), (2, [], [(1, 2)]))
        self.assertEqual(audit(self.path, exact=True), (2, [], []))

    def test_blank_and_bom(self):
        self.write(b"\xef\xbb\xbfcode, ,price\n")
        self.assertEqual(audit(self.path), (3, [2], []))

    def test_quoted_delimiter(self):
        self.write(b'"a,b",c\n')
        self.assertEqual(audit(self.path), (2, [], []))

    def test_empty_and_invalid_utf8(self):
        self.write(b"")
        self.assertEqual(main([str(self.path)]), 2)
        self.write(b"\xff\xfe")
        self.assertEqual(main([str(self.path)]), 2)

    def test_missing_file(self):
        self.assertEqual(main([str(self.path)]), 2)


if __name__ == "__main__":
    unittest.main()
