"use strict";
(() => {
  const $ = id => document.getElementById(id);
  const canvas = $("scope");
  const pen = canvas.getContext("2d");
  const start = $("start");
  const stop = $("stop");
  const hz = $("hz");
  const hzValue = $("hz-value");
  const mute = $("mute");
  const snapshot = $("snapshot");
  const status = $("status");
  const reduced = window.matchMedia("(prefers-reduced-motion: reduce)");
  let context = null, oscillator = null, analyser = null, gain = null;
  let frame = 0, playing = false;
  const samples = new Uint8Array(1024);

  function clampHz(value) {
    const n = Number(value);
    return Number.isFinite(n) ? Math.max(110, Math.min(880, Math.round(n))) : 220;
  }
  function setStatus(message) { status.textContent = message; }
  function drawFlat() {
    pen.clearRect(0, 0, canvas.width, canvas.height);
    pen.fillStyle = "#f4f8fc";
    pen.fillRect(0, 0, canvas.width, canvas.height);
    pen.strokeStyle = "#8ba2b9";
    pen.lineWidth = 1;
    pen.beginPath();
    pen.moveTo(0, canvas.height / 2);
    pen.lineTo(canvas.width, canvas.height / 2);
    pen.stroke();
  }
  function draw() {
    drawFlat();
    if (!analyser) return;
    analyser.getByteTimeDomainData(samples);
    pen.strokeStyle = "#175c9d";
    pen.lineWidth = 3;
    pen.beginPath();
    const step = canvas.width / (samples.length - 1);
    for (let i = 0; i < samples.length; i++) {
      const y = samples[i] / 255 * canvas.height;
      if (i === 0) pen.moveTo(0, y);
      else pen.lineTo(i * step, y);
    }
    pen.stroke();
  }
  function animate() {
    if (!playing) return;
    draw();
    if (!reduced.matches) frame = requestAnimationFrame(animate);
  }
  function applyControls() {
    const f = clampHz(hz.value);
    hzValue.textContent = String(f) + " Hz";
    if (oscillator && context) oscillator.frequency.setTargetAtTime(f, context.currentTime, 0.015);
    if (gain && context) gain.gain.setTargetAtTime(mute.checked ? 0 : 0.02, context.currentTime, 0.015);
    if (playing && reduced.matches) draw();
  }
  async function stopAudio() {
    playing = false;
    cancelAnimationFrame(frame);
    frame = 0;
    start.disabled = false;
    stop.disabled = true;
    snapshot.disabled = true;
    const oldOsc = oscillator, oldContext = context;
    oscillator = null; analyser = null; gain = null; context = null;
    try { if (oldOsc) oldOsc.stop(); } catch (_) { /* すでに停止した場合 */ }
    try { if (oldContext && oldContext.state !== "closed") await oldContext.close(); }
    catch (_) { /* ブラウザによる終了処理の拒否 */ }
    drawFlat();
    setStatus("停止中。音声・マイク入力なし。");
  }
  async function startAudio() {
    if (playing || !window.AudioContext) {
      if (!window.AudioContext) setStatus("このブラウザは AudioContext に未対応です。");
      return;
    }
    start.disabled = true;
    try {
      // 再生開始はユーザーが押したボタンのイベント内だけで行う。
      const c = new AudioContext();
      context = c;
      const o = c.createOscillator();
      const a = c.createAnalyser();
      const g = c.createGain();
      a.fftSize = 1024;
      o.type = "sine";
      o.frequency.value = clampHz(hz.value);
      g.gain.value = 0; // 初期状態は必ず無音。
      o.connect(a);
      a.connect(g);
      g.connect(c.destination);
      oscillator = o; analyser = a; gain = g;
      await c.resume();
      if (context !== c) return;
      o.start();
      playing = true;
      stop.disabled = false;
      snapshot.disabled = false;
      applyControls();
      setStatus("動作中：" + clampHz(hz.value) + " Hz。音声は" + (mute.checked ? "ミュート" : "小音量") + "。");
      animate();
    } catch (error) {
      await stopAudio();
      setStatus("開始できません。ブラウザの音声設定と開発者ツールを確認してください。");
    }
  }
  hz.addEventListener("input", () => { applyControls(); if (playing) setStatus("動作中：" + clampHz(hz.value) + " Hz。音声は" + (mute.checked ? "ミュート" : "小音量") + "。"); });
  mute.addEventListener("change", () => { applyControls(); if (playing) setStatus(mute.checked ? "動作中・ミュート。" : "動作中・小音量。音量に注意。"); });
  start.addEventListener("click", startAudio);
  stop.addEventListener("click", stopAudio);
  snapshot.addEventListener("click", draw);
  document.addEventListener("visibilitychange", () => { if (document.hidden && playing) stopAudio(); });
  window.addEventListener("pagehide", () => { if (playing) stopAudio(); });
  drawFlat();
  applyControls();
  setStatus("停止中。初期状態はミュート。開始しても無音のまま波形を観察できます。");
})();
