import subprocess
import sys
import unittest
from unittest.mock import patch

from run_demo import Outcome, decode_partial, demo_command, main, run_checked


class DemoTests(unittest.TestCase):
    def test_success(self):
        result = run_checked(demo_command("ok"), 10)
        self.assertEqual((result.status, result.returncode, result.stdout.strip()),
                         ("OK", 0, "child: done"))

    def test_nonzero_and_stderr(self):
        result = run_checked(demo_command("fail"), 10)
        self.assertEqual((result.status, result.returncode, result.stderr.strip()),
                         ("NONZERO", 7, "child: failed"))

    def test_timeout(self):
        with patch("run_demo.subprocess.run", side_effect=subprocess.TimeoutExpired(
                cmd=["python"], timeout=1, output=b"child: waiting\n", stderr=b"")):
            result = run_checked(demo_command("timeout"), 1)
        self.assertEqual(result.status, "TIMEOUT")
        self.assertIsNone(result.returncode)
        self.assertIn("child: waiting", result.stdout)

    def test_missing_executable(self):
        with patch("run_demo.subprocess.run", side_effect=FileNotFoundError("private path")):
            result = run_checked(["not-a-real-executable"], 1)
        self.assertEqual(result, Outcome("START_FAILED", None, "", "FileNotFoundError"))

    def test_partial_bytes(self):
        self.assertEqual(decode_partial(b"a\xff"), "a\ufffd")
        self.assertEqual(decode_partial(None), "")

    def test_no_shell_and_list_arguments(self):
        with patch("run_demo.subprocess.run", return_value=subprocess.CompletedProcess([], 0, "", "")) as mock:
            run_checked([sys.executable, "-c", "print(1)"], 1)
        self.assertIs(mock.call_args.kwargs["shell"], False)
        self.assertIsInstance(mock.call_args.args[0], list)

    def test_invalid_timeout(self):
        for value in (0, -1):
            with self.assertRaises(ValueError):
                run_checked(demo_command("ok"), value)

    def test_cli_exit_codes(self):
        with patch("builtins.print"):
            self.assertEqual(main(["--mode", "ok"]), 0)
            self.assertEqual(main(["--mode", "fail"]), 1)
            with patch("run_demo.subprocess.run", side_effect=subprocess.TimeoutExpired(
                    cmd=["python"], timeout=1, output=b"child: waiting\n", stderr=b"")):
                self.assertEqual(main(["--mode", "timeout", "--timeout", "1"]), 124)

    def test_cli_invalid_timeout(self):
        with self.assertRaises(SystemExit) as caught:
            main(["--timeout", "0"])
        self.assertEqual(caught.exception.code, 2)


if __name__ == "__main__":
    unittest.main()
