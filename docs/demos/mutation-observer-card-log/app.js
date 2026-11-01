"use strict";
// MutationObserverの対象はカード一覧だけ。ログ欄を監視対象にしないことで無限通知を避ける。
(() => {
  const list = document.getElementById("cards");
  const log = document.getElementById("log");
  const summary = document.getElementById("summary");
  const count = document.getElementById("card-count");
  const addButton = document.getElementById("add");
  const toggleButton = document.getElementById("toggle");
  const removeButton = document.getElementById("remove");
  const stopButton = document.getElementById("stop");
  const resumeButton = document.getElementById("resume");
  const clearButton = document.getElementById("clear");
  const controls = [addButton, toggleButton, removeButton, stopButton, resumeButton, clearButton];
  if (!list || !log || !summary || controls.some((button) => !button)) return;
  if (typeof MutationObserver === "undefined") {
    summary.textContent = "このブラウザはMutationObserverに対応していません。";
    controls.forEach((button) => { button.disabled = true; });
    return;
  }

  let nextNumber = 3;
  let notifications = 0;
  let watching = false;

  function refresh() {
    count.textContent = String(list.children.length);
    addButton.disabled = list.children.length >= 8;
    toggleButton.disabled = list.children.length === 0;
    removeButton.disabled = list.children.length === 0;
    stopButton.disabled = !watching;
    resumeButton.disabled = watching;
  }

  // 監視結果は文字列として記録。入力値をHTMLとして解釈しない。
  function appendLog(message) {
    notifications += 1;
    const item = document.createElement("li");
    item.textContent = message;
    log.prepend(item);
    while (log.children.length > 12) log.lastElementChild.remove();
    summary.textContent = (watching ? "監視中" : "停止中") + "・通知 " + notifications + " 件";
  }

  const observer = new MutationObserver((records) => {
    for (const record of records) {
      if (record.type === "childList" && record.target === list) {
        if (record.addedNodes.length) appendLog("追加：" + record.addedNodes.length + "枚");
        if (record.removedNodes.length) appendLog("削除：" + record.removedNodes.length + "枚");
      }
      if (record.type === "attributes" && record.attributeName === "data-state") {
        const name = record.target.querySelector("strong")?.textContent || "カード";
        const before = record.oldValue === null ? "不明" : record.oldValue;
        const after = record.target.getAttribute("data-state");
        appendLog(name + "の状態：" + before + " → " + after);
      }
    }
  });

  function start() {
    // subtreeで子カードの属性を追い、childListは一覧直下の変更だけを記録する。
    observer.observe(list, {
      childList: true,
      subtree: true,
      attributes: true,
      attributeFilter: ["data-state"],
      attributeOldValue: true
    });
    watching = true;
    summary.textContent = "監視中・通知 " + notifications + " 件";
    refresh();
  }

  addButton.addEventListener("click", () => {
    if (list.children.length >= 8) return;
    const card = document.createElement("li");
    card.className = "card";
    card.setAttribute("data-state", "pending");
    const label = document.createElement("strong");
    label.textContent = "カード" + nextNumber++;
    const state = document.createElement("span");
    state.className = "state";
    state.textContent = "未完了";
    card.append(label, state);
    list.append(card);
    refresh();
  });

  toggleButton.addEventListener("click", () => {
    const card = list.firstElementChild;
    if (!card) return;
    const done = card.getAttribute("data-state") !== "done";
    card.setAttribute("data-state", done ? "done" : "pending");
    card.querySelector(".state").textContent = done ? "完了" : "未完了";
  });

  removeButton.addEventListener("click", () => {
    list.lastElementChild?.remove();
    refresh();
  });

  stopButton.addEventListener("click", () => {
    // 未配信の変更通知は破棄され得る。停止中の変更は後から再生されない。
    observer.disconnect();
    watching = false;
    summary.textContent = "停止中・通知 " + notifications + " 件";
    refresh();
  });

  resumeButton.addEventListener("click", start);

  clearButton.addEventListener("click", () => {
    log.replaceChildren();
    notifications = 0;
    summary.textContent = (watching ? "監視中" : "停止中") + "・通知 0 件";
  });

  start();
})();
