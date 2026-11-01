/* 教材: IntersectionObserverの閾値を変え、架空カードの可視割合を観察します。 */
(() => {
  "use strict";
  const root = document.getElementById("viewport");
  const cards = [...root.querySelectorAll(".card")];
  const thresholdSelect = document.getElementById("threshold");
  const toggle = document.getElementById("toggle");
  const reset = document.getElementById("reset");
  const status = document.getElementById("status");
  const summary = document.getElementById("summary");
  const ratios = new Map();
  let observer = null;
  let active = true;

  const threshold = () => Number(thresholdSelect.value);
  const passes = (ratio, limit) => ratio > 0 && ratio >= limit;

  // 通知された割合と条件判定を文字でも表示する。連続測定値ではない。
  function render() {
    let count = 0;
    for (const card of cards) {
      const ratio = ratios.get(card.id) ?? 0;
      const ok = passes(ratio, threshold());
      if (ok) count += 1;
      card.dataset.visible = ok ? "yes" : "no";
      card.querySelector(".ratio").textContent =
        "通知時の可視率: " + Math.round(ratio * 100) + "% / " +
        (ok ? "条件を満たす" : "条件未満");
    }
    summary.textContent = "条件を満たすカード: " + count + " / " + cards.length + "枚";
  }

  // thresholdは作成後に変更できないので、古い監視を解除して作り直す。
  function observeAll() {
    if (observer) observer.disconnect();
    ratios.clear();
    render();
    observer = new IntersectionObserver((entries) => {
      if (!active) return;
      for (const entry of entries) {
        ratios.set(entry.target.id, entry.isIntersecting ? entry.intersectionRatio : 0);
      }
      render();
    }, { root, threshold: [0, threshold(), 1] });
    for (const card of cards) observer.observe(card);
    status.textContent = "観察中：閾値 " + Math.round(threshold() * 100) +
      "%。枠内をスクロールしてください。";
  }

  if (typeof IntersectionObserver !== "function") {
    for (const control of [thresholdSelect, toggle, reset]) control.disabled = true;
    status.textContent = "このブラウザはIntersectionObserverに対応していません。";
    summary.textContent = "計測できません。";
    return;
  }

  thresholdSelect.addEventListener("change", () => {
    if (active) observeAll();
    else {
      ratios.clear();
      render();
      status.textContent = "観察停止中：閾値変更は再開後に反映します。";
    }
  });
  toggle.addEventListener("click", () => {
    active = !active;
    toggle.textContent = active ? "観察停止" : "観察再開";
    if (active) observeAll();
    else {
      observer?.disconnect();
      status.textContent = "観察停止中：表示は最後の通知時点で固定されます。";
    }
  });
  reset.addEventListener("click", () => {
    root.scrollTop = 0;
    if (active) observeAll();
    else status.textContent = "先頭へ戻しました。観察は停止中です。";
  });
  window.addEventListener("pagehide", () => observer?.disconnect(), { once: true });
  observeAll();
})();
