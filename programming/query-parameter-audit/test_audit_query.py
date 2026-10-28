"""Offline tests for the query parameter audit demo."""

import contextlib
import io
import unittest

from audit_query import QueryProblem, audit, main


class AuditQueryTests(unittest.TestCase):
    def assert_issue(self, query, expected):
        with self.assertRaises(QueryProblem) as ctx:
            audit(query)
        self.assertEqual(str(ctx.exception), expected)

    def test_repeated_keys_and_blank(self):
        s = audit("tag=one&tag=two&empty=")
        self.assertEqual((s.fields, s.unique_keys, s.duplicate_keys,
                          s.extra_occurrences, s.blank_values), (3, 2, 1, 1, 1))

    def test_empty_query(self):
        self.assertEqual(audit("").fields, 0)

    def test_case_sensitive_keys(self):
        self.assertEqual(audit("Tag=1&tag=2").duplicate_keys, 0)

    def test_encoded_keys_collide_after_decoding(self):
        self.assertEqual(audit("a=1&%61=2").duplicate_keys, 1)

    def test_encoded_ampersand_not_separator(self):
        self.assertEqual(audit("a=one%26two&b=3").fields, 2)

    def test_plus_vs_percent_plus(self):
        self.assertEqual(audit("a=one+two&a=one%2Btwo").duplicate_keys, 1)

    def test_non_ascii_key(self):
        self.assertEqual(audit("%E6%97%A5=1&%E6%97%A5=2").duplicate_keys, 1)

    def test_invalid_percent(self):
        self.assert_issue("a=%ZZ", "INVALID_PERCENT_ESCAPE")

    def test_incomplete_percent(self):
        self.assert_issue("a=%A", "INVALID_PERCENT_ESCAPE")

    def test_invalid_utf8(self):
        self.assert_issue("a=%FF", "INVALID_UTF8")

    def test_missing_equals(self):
        self.assert_issue("a=1&b", "INVALID_FIELD")

    def test_double_ampersand(self):
        self.assert_issue("a=1&&b=2", "INVALID_FIELD")

    def test_empty_key(self):
        self.assert_issue("=secret", "EMPTY_KEY")

    def test_limit_fields(self):
        self.assert_issue("&".join("a=1" for _ in range(101)), "FIELD_LIMIT")

    def test_limit_length(self):
        self.assert_issue("a=" + "x" * 4096, "QUERY_TOO_LONG")

    def test_semicolon_is_not_separator(self):
        self.assertEqual(audit("a=1;b=2").fields, 1)

    def test_cli_success_never_prints_values(self):
        output = io.StringIO()
        with contextlib.redirect_stdout(output):
            code = main(["--query", "secret=NEVER_ECHO&secret=ALSO_PRIVATE"])
        self.assertEqual(code, 0)
        self.assertNotIn("NEVER_ECHO", output.getvalue())
        self.assertNotIn("ALSO_PRIVATE", output.getvalue())
        self.assertIn("DUPLICATE_KEYS=1", output.getvalue())

    def test_cli_failure_never_prints_values(self):
        output = io.StringIO()
        with contextlib.redirect_stdout(output):
            code = main(["--query", "secret=NEVER_ECHO&bad=%ZZ"])
        self.assertEqual(code, 2)
        self.assertNotIn("NEVER_ECHO", output.getvalue())
        self.assertIn("ISSUE=INVALID_PERCENT_ESCAPE", output.getvalue())


if __name__ == "__main__":
    unittest.main()
