// structuredCloneの通常コピーとtransferを、架空のバイト列だけで比較します。
const $ = id => document.getElementById(id);
const output = $("output");
const status = $("status");
const values = $("values");
const bytes = $("bytes");
const action = $("action");
const history = [];
function log(message) {
  history.unshift(message);
  output.textContent = history.slice(0, 12).join("\n");
}
function makeBuffer() {
  const count = Number(bytes.value);
  if (!Number.isInteger(count) || count < 1 || count > 32) {
    throw new RangeError("バイト数は1〜32を選んでください");
  }
  const buffer = new ArrayBuffer(count);
  const view = new Uint8Array(buffer);
  view.forEach((_, index) => { view[index] = index + 1; });
  return buffer;
}
function run() {
  try {
    const original = makeBuffer();
    const before = Array.from(new Uint8Array(original));
    const mode = action.value;
    // transferを指定すると元のArrayBufferはdetachedとなり、byteLengthが0になる。
    const cloned = mode === "transfer"
      ? structuredClone(original, { transfer: [original] })
      : structuredClone(original);
    const after = Array.from(new Uint8Array(cloned));
    values.textContent = "コピー前: " + JSON.stringify(before)
      + " / コピー後: " + JSON.stringify(after);
    log("方式=" + mode + " / 元byteLength=" + original.byteLength
      + " / 複製先byteLength=" + cloned.byteLength);
    // 複製先を変更して、通常コピー時の独立性も観察する。
    new Uint8Array(cloned)[0] = 99;
    log("複製先の先頭を99へ変更。元の読み取り: "
      + (original.byteLength ? new Uint8Array(original)[0] : "不可(detached)")
      + " / 複製先=" + new Uint8Array(cloned)[0]);
    status.textContent = "完了。ログの元byteLengthを比較してください。";
  } catch (error) {
    status.textContent = "実行失敗: " + error.message;
    log("失敗: " + error.name + " / " + error.message);
  }
}
$("run").addEventListener("click", run);
$("reset").addEventListener("click", () => {
  history.length = 0; output.textContent = ""; values.textContent = "";
  bytes.value = "8"; action.value = "copy"; status.textContent = "初期化しました";
});
if (typeof structuredClone !== "function") {
  $("run").disabled = true;
  status.textContent = "このブラウザーはstructuredCloneに対応していません。";
}
