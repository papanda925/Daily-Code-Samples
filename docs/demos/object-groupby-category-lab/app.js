"use strict";
const input = document.querySelector("#input");
const output = document.querySelector("#output");
const button = document.querySelector("#run");
function groupRows(rows) {
  // Object.groupByは分類関数の戻り値をキーにした配列の集合を返す。
  // 戻り値のオブジェクトはnullプロトタイプ。hasOwnPropertyを直接呼ばない。
  return Object.groupBy(rows, row => row.category);
}
function run() {
  try {
    if (typeof Object.groupBy !== "function") {
      throw new Error("Object.groupBy非対応のブラウザーです。最新版を試してください。");
    }
    const rows = input.value.split(/\r?\n/).map((line, i) => {
      const parts = line.split(",");
      if (parts.length !== 2 || !parts[0].trim() || !parts[1].trim()) {
        throw new Error((i + 1) + "行目は「分類,品名」で入力してください。");
      }
      return {category:parts[0].trim(), name:parts[1].trim()};
    });
    if (rows.length > 100) throw new Error("100行以内にしてください。");
    const grouped = groupRows(rows);
    // Object.entriesならnullプロトタイプのオブジェクトも列挙できる。
    output.textContent = JSON.stringify(Object.entries(grouped).map(([category, items]) => ({
      category, count: items.length, names: items.map(item => item.name)
    })), null, 2);
  } catch (error) {
    output.textContent = "エラー: " + error.message;
  }
}
button.addEventListener("click", run);
run();
