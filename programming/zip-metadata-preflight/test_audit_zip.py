import contextlib
import io
from pathlib import Path
import stat
import tempfile
import unittest
import warnings
from zipfile import ZIP_DEFLATED, ZipFile, ZipInfo

from audit_zip import audit_zip, main


class ZipPreflightTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.path = Path(self.temp.name) / "demo.zip"

    def make_zip(self, items, compression=ZIP_DEFLATED):
        with warnings.catch_warnings():
            warnings.simplefilter("ignore", UserWarning)
            with ZipFile(self.path, "w", compression=compression) as archive:
                for name, data in items:
                    archive.writestr(name, data)

    def flags(self, **kwargs):
        return audit_zip(self.path, **kwargs)[2]

    def test_safe_archive(self):
        self.make_zip([("docs/readme.txt", "hello")])
        self.assertEqual(self.flags(), [])

    def test_parent_traversal(self):
        self.make_zip([("../outside.txt", "x")])
        self.assertIn("unsafe_path_component", str(self.flags()))

    def test_backslash_parent_traversal(self):
        self.make_zip([("docs\\..\\outside.txt", "x")])
        self.assertIn("unsafe_path_component", str(self.flags()))

    def test_absolute_posix_path(self):
        self.make_zip([("/etc/demo.txt", "x")])
        self.assertIn("absolute_or_drive_path", str(self.flags()))

    def test_windows_drive_path(self):
        self.make_zip([("C:/temp/demo.txt", "x")])
        self.assertIn("absolute_or_drive_path", str(self.flags()))

    def test_windows_ads_colon(self):
        self.make_zip([("docs/file.txt:stream", "x")])
        self.assertIn("unsafe_path_component", str(self.flags()))

    def test_duplicate_entry(self):
        self.make_zip([("docs/a.txt", "1"), ("docs/a.txt", "2")])
        self.assertIn("duplicate_or_case_collision", str(self.flags()))

    def test_case_collision(self):
        self.make_zip([("docs/A.txt", "1"), ("docs/a.txt", "2")])
        self.assertIn("duplicate_or_case_collision", str(self.flags()))

    def test_entry_count_limit(self):
        self.make_zip([("a.txt", "1"), ("b.txt", "2")])
        self.assertIn("entry_count_exceeded", str(self.flags(max_entries=1)))

    def test_declared_size_limit(self):
        self.make_zip([("a.txt", "12345")])
        self.assertIn("declared_size_exceeded", str(self.flags(max_bytes=4)))

    def test_compression_ratio(self):
        self.make_zip([("large.txt", "A" * 10000)])
        self.assertIn("compression_ratio_exceeded", str(self.flags(max_ratio=10)))

    def test_unix_symlink(self):
        info = ZipInfo("link")
        info.create_system = 3
        info.external_attr = (stat.S_IFLNK | 0o777) << 16
        with ZipFile(self.path, "w") as archive:
            archive.writestr(info, "target")
        self.assertIn("unix_symlink", str(self.flags()))

    def test_invalid_zip_exit_two(self):
        self.path.write_text("not zip", encoding="utf-8")
        with contextlib.redirect_stderr(io.StringIO()):
            self.assertEqual(main([str(self.path)]), 2)

    def test_cli_safe_exit_zero(self):
        self.make_zip([("a.txt", "ok")])
        with contextlib.redirect_stdout(io.StringIO()) as output:
            self.assertEqual(main([str(self.path)]), 0)
        self.assertIn("RESULT=NO_METADATA_FLAGS", output.getvalue())

    def test_cli_findings_exit_one(self):
        self.make_zip([("../outside.txt", "x")])
        with contextlib.redirect_stdout(io.StringIO()) as output:
            self.assertEqual(main([str(self.path)]), 1)
        self.assertIn("RESULT=REVIEW_REQUIRED", output.getvalue())

    def test_no_file_extraction(self):
        self.make_zip([("docs/readme.txt", "hello")])
        self.flags()
        self.assertEqual(sorted(p.name for p in Path(self.temp.name).iterdir()), ["demo.zip"])


if __name__ == "__main__":
    unittest.main()
