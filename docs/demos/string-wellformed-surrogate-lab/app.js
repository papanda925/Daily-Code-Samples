"use strict";
const output=document.querySelector("#result");
const presets={normal:"東京ABC",emoji:"A😀B",broken:"A"+String.fromCharCode(0xD800)+"B"};
// charCodeAtはUnicode文字数ではなくUTF-16コード単位を取得する。
function hexUnits(s){return Array.from({length:s.length},(_,i)=>s.charCodeAt(i).toString(16).toUpperCase().padStart(4,"0")).join(" ");}
function inspect(s){
  if(typeof "".isWellFormed!=="function"||typeof "".toWellFormed!=="function")throw new Error("API未対応。ブラウザーを更新してください。");
  const fixed=s.toWellFormed(); // 単独サロゲートをU+FFFDへ置換した新しい文字列
  return "元のUTF-16: "+hexUnits(s)+"\n判定: "+s.isWellFormed()+"\n置換後: "+hexUnits(fixed)+"\n置換後判定: "+fixed.isWellFormed();
}
function show(s){try{output.textContent=inspect(s);}catch(e){output.textContent=e.message;}}
document.querySelector("#buttons").addEventListener("click",e=>{
  const b=e.target.closest("button[data-key]");if(!b)return;
  const s=presets[b.dataset.key];if(s===undefined)return;
  document.querySelector("#value").value=s;show(s);
});
document.querySelector("#run").addEventListener("click",()=>show(document.querySelector("#value").value));
show(presets.normal);
