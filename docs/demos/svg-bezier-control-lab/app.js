"use strict";
// すべての座標は教材用の架空値。ユーザー入力は範囲指定スライダーのみ。
const topSlider = document.getElementById("control1");
const bottomSlider = document.getElementById("control2");
const route = document.getElementById("route");
const helper1 = document.getElementById("helper1");
const helper2 = document.getElementById("helper2");
const point1 = document.getElementById("point1");
const point2 = document.getElementById("point2");
const readout = document.getElementById("readout");
const code = document.getElementById("pathCode");
const reset = document.getElementById("reset");
const straight = document.getElementById("straight");

function draw() {
  const y1 = Number(topSlider.value);
  const y2 = Number(bottomSlider.value);
  // SVGのMは始点、Cは制御点2個と終点を指定する三次ベジェ曲線。
  const d = `M 60 160 C 200 ${y1} 400 ${y2} 540 160`;
  route.setAttribute("d", d);
  helper1.setAttribute("y2", String(y1));
  helper2.setAttribute("y2", String(y2));
  point1.setAttribute("cy", String(y1));
  point2.setAttribute("cy", String(y2));
  code.textContent = d;
  const description = y1 === 160 && y2 === 160
    ? "制御点が両方とも中央です。曲線は水平な直線になります。"
    : `制御点1の高さは${y1}、制御点2の高さは${y2}です。線の曲がり方を確認してください。`;
  readout.textContent = description;
}
topSlider.addEventListener("input", draw);
bottomSlider.addEventListener("input", draw);
reset.addEventListener("click", () => {
  topSlider.value = "70";
  bottomSlider.value = "250";
  draw();
});
straight.addEventListener("click", () => {
  topSlider.value = "160";
  bottomSlider.value = "160";
  draw();
});
draw();
