"""Offline tests for the read-only TOML checker."""
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest

from check_toml import check_path, validate_data, MAX_BYTES

VALID = b'[app]\nname = "demo"\nenabled = true\nretries = 2\n'


class TomlPreflightTests(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.addCleanup(self.tmp.cleanup)
        self.file = Path(self.tmp.name) / "demo.toml"

    def write(self, raw: bytes):
        self.file.write_bytes(raw)
        return check_path(self.file)

    def test_valid(self):
        self.assertEqual(self.write(VALID), (0, "STATUS=VALID CHECKS=APP_NAME_ENABLED_RETRIES"))

    def test_extra_table_allowed(self):
        self.assertEqual(self.write(VALID + b'\n[extra]\nsecret = "dummy-only"\n')[0], 0)

    def test_missing_table(self):
        self.assertEqual(self.write(b'name = "demo"\n')[1], "STATUS=INVALID ISSUE=MISSING_APP_TABLE")

    def test_missing_name(self):
        self.assertEqual(self.write(b'[app]\nenabled = true\nretries = 2\n')[1], "STATUS=INVALID ISSUE=MISSING_NAME")

    def test_blank_name(self):
        self.assertEqual(self.write(b'[app]\nname = "  "\nenabled = true\nretries = 2\n')[1], "STATUS=INVALID ISSUE=INVALID_NAME")

    def test_missing_enabled(self):
        self.assertEqual(self.write(b'[app]\nname = "demo"\nretries = 2\n')[1], "STATUS=INVALID ISSUE=MISSING_ENABLED")

    def test_string_enabled_rejected(self):
        self.assertEqual(self.write(b'[app]\nname = "demo"\nenabled = "true"\nretries = 2\n')[1], "STATUS=INVALID ISSUE=INVALID_ENABLED")

    def test_missing_retries(self):
        self.assertEqual(self.write(b'[app]\nname = "demo"\nenabled = true\n')[1], "STATUS=INVALID ISSUE=MISSING_RETRIES")

    def test_bool_retries_rejected(self):
        self.assertEqual(validate_data({"app": {"name": "x", "enabled": True, "retries": True}}), "INVALID_RETRIES")

    def test_negative_retries(self):
        self.assertEqual(self.write(VALID.replace(b'retries = 2', b'retries = -1'))[1], "STATUS=INVALID ISSUE=INVALID_RETRIES")

    def test_too_many_retries(self):
        self.assertEqual(self.write(VALID.replace(b'retries = 2', b'retries = 11'))[1], "STATUS=INVALID ISSUE=INVALID_RETRIES")

    def test_duplicate_toml_key(self):
        self.assertEqual(self.write(VALID + b'name = "other"\n')[1], "STATUS=INVALID ISSUE=INVALID_TOML")

    def test_invalid_utf8(self):
        self.assertEqual(self.write(VALID + b'\xff')[1], "STATUS=INVALID ISSUE=INVALID_UTF8")

    def test_size_limit(self):
        self.assertEqual(self.write(b' ' * (MAX_BYTES + 1))[1], "STATUS=INVALID ISSUE=FILE_TOO_LARGE")

    def test_missing_file(self):
        self.assertEqual(check_path(self.file)[0], 3)

    def test_directory_rejected(self):
        self.assertEqual(check_path(Path(self.tmp.name))[0], 3)

    def test_symlink_rejected(self):
        target = Path(self.tmp.name) / "target.toml"
        target.write_bytes(VALID)
        self.file.symlink_to(target)
        self.assertEqual(check_path(self.file)[1], "STATUS=INVALID ISSUE=SYMLINK_NOT_ALLOWED")

    def test_cli_valid(self):
        self.file.write_bytes(VALID)
        result = subprocess.run([sys.executable, str(Path(__file__).with_name('check_toml.py')), str(self.file)], capture_output=True, text=True)
        self.assertEqual(result.returncode, 0)
        self.assertEqual(result.stdout.strip(), "STATUS=VALID CHECKS=APP_NAME_ENABLED_RETRIES")

    def test_cli_error_does_not_leak_value(self):
        self.file.write_bytes(VALID.replace(b'retries = 2', b'retries = "private-demo-value"'))
        result = subprocess.run([sys.executable, str(Path(__file__).with_name('check_toml.py')), str(self.file)], capture_output=True, text=True)
        self.assertEqual(result.returncode, 2)
        self.assertIn("INVALID_RETRIES", result.stdout)
        self.assertNotIn("private-demo-value", result.stdout + result.stderr)


if __name__ == "__main__":
    unittest.main()
