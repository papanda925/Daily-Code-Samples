import unittest
from check_line_endings import count_endings


class LineEndingTests(unittest.TestCase):
    def test_empty(self): self.assertEqual(count_endings(b''), {'CRLF': 0, 'LF': 0, 'CR': 0})
    def test_lf(self): self.assertEqual(count_endings(b'a\nb\n'), {'CRLF': 0, 'LF': 2, 'CR': 0})
    def test_crlf(self): self.assertEqual(count_endings(b'a\r\nb\r\n'), {'CRLF': 2, 'LF': 0, 'CR': 0})
    def test_cr(self): self.assertEqual(count_endings(b'a\rb\r'), {'CRLF': 0, 'LF': 0, 'CR': 2})
    def test_mixed(self): self.assertEqual(count_endings(b'a\r\nb\nc\r'), {'CRLF': 1, 'LF': 1, 'CR': 1})
    def test_no_newline(self): self.assertEqual(count_endings(b'abc'), {'CRLF': 0, 'LF': 0, 'CR': 0})


if __name__ == '__main__': unittest.main()
