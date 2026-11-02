"use strict";
(() => {
  function measure(text, Segmenter = Intl.Segmenter) {
    const utf16 = text.length;
    const codePoints = Array.from(text).length;
    const graphemes = typeof Segmenter === "function"
      ? Array.from(new Segmenter("ja", { granularity: "grapheme" }).segment(text)).length
      : null;
    return { utf16, codePoints, graphemes };
  }
  if (typeof window !== "undefined") window.GraphemeLab = { measure };
  if (typeof document === "undefined") return;
  const input = document.getElementById("text");
  const utf16 = document.getElementById("utf16");
  const points = document.getElementById("points");
  const graphemes = document.getElementById("graphemes");
  const status = document.getElementById("status");
  function render() {
    const result = measure(input.value);
    utf16.textContent = String(result.utf16);
    points.textContent = String(result.codePoints);
    graphemes.textContent = result.graphemes === null ? "未対応" : String(result.graphemes);
    status.textContent = result.graphemes === null
      ? "この環境ではIntl.Segmenterを使えません。書記素数を推測して表示しません。"
      : result.graphemes > 10
        ? "書記素10個を超えています（教材の警告のみ。入力は切り詰めません）。"
        : "書記素10個以内です（保存・送信は行いません）。";
  }
  input.addEventListener("input", render);
  for (const button of document.querySelectorAll("[data-example]")) {
    button.addEventListener("click", () => {
      input.value = button.dataset.example;
      render();
      input.focus();
    });
  }
  render();
})();
