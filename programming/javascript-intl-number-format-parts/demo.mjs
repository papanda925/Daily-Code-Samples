import { currencyParts, joinParts } from './parts.mjs';

for (const [locale, currency] of [['en-US', 'USD'], ['de-DE', 'EUR'], ['ja-JP', 'JPY']]) {
  const parts = currencyParts(1234.5, locale, currency);
  console.log(locale, currency, joinParts(parts));
  console.log(parts.map(({ type, value }) => `${type}: ${JSON.stringify(value)}`).join(' | '));
}
