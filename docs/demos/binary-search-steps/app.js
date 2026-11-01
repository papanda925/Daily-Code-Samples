"use strict";
// 数字を昇順に並べた15件の架空データだけを使います。外部送信はありません。
const values = Array.from({ length: 15 }, (_, i) => i + 1);
const targetInput = document.getElementById("target");
const targetLabel = document.getElementById("target-value");
const nextButton = document.getElementById("next");
const resetButton = document.getElementById("reset");
const cells = document.getElementById("cells");
const status = document.getElementById("status");
const history = document.getElementById("history");
let low, high, count, finished, middle;

// 検索する範囲を半分ずつ絞る純粋関数。単体検査しやすい形です。
function binaryStep(lowIndex, highIndex, targetNumber) {
  if (lowIndex > highIndex) return { done: true, found: false, middle: -1, low: lowIndex, high: highIndex };
  const mid = Math.floor((lowIndex + highIndex) / 2);
  const value = values[mid];
  return {
    done: value === targetNumber,
    found: value === targetNumber,
    middle: mid,
    low: value < targetNumber ? mid + 1 : lowIndex,
    high: value > targetNumber ? mid - 1 : highIndex,
    value
  };
}

function draw() {
  const fragment = document.createDocumentFragment();
  for (let i = 0; i < values.length; i++) {
    const cell = document.createElement("li");
    const excluded = i < low || i > high;
    cell.textContent = String(values[i]);
    cell.className = excluded ? "excluded" : "candidate";
    if (i === middle) cell.className = finished ? "found" : "compared";
    cell.setAttribute("aria-label", values[i] + (excluded ? " 除外" : i === middle ? " 今回比較" : " 候補"));
    fragment.append(cell);
  }
  cells.replaceChildren(fragment);
  nextButton.disabled = finished;
  targetLabel.textContent = targetInput.value;
}

function reset() {
  low = 0; high = values.length - 1; count = 0; finished = false; middle = -1;
  history.replaceChildren();
  status.textContent = "まだ比較していません。次の比較を押してください。";
  draw();
}

function next() {
  if (finished) return;
  const target = Number(targetInput.value);
  const result = binaryStep(low, high, target);
  count++;
  middle = result.middle;
  low = result.low; high = result.high;
  finished = result.done || low > high;
  const message = result.found
    ? count + "回目：中央の" + result.value + "が目標と一致。発見しました。"
    : count + "回目：中央は" + result.value + "。目標は" + (result.value < target ? "右側" : "左側") + "です。";
  const item = document.createElement("li");
  item.textContent = message;
  history.append(item);
  status.textContent = message + (finished ? " 比較終了。" : " 次の比較を押してください。");
  draw();
}

targetInput.addEventListener("input", reset);
nextButton.addEventListener("click", next);
resetButton.addEventListener("click", reset);
reset();
