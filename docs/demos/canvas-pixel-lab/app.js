"use strict";

// RGBAを4要素ずつ処理。元のImageDataは変更しない。
function transformPixels(input, brightness, grayscale) {
  const out = new Uint8ClampedArray(input);
  const delta = Math.max(-100, Math.min(100, Number(brightness) || 0));
  for (let i = 0; i < out.length; i += 4) {
    let r = input[i], g = input[i + 1], b = input[i + 2];
    if (grayscale) {
      const gray = Math.round(0.2126 * r + 0.7152 * g + 0.0722 * b);
      r = gray; g = gray; b = gray;
    }
    out[i] = r + delta;
    out[i + 1] = g + delta;
    out[i + 2] = b + delta;
    out[i + 3] = input[i + 3]; // 透明度は変更しない
  }
  return out;
}

if (typeof module !== "undefined" && module.exports) {
  module.exports = { transformPixels };
}

if (typeof document !== "undefined") {
  const original = document.getElementById("original");
  const result = document.getElementById("result");
  const slider = document.getElementById("brightness");
  const gray = document.getElementById("grayscale");
  const reset = document.getElementById("reset");
  const readout = document.getElementById("readout");
  const sourceCtx = original?.getContext("2d", { willReadFrequently: true });
  const targetCtx = result?.getContext("2d");
  if (!sourceCtx || !targetCtx) {
    if (readout) readout.textContent = "Canvas 2Dを利用できません。別のブラウザで確認してください。";
  } else {
    const size = 24;
    // 外部画像を読み込まず、8×8の架空の色見本をCanvas上で生成する。
    for (let y = 0; y < 8; y++) {
      for (let x = 0; x < 8; x++) {
        const r = 40 + x * 26;
        const g = 35 + y * 27;
        const b = 45 + ((x + y) % 8) * 27;
        sourceCtx.fillStyle = `rgb(${r}, ${g}, ${b})`;
        sourceCtx.fillRect(x * size, y * size, size, size);
      }
    }
    const source = sourceCtx.getImageData(0, 0, 192, 192);
    const center = ((4 * size + 12) * 192 + (4 * size + 12)) * 4;
    function rgbAt(data, i) {
      return `${data[i]}, ${data[i + 1]}, ${data[i + 2]}`;
    }
    function render() {
      const amount = Number(slider.value);
      const output = transformPixels(source.data, amount, gray.checked);
      const frame = targetCtx.createImageData(source.width, source.height);
      frame.data.set(output);
      targetCtx.putImageData(frame, 0, 0);
      readout.textContent =
        `明るさ ${amount > 0 ? "+" : ""}${amount}、白黒 ${gray.checked ? "ON" : "OFF"}。中央のRGB: ${rgbAt(source.data, center)} → ${rgbAt(output, center)}。透明度は保持。`;
    }
    slider.addEventListener("input", render);
    gray.addEventListener("change", render);
    reset.addEventListener("click", () => {
      slider.value = "0";
      gray.checked = false;
      render();
    });
    render();
  }
}
