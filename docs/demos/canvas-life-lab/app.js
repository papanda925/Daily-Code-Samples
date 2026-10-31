"use strict";
(() => {
  const size = 16, cell = 24;
  const boardCanvas = document.getElementById("board");
  const ctx = boardCanvas.getContext("2d");
  const status = document.getElementById("status");
  const toggle = document.getElementById("toggle");
  const step = document.getElementById("step");
  const reset = document.getElementById("reset");
  const pattern = document.getElementById("pattern");
  const rowInput = document.getElementById("row");
  const colInput = document.getElementById("col");
  const setCell = document.getElementById("set-cell");
  const reduced = matchMedia("(prefers-reduced-motion: reduce)").matches;
  if (!ctx || !window.LifeLogic) {
    status.textContent = "Canvas 2Dまたはlogic.jsを読み込めません。";
    [toggle, step, reset, setCell].forEach(button => button.disabled = true);
    return;
  }
  let board = LifeLogic.preset("blinker", size), generation = 0, timer = null;
  function stop() {
    if (timer !== null) clearInterval(timer);
    timer = null;
    toggle.textContent = "再生";
  }
  function draw() {
    ctx.fillStyle = "#f5f9ff";
    ctx.fillRect(0, 0, boardCanvas.width, boardCanvas.height);
    for (let r = 0; r < size; r++) for (let c = 0; c < size; c++) {
      ctx.fillStyle = board[r][c] ? "#1267a0" : "#e4edf7";
      ctx.fillRect(c * cell + 1, r * cell + 1, cell - 2, cell - 2);
    }
    status.textContent = "第" + generation + "世代／生きたマス：" + LifeLogic.count(board) + "個／" + (timer ? "再生中" : "停止中");
  }
  function advance() { board = LifeLogic.next(board); generation++; draw(); }
  function toggleCell(r, c) {
    if (!Number.isInteger(r) || !Number.isInteger(c) || r < 0 || c < 0 || r >= size || c >= size) return;
    stop();
    board[r][c] = !board[r][c];
    generation = 0;
    draw();
  }
  toggle.addEventListener("click", () => {
    if (timer !== null) { stop(); draw(); return; }
    if (reduced) { status.textContent = "動きを減らす設定です。『1世代進める』で試してください。"; return; }
    timer = setInterval(advance, 700);
    toggle.textContent = "一時停止";
    draw();
  });
  step.addEventListener("click", () => { stop(); advance(); });
  reset.addEventListener("click", () => {
    stop(); board = LifeLogic.preset(pattern.value, size); generation = 0; draw();
  });
  pattern.addEventListener("change", () => reset.click());
  setCell.addEventListener("click", () => toggleCell(Number(rowInput.value) - 1, Number(colInput.value) - 1));
  boardCanvas.addEventListener("click", event => {
    const rect = boardCanvas.getBoundingClientRect();
    if (!rect.width || !rect.height) return;
    const c = Math.floor((event.clientX - rect.left) / rect.width * size);
    const r = Math.floor((event.clientY - rect.top) / rect.height * size);
    toggleCell(r, c);
  });
  document.addEventListener("visibilitychange", () => { if (document.hidden) { stop(); draw(); } });
  window.addEventListener("pagehide", stop);
  draw();
})();
