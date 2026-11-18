"use strict";
const assert = require("node:assert/strict");
const { rows, selectById } = require("../../docs/demos/css-escape-selector-lab/app.js");
let count = 0;
function check(fn) { fn(); count += 1; }

check(() => assert.equal(rows.length, 4));
check(() => assert.deepEqual(rows.map(x => x.id), ["ticket:01", "ticket.02", "123-start", "a[b]"]));
check(() => assert.equal(rows.some(x => /\s/.test(x.id)), false));

let seen = "";
const root = { querySelector(selector) { seen = selector; return selector === "#ticket\\:01" ? { textContent: "hit" } : null; } };
const escapeColon = id => id.replace(":", "\\:");
check(() => assert.equal(selectById(root, "ticket:01", escapeColon).textContent, "hit"));
check(() => assert.equal(seen, "#ticket\\:01"));
check(() => assert.equal(selectById(root, "missing", escapeColon), null));
check(() => assert.equal(selectById(root, "", escapeColon), null));
check(() => assert.equal(seen, "#missing")); // 空文字ではquerySelectorを呼ばない
check(() => assert.throws(() => selectById(root, "x".repeat(81), x => x), RangeError));
check(() => assert.throws(() => selectById(root, null, x => x), RangeError));
check(() => assert.throws(() => selectById(root, "ticket:01", null), TypeError));
check(() => assert.equal(selectById(root, "a[b]", id => id.replace(/[\[\]]/g, x => "\\" + x)), null));
check(() => assert.equal(seen, "#a\\[b\\]"));
console.log(count + " assertions PASS (Node.js mock root only; CSS parser/browser not tested)");
