"use strict";
// 静的デモの架空ID。HTMLのidにはASCII空白を含めない。
const rows = [
  { id: "ticket:01", name: "コロン付きID" },
  { id: "ticket.02", name: "ピリオド付きID" },
  { id: "123-start", name: "数字始まりID" },
  { id: "a[b]", name: "角括弧付きID" },
];

// IDそのものをCSS識別子として変換してから#に続ける。
// 文字列をHTMLへ解釈させない。空文字はセレクター#が不正になるため検索しない。
function selectById(root, id, escapeFn) {
  if (typeof id !== "string" || id.length > 80) {
    throw new RangeError("IDは80文字以内の文字列にしてください");
  }
  if (id.length === 0) return null;
  if (typeof escapeFn !== "function") {
    throw new TypeError("CSS.escapeが使えません");
  }
  return root.querySelector("#" + escapeFn(id));
}

if (typeof module !== "undefined") module.exports = { rows, selectById };

if (typeof document !== "undefined") {
  const list = document.querySelector("#tickets");
  const status = document.querySelector("#status");
  // 固定データをDOMノードで作り、textContentで文字列を設定する。
  for (const item of rows) {
    const el = document.createElement("li");
    el.id = item.id;
    el.textContent = item.name + " / " + item.id;
    list.append(el);
  }
  document.querySelector("#run").addEventListener("click", () => {
    const id = document.querySelector("#target").value;
    try {
      const hit = selectById(list, id, globalThis.CSS?.escape);
      status.textContent = hit ? "見つかった: " + hit.textContent : "一致なし（入力を確認）";
    } catch (error) {
      status.textContent = "検索できません: " + error.message;
    }
  });
  document.querySelector("#reset").addEventListener("click", () => {
    document.querySelector("#target").value = "ticket:01";
    status.textContent = "未検索";
  });
}
