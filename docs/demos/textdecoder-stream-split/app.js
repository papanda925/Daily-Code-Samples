// UTF-8の途中でチャンクが切れたときの復号を比較する。外部通信なし。
const source = "東京🍣の受付番号";
const bytes = new TextEncoder().encode(source);
const input = document.querySelector("#split");
const result = document.querySelector("#result");
const raw = document.querySelector("#raw");
const expected = document.querySelector("#expected");
expected.textContent = source;
raw.textContent = [...bytes].map(x => x.toString(16).padStart(2, "0")).join(" ");

function run() {
  const cut = Number(input.value);
  if (!Number.isInteger(cut) || cut < 1 || cut >= bytes.length) {
    result.textContent = "分割位置は1から" + (bytes.length - 1) + "の整数にしてください。";
    return;
  }
  const parts = [bytes.slice(0, cut), bytes.slice(cut)];
  // チャンクごとに独立して復号すると、不完全なUTF-8は置換文字になる。
  const broken = parts.map(p => new TextDecoder("utf-8").decode(p)).join("");
  // 同じTextDecoderを使い、stream:trueで未完成のバイト列を保持する。
  const decoder = new TextDecoder("utf-8");
  const safe = parts.map(p => decoder.decode(p, {stream:true})).join("") + decoder.decode();
  const byteInfo = parts.map(p => p.length).join(" + ");
  result.textContent =
    "分割: " + byteInfo + "バイト\n" +
    "個別decode: " + broken + "\n" +
    "stream:true: " + safe + "\n" +
    "元文字列と一致: " + (safe === source ? "YES" : "NO");
}
document.querySelector("#run").addEventListener("click", run);
input.max = String(bytes.length - 1);
input.value = "2";
run();
