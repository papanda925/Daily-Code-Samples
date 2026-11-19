"use strict";
// この教材はネットワーク通信をせず、タイマーを非同期処理の代わりに使います。
const form = document.querySelector("#lab");
const result = document.querySelector("#result");
const stop = document.querySelector("#stop");
let controller = null;
let running = false;
const sleep = (ms, signal) => new Promise((resolve, reject) => {
  if (signal.aborted) { reject(signal.reason); return; }
  const timer = setTimeout(() => { signal.removeEventListener("abort", onAbort); resolve("処理完了"); }, ms);
  function onAbort() {
    clearTimeout(timer); // 中止後に完了通知が出ないようにタイマーを解除
    signal.removeEventListener("abort", onAbort);
    reject(signal.reason);
  }
  signal.addEventListener("abort", onAbort, { once: true });
});
form.addEventListener("submit", async (event) => {
  event.preventDefault();
  if (running) return;
  const workMs = Number(document.querySelector("#work").value);
  const limitMs = Number(document.querySelector("#limit").value);
  if (![workMs, limitMs].every(Number.isFinite) || workMs < 0 || limitMs < 1 || workMs > 10000 || limitMs > 10000) {
    result.textContent = "0〜10000ミリ秒の範囲で入力してください（制限は1以上）。"; return;
  }
  if (!AbortSignal.any || !AbortSignal.timeout) {
    result.textContent = "このブラウザーは必要なAbortSignal APIに対応していません。"; return;
  }
  controller = new AbortController();
  // 手動停止と時間切れのいずれか先に起きた理由を採用します。
  const combined = AbortSignal.any([controller.signal, AbortSignal.timeout(limitMs)]);
  running = true;
  form.querySelector("button").disabled = true;
  stop.disabled = false;
  result.textContent = "実行中…";
  try {
    const message = await sleep(workMs, combined);
    result.textContent = message + "（中止なし）";
  } catch (error) {
    // TimeoutErrorとAbortErrorは異なる理由です。
    result.textContent = error?.name === "TimeoutError" ? "時間切れで中止（TimeoutError）" :
      error?.name === "AbortError" ? "手動で中止（AbortError）" : "中止: " + String(error);
  } finally {
    running = false;
    controller = null;
    form.querySelector("button").disabled = false;
    stop.disabled = true;
  }
});
stop.addEventListener("click", () => {
  if (controller && !controller.signal.aborted) {
    controller.abort(new DOMException("手動停止", "AbortError"));
  }
});
