'use strict';

const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');

const repoRoot = path.resolve(__dirname, '../..');
const html = fs.readFileSync(path.join(repoRoot, 'docs/demos/exceljs-sales-workbook/index.html'), 'utf8');
const common = fs.readFileSync(path.join(repoRoot, 'docs/demos/browser-library-labs/daily.js'), 'utf8');

assert.match(html, /id="live"/);
assert.match(html, /id="input"/);
assert.match(html, /id="run"/);
assert.match(html, /exceljs@4\.4\.0\/dist\/exceljs\.min\.js/);
assert.match(html, /writeBuffer/);
assert.match(common, /2:async v=>/);

const demo = common.match(/2:async v=>\{([\s\S]*?)\},\n3:async v=>/);
assert.ok(demo, 'ExcelJS handler must remain the demo numbered 2');
const body = demo[1];
assert.match(body, /s\.getColumn\(2\)\.numFmt='#,##0'/);
assert.match(body, /formula:'SUM\(B2:B3\)'/);
const normalizeMatch = body.match(/const a=([^;]+);s\.addRows\(/);
assert.ok(normalizeMatch, 'input conversion expression must be present');
const toCellValue = new Function('v', 'return (' + normalizeMatch[1] + ');');
const resultMatch = body.match(/result:\((typeof a==='number'\?a:0)\)\+3500/);
assert.ok(resultMatch, 'cached formula result expression must be present');
const cachedResult = new Function('a', 'return (' + resultMatch[1] + ')+3500;');

for (const [input, expectedValue, expectedSum] of [
  ['1200', 1200, 4700],
  ['1200円', '1200円', 3500],
  ['1,200', '1,200', 3500],
  ['', '', 3500],
]) {
  const value = toCellValue(input);
  assert.equal(value, expectedValue, 'cell value for ' + JSON.stringify(input));
  assert.equal(cachedResult(value), expectedSum, 'cached result for ' + JSON.stringify(input));
}

console.log('ExcelJS demo mapping and input logic: PASS (4 cases).');
