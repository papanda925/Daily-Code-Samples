/* DOM only; textContent prevents HTML interpretation. */
(()=>{
"use strict";
const source=document.getElementById("names"),out=document.getElementById("result"),status=document.getElementById("status");
const numeric=document.getElementById("numeric"),sensitivity=document.getElementById("sensitivity");
function render(){
 try{
 const names=source.value.split(/\r?\n/).map(x=>x.trim()).filter(Boolean);
 const sorted=globalThis.SortLab.sortNames(names,{numeric:numeric.checked,sensitivity:sensitivity.value});
 out.textContent=sorted.join("\n");status.textContent="結果: "+sorted.length+"件（入力順を変更せずコピーして比較）";
 }catch(e){out.textContent="";status.textContent="入力エラー: "+e.message;}
}
document.getElementById("run").addEventListener("click",render);
document.getElementById("reset").addEventListener("click",()=>{source.value="資料10\n資料2\n資料1\n資料20";numeric.checked=true;sensitivity.value="base";render();});
render();
})();
