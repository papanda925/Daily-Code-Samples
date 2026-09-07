console.log("=== 1. 同期処理 ===");
console.log("A: 開始");
console.log("B: その場で実行");
console.log("C: 終了");

console.log("\n=== 2. Callback ===");

function laterWithCallback(callback) {
  // setTimeoutはブラウザやNode.jsが提供するタイマーAPIです。
  // 200ms後に、渡されたcallbackへ結果を返します。
  setTimeout(() => {
    callback("Callbackで受け取った結果");
  }, 200);
}

console.log("D: 呼び出し前");

laterWithCallback((result) => {
  console.log("F:", result);
});

console.log("E: Callbackを待たず次へ");

console.log("\n=== 3. Promise ===");

function laterWithPromise() {
  // Promiseは「将来返ってくる結果」を表します。
  // Promise自体が新しいthreadを作る、という意味ではありません。
  return new Promise((resolve) => {
    setTimeout(() => {
      resolve("Promiseで受け取った結果");
    }, 300);
  });
}

console.log("G: Promise作成前");

laterWithPromise().then((result) => {
  console.log("I:", result);
});

console.log("H: Promise完了を待たず次へ");

console.log("\n=== 4. async / await ===");

async function runWithAwait() {
  console.log("J: await前");

  // awaitを使うと、Promiseの結果を受け取る処理を
  // 上から順に読みやすい形で書けます。
  const result = await laterWithPromise();

  console.log("K:", result);
}

runWithAwait();

console.log("L: async関数の完了を同期的には待たない");
