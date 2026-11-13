import test from "node:test";
import assert from "node:assert/strict";
import { SAMPLE_QUERY, inspectQuery, updateQuery } from "../../docs/demos/urlsearchparams-duplicate-keys-lab/query-utils.mjs";
test("getは先頭、getAllは重複値を全部返す",()=>{
  const d=inspectQuery(SAMPLE_QUERY,"tag");
  assert.equal(d.first,"red"); assert.deepEqual(d.all,["red","blue"]);
  assert.equal(d.entries.length,4);
});
test("appendは同名の値をすべて残す",()=>{
  assert.deepEqual(inspectQuery(updateQuery("tag=red&tag=blue","tag","green","append"),"tag").all,["red","blue","green"]);
});
test("setは同名の値をひとつだけにする",()=>{
  assert.deepEqual(inspectQuery(updateQuery("tag=red&tag=blue","tag","green","set"),"tag").all,["green"]);
});
test("存在しないキーはnull、存在する空値は空文字",()=>{
  assert.equal(inspectQuery("empty=","none").first,null);
  assert.equal(inspectQuery("empty=","empty").first,"");
});
test("プラスは空白として読みだす",()=>{
  assert.equal(inspectQuery("task=check+only","task").first,"check only");
});
test("HTMLのような値は文字列とエンコードで保持",()=>{
  const d=inspectQuery(updateQuery("a=1","a","<b>","append"),"a");
  assert.equal(d.all[1],"<b>"); assert.match(d.encoded,/%3Cb%3E/);
});
test("空のキーへの変更は拒否",()=>{
  assert.throws(()=>updateQuery("a=1"," ","x","set"));
});
test("変更したキー以外を保持",()=>{
  assert.deepEqual(inspectQuery(updateQuery("a=1&b=2&a=3","a","9","set"),"b").entries,[["a","9"],["b","2"]]);
});
