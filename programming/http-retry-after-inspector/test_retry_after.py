import unittest
from datetime import datetime, timedelta, timezone
from retry_after import main, parse_retry_after
from contextlib import redirect_stderr, redirect_stdout
from io import StringIO

NOW = datetime(2026, 10, 24, 0, 0, 0, tzinfo=timezone.utc)


class RetryAfterTests(unittest.TestCase):
    def test_seconds(self):
        self.assertEqual(parse_retry_after("120", NOW)[0], 120)

    def test_zero(self):
        self.assertEqual(parse_retry_after("0", NOW)[0], 0)

    def test_whitespace(self):
        self.assertEqual(parse_retry_after("\t15 ", NOW)[0], 15)

    def test_date_future(self):
        self.assertEqual(parse_retry_after("Sat, 24 Oct 2026 00:02:00 GMT", NOW)[0], 120)

    def test_date_past(self):
        self.assertEqual(parse_retry_after("Fri, 23 Oct 2026 23:59:59 GMT", NOW)[0], 0)

    def test_fractional_now_rounds_up(self):
        later = NOW + timedelta(microseconds=1)
        self.assertEqual(parse_retry_after("Sat, 24 Oct 2026 00:00:01 GMT", later)[0], 1)

    def test_timezone_conversion(self):
        jst = datetime(2026, 10, 24, 9, 0, tzinfo=timezone(timedelta(hours=9)))
        self.assertEqual(parse_retry_after("Sat, 24 Oct 2026 00:02:00 GMT", jst)[0], 120)

    def test_negative_rejected(self):
        with self.assertRaises(ValueError):
            parse_retry_after("-1", NOW)

    def test_fraction_rejected(self):
        with self.assertRaises(ValueError):
            parse_retry_after("1.5", NOW)

    def test_bad_date_rejected(self):
        with self.assertRaises(ValueError):
            parse_retry_after("Sat, 99 Oct 2026 00:02:00 GMT", NOW)

    def test_weekday_mismatch_rejected(self):
        with self.assertRaises(ValueError):
            parse_retry_after("Fri, 24 Oct 2026 00:02:00 GMT", NOW)

    def test_naive_now_rejected(self):
        with self.assertRaises(ValueError):
            parse_retry_after("2", datetime(2026, 10, 24))

    def test_obsolete_date_rejected(self):
        with self.assertRaises(ValueError):
            parse_retry_after("Saturday, 24-Oct-26 00:02:00 GMT", NOW)

    def test_overflow_rejected(self):
        with self.assertRaises(ValueError):
            parse_retry_after("9" * 100, NOW)

    def test_cli_success(self):
        out = StringIO()
        with redirect_stdout(out):
            self.assertEqual(main(["120", "--now", "2026-10-24T00:00:00+00:00"]), 0)
        self.assertIn('"wait_seconds": 120', out.getvalue())

    def test_cli_invalid(self):
        err = StringIO()
        with redirect_stderr(err):
            self.assertEqual(main(["-1", "--now", "2026-10-24T00:00:00+00:00"]), 2)
        self.assertIn("INVALID_RETRY_AFTER", err.getvalue())


if __name__ == "__main__":
    unittest.main()
