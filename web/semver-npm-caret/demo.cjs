'use strict';

const semver = require('semver');

const range = process.argv[2] ?? '^1.2.3';
const candidates = process.argv.slice(3);
const normalizedRange = semver.validRange(range);

if (!normalizedRange) {
  console.error('範囲指定を確認してください:', range);
  process.exitCode = 2;
} else if (candidates.length === 0) {
  console.error('候補のバージョンを1つ以上指定してください。');
  process.exitCode = 2;
} else {
  console.table(candidates.map(version => ({
    version,
    result: !semver.valid(version)
      ? 'バージョン形式が不正'
      : semver.satisfies(version, normalizedRange) ? '範囲内' : '範囲外',
  })));
}
