import {freshTickets,matches,summary} from "./logic.mjs";
const error=document.getElementById("error"),result=document.getElementById("summary");
if(typeof window.Tabulator!=="function"){
 error.hidden=false;error.textContent="表を表示するライブラリを読み込めませんでした。vendor/tabulator.min.js の配置を確認してください。";
 result.textContent="読込み失敗";
}else{
 const priority=document.getElementById("priority"),keyword=document.getElementById("keyword");
 let nextId=109;
 const table=new window.Tabulator("#table",{
   data:freshTickets(),index:"id",layout:"fitColumns",
   pagination:true,paginationSize:5,
   initialSort:[{column:"priority",dir:"asc"}],
   columns:[
     {title:"番号",field:"id",width:90,hozAlign:"right"},
     {title:"対象",field:"service",minWidth:110},
     {title:"内容",field:"summary",minWidth:205,widthGrow:2},
     {title:"重要度",field:"priority",width:105},
     {title:"状態（編集可）",field:"status",minWidth:135,editor:"list",editorParams:{values:["未対応","調査中","対応中","完了"]}},
     {title:"経過（分）",field:"minutes",width:115,hozAlign:"right"}
   ]
 });
 function refresh(){
   const active=table.getData("active"),s=summary(active);
   result.textContent=`表示 ${s.count}件／全 ${table.getData().length}件・表示対象の経過時間合計 ${s.minutes}分。編集内容は保存されません。`;
 }
 function filter(){
   table.setFilter(row=>matches(row,priority.value,keyword.value));
   refresh();
 }
 priority.addEventListener("change",filter);
 keyword.addEventListener("input",filter);
 table.on("dataFiltered",refresh);
 table.on("cellEdited",refresh);
 table.on("rowAdded",refresh);
 document.getElementById("add").addEventListener("click",()=>{
   table.addRow({id:nextId++,service:"Web",summary:"架空の追加チケット",priority:"中",status:"未対応",minutes:10},true);
   refresh();
 });
 document.getElementById("reset").addEventListener("click",()=>{
   nextId=109;priority.value="";keyword.value="";
   table.clearFilter();
   table.replaceData(freshTickets()).then(refresh);
 });
 table.on("tableBuilt",refresh);
}
