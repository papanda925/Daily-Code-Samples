// Node.js 18+。外部通信・ファイル操作なし。
const delay = (ms, value, fail = false) => new Promise((resolve, reject) => {
  setTimeout(() => fail ? reject(new Error(value)) : resolve(value), ms);
});
async function run(mode = "settled", secondFails = true) {
  const tasks = [
    delay(15, "在庫確認:OK"),
    delay(5, "価格取得:FAILED", secondFails),
    delay(10, "配送確認:OK")
  ];
  if (mode === "all") {
    try {
      const values = await Promise.all(tasks);
      return { mode, values };
    } catch (error) {
      return { mode, error: error.message };
    }
  }
  const results = await Promise.allSettled(tasks);
  return {
    mode,
    results: results.map((item, index) => ({
      task: index + 1,
      status: item.status,
      detail: item.status === "fulfilled" ? item.value : item.reason.message
    }))
  };
}
if (require.main === module) {
  const mode = process.argv[2] === "all" ? "all" : "settled";
  const secondFails = process.argv[3] !== "success";
  run(mode, secondFails).then(result => console.log(JSON.stringify(result, null, 2)));
}
module.exports = { run, delay };
