"use strict";
const input = document.querySelector("#input");
const delay = document.querySelector("#delay");
const run = document.querySelector("#run");
const output = document.querySelector("#output");

// 非同期ジェネレーターは、値を一つずつ作りながら await できる。
async function* makeRows(lines, waitMs) {
  for (const [index, line] of lines.entries()) {
    await new Promise(resolve => setTimeout(resolve, waitMs));
    yield { number: index + 1, text: line.trim() };
  }
}
async function collect(lines, waitMs) {
  // Array.fromAsync は async iterable を最後まで読み、Promise<Array> を返す。
  return Array.fromAsync(makeRows(lines, waitMs), row => ({
    ...row, length: Array.from(row.text).length
  }));
}
run.addEventListener("click", async () => {
  run.disabled = true;
  output.textContent = "収集中…（完了まで配列は返りません）";
  try {
    const lines = input.value.split(/\r?\n/).filter(line => line.trim() !== "");
    if (lines.length > 20) throw new Error("入力は20行以内にしてください。");
    if (typeof Array.fromAsync !== "function") throw new Error("Array.fromAsync 非対応の環境です。");
    const rows = await collect(lines, Number(delay.value));
    output.textContent = JSON.stringify(rows, null, 2);
  } catch (error) {
    output.textContent = "エラー: " + error.message;
  } finally {
    // エラー時もボタンを戻す。
    run.disabled = false;
  }
});
