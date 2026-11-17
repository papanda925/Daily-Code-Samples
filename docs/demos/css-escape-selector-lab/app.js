"use strict";
const rows = [{id:"ticket:01",name:"通常チケット"},{id:"ticket.02",name:"点付きID"},{id:"123-start",name:"数字始まり"},{id:"a b",name:"空白付き"}];
function selectById(root, id, escapeFn) {
  if(typeof id!=="string" || id.length>80) throw new RangeError("IDは80文字以内");
  if(typeof escapeFn!=="function") throw new TypeError("CSS.escapeが使えません");
  return root.querySelector("#"+escapeFn(id));
}
if(typeof module!=="undefined") module.exports={rows,selectById};
if(typeof document!=="undefined"){
  const list=document.querySelector("#tickets"), status=document.querySelector("#status");
  for(const item of rows){const el=document.createElement("li");el.id=item.id;el.textContent=item.name+" / "+item.id;list.append(el)}
  document.querySelector("#run").addEventListener("click",()=>{
    const id=document.querySelector("#target").value;
    try{
      const hit=selectById(list,id,globalThis.CSS?.escape);
      status.textContent=hit?"見つかった: "+hit.textContent:"一致なし（入力を確認）";
    }catch(error){status.textContent="検索できません: "+error.message}
  });
  document.querySelector("#reset").addEventListener("click",()=>{document.querySelector("#target").value="ticket:01";status.textContent="未検索"});
}