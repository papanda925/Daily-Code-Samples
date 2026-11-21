"use strict";
// sort() は元配列を変更する。toSorted() は並べ替えた新しい配列を返す。
const input = document.querySelector("#numbers");
const run = document.querySelector("#run");
const output = document.querySelector("#output");
function compare(text) {
  // 空欄や不正な値を黙って0にしない。
  const parts = text.split(",").map(s => s.trim());
  if (parts.length < 2 || parts.length > 20 || parts.some(s => s === "" || !/^-?\d+(?:\.\d+)?$/.test(s))) {
    throw new Error("カンマ区切りで2〜20個の数値を入力してください。");
  }
  const values = parts.map(Number);
  if (values.some(n => !Number.isFinite(n))) throw new Error("有限の数値だけを入力してください。");
  const original = [...values];
  const sortedCopy = values.toSorted((a, b) => a - b);
  // 比較用に別配列を作る。入力のvalues自体をsort()しない。
  const sortedInPlace = [...values];
  sortedInPlace.sort((a, b) => a - b);
  return { original, sortedCopy, sortedInPlace, unchanged: JSON.stringify(values) === JSON.stringify(original) };
}
run.addEventListener("click", () => {
  try {
    if (typeof Array.prototype.toSorted !== "function") throw new Error("このブラウザーはtoSorted()に未対応です。新しいブラウザーを使用してください。");
    output.textContent = JSON.stringify(compare(input.value), null, 2);
  } catch (error) {
    output.textContent = "入力・実行エラー: " + error.message;
  }
});
