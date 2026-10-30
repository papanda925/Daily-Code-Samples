"""Offline tests for CSV physical-line / logical-record audit."""

import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

from audit_csv import InvalidCsv, audit

SCRIPT = Path(__file__).with_name("audit_csv.py")


class CsvAuditTests(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.addCleanup(self.tmp.cleanup)
        self.file = Path(self.tmp.name) / "sample.csv"

    def put(self, data: bytes):
        self.file.write_bytes(data)
        return self.file

    def run_cli(self, path=None):
        return subprocess.run(
            [sys.executable, str(SCRIPT), str(path or self.file)],
            text=True, capture_output=True, check=False,
        )

    def test_embedded_newline(self):
        result = audit(self.put(b'id,note\nA,"line1\nline2"\nB,done\n'))
        self.assertEqual(result, dict(physical_lines=4, csv_records=2,
                                      header_columns=2, multiline_records=1))

    def test_plain(self):
        self.assertEqual(audit(self.put(b'id,note\nA,one\nB,two\n'))['multiline_records'], 0)

    def test_crlf(self):
        result = audit(self.put(b'id,note\r\nA,"line1\r\nline2"\r\nB,done\r\n'))
        self.assertEqual((result['physical_lines'], result['csv_records']), (4, 2))

    def test_no_final_newline(self):
        self.assertEqual(audit(self.put(b'id,note\nA,one'))['physical_lines'], 2)

    def test_utf8_bom(self):
        self.assertEqual(audit(self.put(b'\xef\xbb\xbfid,note\nA,one\n'))['csv_records'], 1)

    def test_mismatch(self):
        with self.assertRaisesRegex(InvalidCsv, 'FIELD_COUNT_MISMATCH'):
            audit(self.put(b'id,note\nA\n'))

    def test_unclosed_quote(self):
        self.put(b'id,note\nA,"unfinished\n')
        r = self.run_cli()
        self.assertEqual(r.returncode, 2)
        self.assertIn('PARSE_OR_ENCODING_ERROR', r.stdout)

    def test_empty(self):
        with self.assertRaisesRegex(InvalidCsv, 'EMPTY_OR_NO_HEADER'):
            audit(self.put(b''))

    def test_missing(self):
        self.assertEqual(self.run_cli().returncode, 3)

    def test_too_large(self):
        self.put(b'x' * (1024 * 1024 + 1))
        self.assertIn('TOO_LARGE', self.run_cli().stdout)

    def test_invalid_utf8(self):
        self.put(b'id,note\nA,\xff\n')
        self.assertEqual(self.run_cli().returncode, 2)

    def test_cli_ok(self):
        self.put(b'id,note\nA,"line1\nline2"\nB,done\n')
        r = self.run_cli()
        self.assertEqual(r.returncode, 0)
        self.assertIn('PHYSICAL_LINES=4', r.stdout)
        self.assertIn('CSV_RECORDS=2', r.stdout)
        self.assertNotIn('line1', r.stdout)


if __name__ == '__main__':
    unittest.main()
