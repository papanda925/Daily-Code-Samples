"use strict";
const { test } = require("node:test");
const assert = require("node:assert/strict");
const { transformPixels } = require("../../../docs/demos/canvas-pixel-lab/app.js");

test("初期状態では元RGB・透明度を保持", () => {
  const input = Uint8ClampedArray.from([20, 80, 140, 200]);
  assert.deepEqual([...transformPixels(input, 0, false)], [...input]);
});
test("明るさ+60と上限255", () => {
  assert.deepEqual([...transformPixels(Uint8ClampedArray.from([20, 210, 240, 200]), 60, false)], [80, 255, 255, 200]);
});
test("明るさ-100と下限0", () => {
  assert.deepEqual([...transformPixels(Uint8ClampedArray.from([20, 110, 240, 255]), -100, false)], [0, 10, 140, 255]);
});
test("白黒はRGBを同じ値にしてalphaを保つ", () => {
  const out = transformPixels(Uint8ClampedArray.from([100, 100, 100, 120]), 0, true);
  assert.deepEqual([...out], [100, 100, 100, 120]);
});
test("元配列を破壊しない", () => {
  const input = Uint8ClampedArray.from([10, 20, 30, 40]);
  transformPixels(input, 60, true);
  assert.deepEqual([...input], [10, 20, 30, 40]);
});
