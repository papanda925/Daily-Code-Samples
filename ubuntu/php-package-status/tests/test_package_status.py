"""Use a temporary dpkg database and fake APT output; never change host packages."""
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

SCRIPT = Path(__file__).resolve().parents[1] / "check-php-package-status.sh"


class PackageStatusTests(unittest.TestCase):
    def setUp(self):
        if not shutil.which("dpkg-query"):
            self.skipTest("dpkg-query is required for this fixture test")
        temporary = tempfile.TemporaryDirectory()
        self.addCleanup(temporary.cleanup)
        self.root = Path(temporary.name)
        self.bin = self.root / "bin"
        self.bin.mkdir()
        self.database = self.root / "database"
        self.database.mkdir()
        self.make_database()
        real_query = shutil.which("dpkg-query")
        query = self.bin / "dpkg-query"
        query.write_text(
            '#!/bin/bash\nprintf called >> "$PHP_SAMPLE_TEST_TRACE"\nexec ' +
            real_query + ' --admindir="$PHP_SAMPLE_TEST_DB" "$@"\n'
        )
        query.chmod(0o700)
        apt = self.bin / "apt-cache"
        apt.write_text("""#!/bin/bash
case "${PHP_SAMPLE_TEST_APT:-ok}" in
  fail) printf '%s\\n' PRIVATE_FIXTURE_NOT_FOR_OUTPUT >&2; exit 7 ;;
  incomplete) printf '%s\\n' '  Candidate: 8.3.6-0ubuntu0.24.04.13'; exit 0 ;;
esac
printf '%s\\n' '  Installed: 8.3.6-0ubuntu0.24.04.13'
printf '%s\\n' '  Candidate: 8.3.6-0ubuntu0.24.04.13'
printf '%s\\n' '  https://example.com/repository PRIVATE_FIXTURE_NOT_FOR_OUTPUT'
""")
        apt.chmod(0o700)
        self.trace = self.root / "trace"
        self.env = {
            **os.environ, "PATH": str(self.bin),
            "PHP_SAMPLE_TEST_DB": str(self.database),
            "PHP_SAMPLE_TEST_TRACE": str(self.trace),
        }

    def make_database(self, fpm_state="install ok installed"):
        blocks = []
        for name in ("php8.3-cli", "php8.3-fpm", "php8.3-common"):
            state = fpm_state if name.endswith("-fpm") else "install ok installed"
            blocks.append(
                "Package: " + name + "\nStatus: " + state +
                "\nArchitecture: amd64\nVersion: 8.3.6-0ubuntu0.24.04.13" +
                "\nDescription: Fictional test package\n"
            )
        (self.database / "status").write_text("\n".join(blocks), encoding="utf-8")

    def run_script(self, *packages, env=None):
        return subprocess.run(
            ["/bin/bash", str(SCRIPT), *packages], text=True,
            capture_output=True, env=self.env if env is None else env,
            cwd=self.root, check=False,
        )

    def test_installed_packages_show_versions_without_safety_verdict(self):
        before = (self.database / "status").read_bytes()
        result = self.run_script()
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn("installed\tphp8.3-fpm\t8.3.6", result.stdout)
        self.assertIn("Candidate:", result.stdout)
        self.assertIn("安全性の判定ではありません", result.stdout)
        self.assertEqual((self.database / "status").read_bytes(), before)

    def test_removed_package_is_not_treated_as_installed(self):
        self.make_database("deinstall ok config-files")
        result = self.run_script("php8.3-fpm")
        self.assertEqual(result.returncode, 1)
        self.assertIn("config-files\tphp8.3-fpm", result.stdout)
        self.assertIn("インストール済み状態ではありません", result.stdout)

    def test_unregistered_package_is_reported_without_raw_error(self):
        result = self.run_script("php9.9-fpm")
        self.assertEqual(result.returncode, 1)
        self.assertIn("[NOT_FOUND] php9.9-fpm", result.stdout)
        self.assertEqual(result.stderr, "")

    def test_all_names_are_validated_before_any_query(self):
        result = self.run_script("php8.3-cli", "--version")
        self.assertEqual(result.returncode, 2)
        self.assertFalse(self.trace.exists())

    def test_shell_expression_is_not_executed(self):
        result = self.run_script("php8.3-fpm;touch unexpected")
        self.assertEqual(result.returncode, 2)
        self.assertFalse((self.root / "unexpected").exists())

    def test_failed_apt_query_has_nonzero_exit_without_raw_diagnostics(self):
        result = self.run_script("php8.3-cli", env={**self.env, "PHP_SAMPLE_TEST_APT": "fail"})
        self.assertEqual(result.returncode, 1)
        self.assertNotIn("PRIVATE_FIXTURE", result.stdout + result.stderr)

    def test_incomplete_apt_output_is_not_silently_accepted(self):
        result = self.run_script("php8.3-cli", env={**self.env, "PHP_SAMPLE_TEST_APT": "incomplete"})
        self.assertEqual(result.returncode, 1)
        self.assertIn("Installed/Candidateが揃いません", result.stderr)

    def test_repository_urls_are_not_printed(self):
        result = self.run_script("php8.3-cli")
        self.assertEqual(result.returncode, 0)
        self.assertNotIn("example.com/repository", result.stdout)
        self.assertNotIn("PRIVATE_FIXTURE", result.stdout)

    def test_missing_required_tool_prevents_queries(self):
        (self.bin / "apt-cache").unlink()
        result = self.run_script()
        self.assertEqual(result.returncode, 2)
        self.assertFalse(self.trace.exists())


    def test_pasted_script_leaves_interactive_shell_open(self):
        """Running the entire sample as pasted text must not end the terminal."""
        result = subprocess.run(
            ["/bin/bash", "--noprofile", "--norc", "-i"],
            input=SCRIPT.read_text(encoding="utf-8") + "\nprintf '%s\n' SHELL_STILL_OPEN\n",
            text=True, encoding="utf-8", errors="replace",
            capture_output=True, env=self.env, cwd=self.root, check=False,
        )
        self.assertIn("SHELL_STILL_OPEN", result.stdout)
        self.assertIn("STATE  PACKAGE  VERSION", result.stdout)
        self.assertEqual(result.returncode, 0, result.stderr)

    def test_sourcing_script_leaves_shell_open_after_error(self):
        result = subprocess.run(
            ["/bin/bash", "-c",
             'source "$1" --version; rc=$?; printf "SHELL_STILL_OPEN:%d\n" "$rc"',
             "test", str(SCRIPT)],
            text=True, capture_output=True, env=self.env,
            cwd=self.root, check=False,
        )
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn("SHELL_STILL_OPEN:2", result.stdout)

    def test_sample_does_not_create_log_file(self):
        result = self.run_script()
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertNotIn("RESULT_FILE", result.stdout)
        self.assertNotIn("REOPEN", result.stdout)
        self.assertEqual(list(self.root.rglob("*.log")), [])


if __name__ == "__main__":
    unittest.main()
