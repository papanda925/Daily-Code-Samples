import assert from "node:assert/strict";
import fs from "node:fs";
import vm from "node:vm";
import { test } from "node:test";
const source = fs.readFileSync(new URL("./app.js", import.meta.url), "utf8");
const window = {};
vm.runInNewContext(source, { window, Intl, Array, String });
const measure = window.GraphemeLab.measure;
for (const [name, value, expected] of [
  ["ASCII", "A", [1, 1, 1]],
  ["Japanese", "日本語", [3, 3, 3]],
  ["Emoji", "😀", [2, 1, 1]],
  ["Family ZWJ", "👨‍👩‍👧‍👦", [11, 7, 1]],
  ["Combining mark", "e\u0301", [2, 2, 1]],
  ["Mixed", "A😀e\u0301", [5, 4, 3]],
  ["Empty", "", [0, 0, 0]],
  ["11 letters", "ABCDEFGHIJK", [11, 11, 11]]
]) test(name, () => {
  const got = measure(value);
  assert.deepEqual([got.utf16, got.codePoints, got.graphemes], expected);
});
test("Unsupported Segmenter must not invent count", () => {
  assert.equal(measure("😀", undefined).graphemes, 1); // default argument uses native API
  assert.equal(measure("😀", null).graphemes, null);
});
