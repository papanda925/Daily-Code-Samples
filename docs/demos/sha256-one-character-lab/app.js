"use strict";
// SHA-256比較教材。入力はブラウザ内だけで処理し、送信・保存しません。
const byId = (id) => document.getElementById(id);
const DEFAULT_A = "papanda";
const DEFAULT_B = "papandb";
let currentRequest = 0;

function toHex(bytes) {
  return Array.from(bytes, (byte) => byte.toString(16).padStart(2, "0")).join("");
}

function bitDifference(left, right) {
  if (left.length !== right.length) throw new Error("比較する配列長が違います");
  let count = 0;
  for (let i = 0; i < left.length; i += 1) {
    let bits = left[i] ^ right[i];
    while (bits > 0) {
      count += bits & 1;
      bits >>>= 1;
    }
  }
  return count;
}

async function hashText(text) {
  const bytes = new TextEncoder().encode(text);
  const buffer = await window.crypto.subtle.digest("SHA-256", bytes);
  return { digest: new Uint8Array(buffer), utf8Bytes: bytes.length };
}

function paintBytes(left, right) {
  const grid = byId("byteGrid");
  const fragment = document.createDocumentFragment();
  for (let i = 0; i < left.length; i += 1) {
    const same = left[i] === right[i];
    const tile = document.createElement("span");
    tile.className = "byte " + (same ? "same" : "different");
    tile.textContent = String(i + 1);
    tile.title = "第" + (i + 1) + "バイト：" + (same ? "一致" : "異なる");
    tile.setAttribute("aria-label", tile.title);
    fragment.appendChild(tile);
  }
  grid.replaceChildren(fragment);
}

async function compare() {
  const requestId = ++currentRequest;
  const status = byId("status");
  const leftText = byId("textA").value;
  const rightText = byId("textB").value;
  if (!window.isSecureContext || !window.crypto || !window.crypto.subtle) {
    status.textContent = "SHA-256が利用できません。HTTPSまたはlocalhostで開いてください。";
    return;
  }
  status.textContent = "計算しています…";
  try {
    const [left, right] = await Promise.all([hashText(leftText), hashText(rightText)]);
    if (requestId !== currentRequest) return; // 連打で古い結果を上書きしない
    byId("hashA").textContent = toHex(left.digest);
    byId("hashB").textContent = toHex(right.digest);
    byId("bytesA").textContent = String(left.utf8Bytes);
    byId("bytesB").textContent = String(right.utf8Bytes);
    const differentBits = bitDifference(left.digest, right.digest);
    byId("diffBits").textContent = String(differentBits);
    byId("diffBytes").textContent = String(left.digest.reduce((n, b, i) => n + (b !== right.digest[i] ? 1 : 0), 0));
    paintBytes(left.digest, right.digest);
    status.textContent = "計算完了。色付きマスと差分ビット数を確認してください。";
  } catch (error) {
    if (requestId !== currentRequest) return;
    status.textContent = "計算できませんでした。安全な接続とブラウザ対応状況を確認してください。";
    byId("hashA").textContent = "未計算";
    byId("hashB").textContent = "未計算";
    byId("byteGrid").replaceChildren();
  }
}

document.addEventListener("DOMContentLoaded", () => {
  byId("form").addEventListener("submit", (event) => {
    event.preventDefault();
    void compare();
  });
  byId("reset").addEventListener("click", () => {
    byId("textA").value = DEFAULT_A;
    byId("textB").value = DEFAULT_B;
    void compare();
  });
  void compare();
});
