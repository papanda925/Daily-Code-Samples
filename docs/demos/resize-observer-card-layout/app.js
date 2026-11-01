/* ResizeObserver: fictional card, no network, no external dependencies. */
(() => {
  "use strict";
  const stage = document.getElementById("stage");
  const slider = document.getElementById("width");
  const requested = document.getElementById("requested");
  const status = document.getElementById("status");
  const toggle = document.getElementById("toggle");
  const narrow = document.getElementById("narrow");
  const wide = document.getElementById("wide");
  const modeFor = (width) => width < 360 ? "compact" : "wide";
  let observing = false;
  let observer = null;

  function show(entry) {
    const width = entry.contentBoxSize
      ? (Array.isArray(entry.contentBoxSize)
        ? entry.contentBoxSize[0].inlineSize
        : entry.contentBoxSize.inlineSize)
      : entry.contentRect.width;
    const mode = modeFor(width);
    stage.dataset.layout = mode;
    status.textContent = "実測コンテンツ幅: " + Math.round(width) +
      "px / 表示: " + (mode === "compact" ? "縦並び" : "横並び") +
      " / 観察中";
  }

  function setWidth(value) {
    const n = Math.min(640, Math.max(240, Number(value)));
    slider.value = String(n);
    requested.textContent = n + "px";
    stage.style.width = n + "px";
    if (!observing) {
      status.textContent = "観察停止中：カードの表示と実測値は前回のままです。指定幅 " + n + "px";
    }
  }

  if (typeof ResizeObserver !== "function") {
    toggle.disabled = true;
    slider.disabled = true;
    narrow.disabled = true;
    wide.disabled = true;
    status.textContent = "このブラウザではResizeObserverを利用できません。";
    return;
  }

  observer = new ResizeObserver((entries) => {
    for (const entry of entries) if (entry.target === stage) show(entry);
  });
  function setObserving(enabled) {
    observing = enabled;
    toggle.textContent = enabled ? "観察停止" : "観察再開";
    if (enabled) {
      observer.observe(stage);
    } else {
      observer.unobserve(stage);
      status.textContent = "観察停止中：実測値の更新を止めました。";
    }
  }

  slider.addEventListener("input", () => setWidth(slider.value));
  narrow.addEventListener("click", () => setWidth(300));
  wide.addEventListener("click", () => setWidth(520));
  toggle.addEventListener("click", () => setObserving(!observing));
  window.addEventListener("pagehide", () => observer.disconnect(), { once: true });
  setWidth(300);
  setObserving(true);
})();
