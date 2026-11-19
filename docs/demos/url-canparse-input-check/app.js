"use strict";
// 入力のURLを、実際の通信なしで安全に判定する教材です。
const form = document.querySelector("#check-form");
const input = document.querySelector("#url-input");
const baseInput = document.querySelector("#base-input");
const output = document.querySelector("#result");
form.addEventListener("submit", (event) => {
  event.preventDefault();
  const raw = input.value.trim();
  const base = baseInput.value.trim();
  if (!raw) { output.textContent = "URLが空です。入力してください。"; return; }
  try {
    // 相対URLを使うときは基準URLが必要です。ここでは任意入力です。
    const ok = base ? URL.canParse(raw, base) : URL.canParse(raw);
    if (!ok) { output.textContent = "URLとして解析できません。"; return; }
    const parsed = base ? new URL(raw, base) : new URL(raw);
    // canParseはURLの安全性や通信先の信頼性を保証しません。
    const web = parsed.protocol === "https:" || parsed.protocol === "http:";
    output.textContent = [
      "解析: 成功",
      "正規化URL: " + parsed.href,
      "プロトコル: " + parsed.protocol,
      "ホスト: " + (parsed.host || "なし"),
      "Web URL: " + (web ? "はい" : "いいえ"),
      web ? "注意: 正しい形式でも安全なサイトとは限りません。" : "注意: HTTP(S)以外はWebリンクとして扱わないでください。"
    ].join("\n");
  } catch (error) {
    output.textContent = "基準URLまたは入力値を確認してください。詳細: " + error.name;
  }
});