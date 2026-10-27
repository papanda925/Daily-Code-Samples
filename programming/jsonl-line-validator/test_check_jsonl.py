"""Tests use only temporary files; no network or production paths."""
import contextlib
import io
import tempfile
import unittest
from pathlib import Path

from check_jsonl import main, validate


class JsonlValidationTests(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.addCleanup(self.tmp.cleanup)
        self.path = Path(self.tmp.name) / "demo.jsonl"

    def check(self, content, expected):
        self.path.write_bytes(content)
        valid, total, issues = validate(self.path)
        self.assertEqual([reason for _, reason in issues], expected)
        return valid, total, issues

    def test_valid_objects(self):
        self.assertEqual(self.check(b'{"id":1}\n{"id":2}\n', [] )[:2], (2, 2))

    def test_crlf_and_no_final_newline(self):
        self.assertEqual(self.check(b'null\r\n[1,2]', [])[:2], (2, 2))

    def test_blank_line_is_invalid(self):
        self.assertEqual(self.check(b'{"ok":true}\n\n{"ok":false}\n', ["BLANK_LINE"])[0], 2)

    def test_invalid_json(self):
        self.check(b'{"id":}\n', ["INVALID_JSON"])

    def test_invalid_utf8(self):
        self.check(b'\xff\n', ["INVALID_UTF8"])

    def test_bom_is_reported(self):
        self.check(b'\xef\xbb\xbf{"id":1}\n', ["UTF8_BOM"])

    def test_nonfinite_is_invalid(self):
        self.check(b'NaN\n', ["NONFINITE_NUMBER"])

    def test_empty_file(self):
        self.check(b'', ["EMPTY_FILE"])

    def test_line_too_long(self):
        self.check(b'"' + b'x' * (1024 * 1024 + 1) + b'"\n', ["LINE_TOO_LONG"])

    def test_max_errors(self):
        self.path.write_bytes(b'\n\n\n')
        self.assertEqual(len(validate(self.path, 2)[2]), 2)

    def test_cli_valid(self):
        self.path.write_bytes(b'{"id":1}\n')
        output = io.StringIO()
        with contextlib.redirect_stdout(output):
            code = main([str(self.path)])
        self.assertEqual(code, 0)
        self.assertIn('STATUS=VALID VALID=1 READ=1 ERRORS=0', output.getvalue())

    def test_cli_invalid_no_data_leak(self):
        self.path.write_bytes(b'{"private":"not-logged"}\n{bad}\n')
        output = io.StringIO()
        with contextlib.redirect_stdout(output):
            code = main([str(self.path)])
        self.assertEqual(code, 2)
        self.assertIn('LINE=2 ISSUE=INVALID_JSON', output.getvalue())
        self.assertNotIn('not-logged', output.getvalue())

    def test_cli_missing(self):
        output = io.StringIO()
        with contextlib.redirect_stdout(output):
            code = main([str(self.path)])
        self.assertEqual(code, 3)
        self.assertIn('STATUS=READ_ERROR', output.getvalue())


if __name__ == "__main__":
    unittest.main()
