"use strict";
const test = require("node:test");
const assert = require("node:assert/strict");
const { blank, next, count, preset, neighbours } = require("../../../docs/demos/canvas-life-lab/logic.js");
test("点滅は2世代で元に戻る", () => {
  const a = preset("blinker"); const b = next(a); const c = next(b);
  assert.equal(count(a), 3); assert.equal(count(b), 3);
  assert.notDeepEqual(b, a); assert.deepEqual(c, a);
});
test("四角は安定", () => { const a = preset("block"); assert.deepEqual(next(a), a); });
test("グライダーは4世代で右下へ1マス", () => {
  const a = preset("glider"); let b = a;
  for (let i = 0; i < 4; i++) b = next(b);
  const original = [];
  const shifted = [];
  for (let r = 0; r < 16; r++) for (let c = 0; c < 16; c++) {
    if (a[r][c]) original.push([r + 1, c + 1]);
    if (b[r][c]) shifted.push([r, c]);
  }
  assert.deepEqual(shifted, original);
});
test("端は折り返さない", () => {
  const a = blank(); a[0][0] = a[0][1] = a[1][0] = true;
  assert.equal(neighbours(a, 15, 15), 0);
  assert.equal(next(a)[1][1], true);
});
test("空白は空白のまま", () => { assert.equal(count(next(blank())), 0); });
