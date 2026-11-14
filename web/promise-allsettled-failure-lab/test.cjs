const assert = require("node:assert/strict");
const { run } = require("./app.cjs");
(async () => {
  const settled = await run("settled", true);
  assert.deepEqual(settled.results.map(x => x.status), ["fulfilled", "rejected", "fulfilled"]);
  assert.equal(settled.results[1].detail, "価格取得:FAILED");
  const all = await run("all", true);
  assert.equal(all.error, "価格取得:FAILED");
  const success = await run("settled", false);
  assert.equal(success.results.every(x => x.status === "fulfilled"), true);
  const allSuccess = await run("all", false);
  assert.equal(allSuccess.values.length, 3);
  console.log("PASS 4 assertions/scenarios");
})().catch(error => { console.error(error); process.exitCode = 1; });
