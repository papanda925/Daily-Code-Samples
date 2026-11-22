"use strict";
// Promise.withResolvers() は promise と resolve/reject をまとめて返す。
// 処理を開始する関数と、完了を通知する関数を分離する教材。
const log = document.querySelector("#log");
const button = document.querySelector("#run");
const delayInput = document.querySelector("#delay");
const failInput = document.querySelector("#fail");
function append(message) {
  const line = document.createElement("li");
  line.textContent = message; // 入力値をHTMLとして解釈しない
  log.append(line);
}
async function run() {
  log.replaceChildren();
  button.disabled = true; // 二重実行による混乱を防ぐ
  let timer;
  try {
    if (typeof Promise.withResolvers !== "function") {
      throw new Error("このブラウザーはPromise.withResolvers()に未対応です");
    }
    const delay = Number(delayInput.value);
    if (!Number.isInteger(delay) || delay < 0 || delay > 3000) {
      throw new Error("待ち時間は0〜3000の整数を入力してください");
    }
    const { promise, resolve, reject } = Promise.withResolvers();
    append("1. Promise作成：まだ保留中");
    timer = setTimeout(() => {
      if (failInput.checked) {
        append("2. rejectを呼び出し");
        reject(new Error("架空の処理が失敗しました"));
      } else {
        append("2. resolveを呼び出し");
        resolve("架空の処理が完了しました");
      }
    }, delay);
    // await はPromiseの確定まで待機し、失敗時はcatchへ進む。
    const result = await promise;
    append("3. 成功：" + result);
  } catch (error) {
    append("3. 失敗：" + error.message);
  } finally {
    clearTimeout(timer); // 例外発生時もタイマーを後始末
    button.disabled = false;
  }
}
button.addEventListener("click", run);
