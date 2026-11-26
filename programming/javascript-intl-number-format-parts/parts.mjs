// 金額の計算と表示を分離する。通貨記号の位置はロケールに任せる。
export function currencyParts(amount, locale, currency) {
  if (typeof amount !== 'number' || !Number.isFinite(amount)) {
    throw new TypeError('amount must be a finite number');
  }
  const formatter = new Intl.NumberFormat(locale, { style: 'currency', currency });
  return formatter.formatToParts(amount);
}

// 順序と空白を変えずに表示用文字列を復元する。
export function joinParts(parts) {
  return parts.map(part => part.value).join('');
}
