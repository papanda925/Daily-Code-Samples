import { SAMPLE_QUERY, inspectQuery, updateQuery } from "./query-utils.mjs";
// 入力したパラメーターをサーバーへ送信しない。画面上の文字列だけを更新する。
const el = id => document.getElementById(id);
const query=el("query"), key=el("key"), value=el("value"), summary=el("summary"), encoded=el("encoded"), rows=el("rows");
query.value=SAMPLE_QUERY; key.value="tag"; value.value="green";
function render() {
  if (query.value.length > 2000) {
    summary.textContent="クエリーは2000文字以内にしてください";
    rows.replaceChildren();
    encoded.textContent="";
    return;
  }
  if (!key.value.trim()) {
    summary.textContent="検索キーを入力してください";
    rows.replaceChildren();
    encoded.textContent="";
    return;
  }
  const data=inspectQuery(query.value,key.value);
  summary.textContent=`get("${key.value}") → ${JSON.stringify(data.first)} ／ getAll → ${JSON.stringify(data.all)} ／ 件数 ${data.all.length}`;
  encoded.textContent=data.encoded;
  rows.replaceChildren();
  data.entries.slice(0,80).forEach(([name,entryValue],index)=>{
    const tr=document.createElement("tr");
    [String(index+1),name,entryValue].forEach(s=>{
      const td=document.createElement("td");
      td.textContent=s; // HTMLとして挿入しない
      tr.append(td);
    });
    rows.append(tr);
  });
  if (data.entries.length>80) {
    const tr=document.createElement("tr"), td=document.createElement("td");
    td.colSpan=3;
    td.textContent="表示上限は80件です。残りは省略しました。";
    tr.append(td); rows.append(tr);
  }
}
function change(mode) {
  try { query.value=updateQuery(query.value,key.value,value.value,mode); render(); }
  catch (err) { summary.textContent=err.message; }
}
el("parse").addEventListener("click",render);
el("append").addEventListener("click",()=>change("append"));
el("set").addEventListener("click",()=>change("set"));
el("reset").addEventListener("click",()=>{query.value=SAMPLE_QUERY;key.value="tag";value.value="green";render();});
render();
