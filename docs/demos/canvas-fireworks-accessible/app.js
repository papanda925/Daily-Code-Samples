"use strict";
(() => {
  const canvas = document.getElementById("sky");
  const status = document.getElementById("status");
  const launchButton = document.getElementById("launch");
  const pauseButton = document.getElementById("pause");
  const clearButton = document.getElementById("clear");
  const countInput = document.getElementById("count");
  const countLabel = document.getElementById("count-label");
  const ctx = canvas.getContext("2d");
  if (!ctx) { status.textContent = "ERROR: Canvas 2Dを利用できません"; return; }

  const reducedMotion = window.matchMedia("(prefers-reduced-motion: reduce)").matches;
  const bursts = [];
  let playing = !reducedMotion;
  let requestId = null;
  let launchCount = 0;
  let width = 1;
  let height = 1;

  function report(message) { status.textContent = message; }
  function paint() {
    ctx.fillStyle = "#102a47";
    ctx.fillRect(0, 0, width, height);
    for (const burst of bursts) {
      for (const p of burst) {
        ctx.beginPath();
        ctx.arc(p.x, p.y, 3.2, 0, Math.PI * 2);
        ctx.fillStyle = "hsla(" + p.hue + ",90%,72%," + p.life + ")";
        ctx.fill();
      }
    }
  }
  function resize() {
    const box = canvas.getBoundingClientRect();
    width = Math.max(1, box.width);
    height = Math.max(1, box.height);
    const ratio = Math.min(window.devicePixelRatio || 1, 2);
    canvas.width = Math.round(width * ratio);
    canvas.height = Math.round(height * ratio);
    ctx.setTransform(ratio, 0, 0, ratio, 0, 0);
    paint();
  }
  function tick() {
    requestId = null;
    if (!playing) return;
    for (const burst of bursts) {
      for (const p of burst) {
        p.x += p.vx;
        p.y += p.vy;
        p.vy += 0.045;
        p.life = Math.max(0, p.life - 0.012);
      }
    }
    for (let i = bursts.length - 1; i >= 0; i--) {
      if (bursts[i].every(p => p.life === 0)) bursts.splice(i, 1);
    }
    paint();
    if (bursts.length) requestId = requestAnimationFrame(tick);
  }
  function ensureFrame() {
    if (playing && requestId === null && bursts.length) requestId = requestAnimationFrame(tick);
  }
  function launch(x = width / 2, y = height / 2) {
    const count = Number(countInput.value);
    const particles = [];
    const baseHue = (launchCount * 57 + 185) % 360;
    for (let i = 0; i < count; i++) {
      const angle = (i / count) * Math.PI * 2;
      const speed = 1.3 + (i % 4) * 0.35;
      particles.push({
        x, y, vx: Math.cos(angle) * speed, vy: Math.sin(angle) * speed,
        hue: (baseHue + i * 5) % 360, life: 1
      });
    }
    bursts.push(particles);
    if (bursts.length > 4) bursts.shift();
    launchCount++;
    paint();
    report("花火 " + launchCount + " 回目・粒子 " + count + " 個" +
      (reducedMotion ? "（動きを減らす設定：静止表示）" : playing ? "（再生中）" : "（一時停止中）"));
    ensureFrame();
  }
  launchButton.addEventListener("click", () => launch());
  canvas.addEventListener("click", event => {
    const rect = canvas.getBoundingClientRect();
    launch(event.clientX - rect.left, event.clientY - rect.top);
  });
  pauseButton.addEventListener("click", () => {
    if (reducedMotion) { report("動きを減らす設定中です。静止画として表示します"); return; }
    playing = !playing;
    if (!playing && requestId !== null) {
      cancelAnimationFrame(requestId);
      requestId = null;
    }
    pauseButton.textContent = playing ? "一時停止" : "再開";
    report(playing ? "再生中" : "一時停止中");
    ensureFrame();
  });
  clearButton.addEventListener("click", () => {
    bursts.length = 0;
    if (requestId !== null) cancelAnimationFrame(requestId);
    requestId = null;
    paint();
    report("消去しました。花火ボタンまたは空をクリックしてください");
  });
  countInput.addEventListener("input", () => {
    countLabel.textContent = countInput.value + " 個";
  });
  window.addEventListener("resize", resize);
  if (reducedMotion) {
    pauseButton.disabled = true;
    pauseButton.textContent = "静止表示";
  }
  resize();
  report(reducedMotion ? "動きを減らす設定を検出：静止画モード" : "準備完了：花火ボタンを押してください");
})();