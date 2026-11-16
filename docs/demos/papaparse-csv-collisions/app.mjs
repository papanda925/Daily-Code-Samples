import{duplicates,safeCount}from "./logic.mjs";
const input=document.getElementById("csv"),status=document.getElementById("status"),out=document.getElementById("visual");
function parse(){if(!window.Papa){status.textContent="Papa Parseを読み込めません。vendorの配置を確認してください。";return;}
const data=window.Papa.parse(input.value,{header:false,skipEmptyLines:true});const rows=data.data;
const headers=rows[0]||[];const duplicate=duplicates(headers);
status.textContent=`ヘッダー${headers.length}列、データ${Math.max(0,safeCount(rows)-1)}行。重複見出し：${duplicate.length?duplicate.join("、"):"なし"}。解析エラー${data.errors.length}件。`;
out.textContent="解析後の配列（表示のみ）：\n"+JSON.stringify(rows,null,2);
}document.getElementById("parse").addEventListener("click",parse);parse();