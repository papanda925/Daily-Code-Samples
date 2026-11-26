import assert from 'node:assert/strict';
import { test } from 'node:test';
import { pageOf } from './pagination.mjs';

const items = ['A', 'B', 'C', 'D', 'E'];
test('first page', () => assert.deepEqual(pageOf(items, 1, 2), ['A', 'B']));
test('second page', () => assert.deepEqual(pageOf(items, 2, 2), ['C', 'D']));
test('last partial page', () => assert.deepEqual(pageOf(items, 3, 2), ['E']));
test('beyond last page', () => assert.deepEqual(pageOf(items, 4, 2), []));
test('empty array', () => assert.deepEqual(pageOf([], 1, 2), []));
test('different page size', () => assert.deepEqual(pageOf(items, 2, 3), ['D', 'E']));
test('invalid page', () => { for (const x of [0, -1, 1.5, '1', NaN]) assert.throws(() => pageOf(items, x, 2), RangeError); });
test('invalid size', () => { for (const x of [0, -1, 1.5, '2', Infinity]) assert.throws(() => pageOf(items, 1, x), RangeError); });
test('array required', () => assert.throws(() => pageOf('ABCDE', 1, 2), TypeError));
test('source array stays unchanged', () => {
  const source = [...items];
  pageOf(source, 1, 2).push('X');
  assert.deepEqual(source, items);
});
test('objects are shared, not deep cloned', () => {
  const source = [{ label: 'A' }];
  const result = pageOf(source, 1, 2);
  assert.notEqual(result, source);
  assert.equal(result[0], source[0]);
});
test('huge page stays out of range', () => assert.deepEqual(pageOf(items, Number.MAX_SAFE_INTEGER, 2), []));
