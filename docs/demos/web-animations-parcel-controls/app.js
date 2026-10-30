/* No external calls. Browser-native Web Animations API practice. */
(() => {
  "use strict";
  const track = document.getElementById("track");
  const parcel = document.getElementById("parcel");
  const play = document.getElementById("play");
  const pause = document.getElementById("pause");
  const reset = document.getElementById("reset");
  const speed = document.getElementById("speed");
  const status = document.getElementById("status");
  const reduced = window.matchMedia
    ? window.matchMedia("(prefers-reduced-motion: reduce)")
    : { matches: false };
  let animation = null;
  const rate = () => Number(speed.value);
  const report = (text) => { status.textContent = text; };

  function setRate() {
    if (!animation) return;
    if (typeof animation.updatePlaybackRate === "function") {
      animation.updatePlaybackRate(rate());
    } else {
      animation.playbackRate = rate();
    }
  }

  function setup() {
    if (animation) animation.cancel();
    animation = null;
    parcel.style.transform = "translateX(0px)";
    if (reduced.matches || typeof parcel.animate !== "function") {
      play.disabled = true;
      pause.disabled = true;
      speed.disabled = true;
      report(reduced.matches ? "静止表示：端末の動き軽減設定を尊重します。" :
        "このブラウザはElement.animate()に対応していません。");
      return;
    }
    const distance = Math.max(0, track.clientWidth - parcel.offsetWidth - 32);
    animation = parcel.animate(
      [{ transform: "translateX(0px)" },
       { transform: "translateX(" + distance + "px)" }],
      { duration: 2600, iterations: Infinity, direction: "alternate",
        easing: "ease-in-out" }
    );
    animation.pause();
    play.disabled = false;
    pause.disabled = false;
    speed.disabled = false;
    setRate();
    report("準備完了：速度" + rate() + "倍。再生を押してください。");
  }

  play.addEventListener("click", () => {
    if (!animation) return;
    animation.play();
    report("再生中：速度" + rate() + "倍。左右への移動を観察してください。");
  });
  pause.addEventListener("click", () => {
    if (!animation) return;
    animation.pause();
    report("一時停止：速度" + rate() + "倍。途中の位置で止まります。");
  });
  reset.addEventListener("click", setup);
  speed.addEventListener("change", () => {
    if (!animation) return;
    setRate();
    report((animation.playState === "running" ? "再生中" : "停止中") +
      "：速度" + rate() + "倍に変更。");
  });
  window.addEventListener("resize", setup);
  if (typeof reduced.addEventListener === "function") {
    reduced.addEventListener("change", setup);
  }
  setup();
})();
