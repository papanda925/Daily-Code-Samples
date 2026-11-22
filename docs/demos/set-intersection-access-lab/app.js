"use strict";
// Set.intersection は両方の集合に存在する要素だけを返す。
// 配列と違い、Set 内の同じ値は1回しか保持されない。
const output = document.querySelector("#result");
const requested = document.querySelector("#requested");
const allowed = document.querySelector("#allowed");
const run = document.querySelector("#run");
function parseIds(text) {
  // 空欄は空集合。カンマ区切りの前後の空白を除き、空要素を捨てる。
  return new Set(text.split(",").map(value => value.trim()).filter(Boolean));
}
function evaluate() {
  const wants = parseIds(requested.value);
  const grants = parseIds(allowed.value);
  // 非対応ブラウザでは誤った判定をせず明示的に案内する。
  if (typeof Set.prototype.intersection !== "function") {
    output.textContent = "このブラウザはSet.intersection()に未対応です。最新版のブラウザで試してください。";
    return;
  }
  const common = wants.intersection(grants);
  const denied = wants.difference(grants);
  const granted = [...common].sort();
  const rejected = [...denied].sort();
  output.textContent = [
    "要求数（重複除外）: " + wants.size,
    "許可数（重複除外）: " + grants.size,
    "共通: " + (granted.join(", ") || "なし"),
    "許可されない要求: " + (rejected.join(", ") || "なし")
  ].join("\n");
}
run.addEventListener("click", evaluate);
evaluate();
