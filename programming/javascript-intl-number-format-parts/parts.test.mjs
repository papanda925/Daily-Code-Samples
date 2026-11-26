import assert from 'node:assert/strict';
import { test } from 'node:test';
import { currencyParts, joinParts } from './parts.mjs';

for (const [locale, currency] of [['en-US', 'USD'], ['de-DE', 'EUR'], ['ja-JP', 'JPY']]) {
  test(`round trip ${locale}`, () => {
    const parts = currencyParts(1234.5, locale, currency);
    assert.equal(joinParts(parts), new Intl.NumberFormat(locale, { style: 'currency', currency }).format(1234.5));
    assert.equal(parts.filter(p => p.type === 'currency').length, 1);
  });
}
test('negative amount retains sign', () => {
  assert.ok(currencyParts(-1234.5, 'en-US', 'USD').some(p => p.type === 'minusSign'));
});
test('JPY default has no fraction', () => {
  assert.ok(!currencyParts(1234.5, 'ja-JP', 'JPY').some(p => p.type === 'fraction'));
});
test('reject non-finite or non-number input', () => {
  for (const amount of [NaN, Infinity, '1234.5', null]) {
    assert.throws(() => currencyParts(amount, 'en-US', 'USD'), TypeError);
  }
});
test('reject malformed currency code', () => {
  assert.throws(() => currencyParts(1234.5, 'en-US', 'US'), RangeError);
});
