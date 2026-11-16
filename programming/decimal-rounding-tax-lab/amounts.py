"""架空の税込金額をDecimalで計算する教材。ファイル・通信なし。"""
from decimal import Decimal, InvalidOperation, ROUND_HALF_UP

RATE = Decimal('0.10')
YEN = Decimal('1')


def calculate(price_text: str, quantity: int, rounding=ROUND_HALF_UP) -> dict:
    """金額は文字列から作り、明細ごとに税を円単位へ丸める。"""
    try:
        price = Decimal(price_text)
    except (InvalidOperation, TypeError) as exc:
        raise ValueError('金額は十進数の文字列で指定') from exc
    if not price.is_finite() or price < 0:
        raise ValueError('金額は0以上の有限値')
    if type(quantity) is not int or quantity < 1:
        raise ValueError('数量は1以上の整数')
    subtotal = price * quantity
    tax = (subtotal * RATE).quantize(YEN, rounding=rounding)
    return {'subtotal': str(subtotal), 'tax': str(tax), 'total': str(subtotal + tax)}


if __name__ == '__main__':
    for value in ['15', '25', '0.1']:
        print(value, calculate(value, 1))
