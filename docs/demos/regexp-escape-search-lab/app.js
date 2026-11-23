"use strict";
const input = document.querySelector("#needle");
const output = document.querySelector("#result");
const button = document.querySelector("#search");
const sample = "商品 A+B は在庫あり。商品 AB は在庫なし。価格 (税込) は100円。";
// RegExp.escapeはユーザー入力を正規表現の「文字列そのもの」として扱うために使う。
// + や ( ) を正規表現の演算子として解釈させないことが目的。
function findLiteral(text, keyword) {
  if (!keyword) return {count: 0, matches: [], expression: "(空欄)"};
  if (typeof RegExp.escape !== "function") throw new Error("このブラウザーはRegExp.escape()に未対応です。");
  const expression = RegExp.escape(keyword);
  const regex = new RegExp(expression, "g");
  const matches = Array.from(text.matchAll(regex), m => m[0]);
  return {count: matches.length, matches, expression};
}
function run() {
  try {
    const value = findLiteral(sample, input.value);
    output.textContent = "検索対象: " + sample + "\nエスケープ結果: " + value.expression +
      "\n一致件数: " + value.count + "\n一致内容: " + JSON.stringify(value.matches);
  } catch (error) {
    // エラー内容はtextContentで表示し、入力をHTMLとして解釈しない。
    output.textContent = "検索できません: " + error.message;
  }
}
button.addEventListener("click", run);
run();
