'use strict';

const test = require('node:test');
const assert = require('node:assert/strict');
const semver = require('semver');

test('caret range with nonzero major accepts minor and patch but stops at next major', () => {
  assert.equal(semver.satisfies('1.2.2', '^1.2.3'), false);
  assert.equal(semver.satisfies('1.2.3', '^1.2.3'), true);
  assert.equal(semver.satisfies('1.9.0', '^1.2.3'), true);
  assert.equal(semver.satisfies('2.0.0', '^1.2.3'), false);
  assert.equal(semver.satisfies('2.0.0-beta.1', '^1.2.3'), false);
});

test('caret range with zero major stops at next minor', () => {
  assert.equal(semver.satisfies('0.2.2', '^0.2.3'), false);
  assert.equal(semver.satisfies('0.2.9', '^0.2.3'), true);
  assert.equal(semver.satisfies('0.3.0', '^0.2.3'), false);
  assert.equal(semver.satisfies('0.3.0-beta.1', '^0.2.3'), false);
});

test('caret range with zero major and minor stops at next patch', () => {
  assert.equal(semver.satisfies('0.0.3', '^0.0.3'), true);
  assert.equal(semver.satisfies('0.0.4', '^0.0.3'), false);
  assert.equal(semver.satisfies('0.0.4-beta.1', '^0.0.3'), false);
});

test('prereleases require an opted-in comparator for the same tuple', () => {
  assert.equal(semver.satisfies('1.3.0-beta.1', '^1.2.3'), false);
  assert.equal(semver.satisfies('1.2.3-beta.4', '^1.2.3-beta.2'), true);
  assert.equal(semver.satisfies('1.2.4-beta.1', '^1.2.3-beta.2'), false);
});

test('invalid range and version inputs are detected', () => {
  assert.equal(semver.validRange('^1..2'), null);
  assert.equal(semver.valid('1.2'), null);
});
