import unittest
from decimal import ROUND_HALF_EVEN
from amounts import calculate


class AmountTests(unittest.TestCase):
    def test_half_up(self):
        self.assertEqual(calculate('15', 1)['tax'], '2')

    def test_half_even(self):
        self.assertEqual(calculate('15', 1, ROUND_HALF_EVEN)['tax'], '2')
        self.assertEqual(calculate('25', 1, ROUND_HALF_EVEN)['tax'], '2')

    def test_half_up_25(self):
        self.assertEqual(calculate('25', 1)['tax'], '3')

    def test_quantity(self):
        self.assertEqual(calculate('15', 2)['tax'], '3')

    def test_invalid(self):
        for amount, qty in [('NaN', 1), ('-1', 1), ('abc', 1), ('10', 0), ('10', True)]:
            with self.subTest(amount=amount, qty=qty), self.assertRaises(ValueError):
                calculate(amount, qty)


if __name__ == '__main__':
    unittest.main()
