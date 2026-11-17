const assert=require("node:assert/strict");const {rows,selectById}=require("../../docs/demos/css-escape-selector-lab/app.js");
assert.equal(rows.length,4);
let seen="";const root={querySelector:s=>{seen=s;return s==="#ticket\\:01"?{textContent:"hit"}:null}};
assert.equal(selectById(root,"ticket:01",s=>s.replace(":","\\:")).textContent,"hit");
assert.equal(seen,"#ticket\\:01");
assert.equal(selectById(root,"missing",s=>s),null);
assert.throws(()=>selectById(root,"x".repeat(81),s=>s),RangeError);
assert.throws(()=>selectById(root,"x",null),TypeError);
console.log("5 assertions PASS (mock root; browser unverified)");