// フォーム送信APIの違いを観察する。ネットワーク送信はしない。
const form=document.querySelector("#demo");
const log=document.querySelector("#log");
const nameInput=document.querySelector("#person");
const note=document.querySelector("#note");
let count=0;
function write(message){log.textContent=String(++count).padStart(2,"0")+" "+message+"\n"+log.textContent;}
form.addEventListener("submit",event=>{
  event.preventDefault(); // 実際のページ遷移・通信を防ぐ
  const data=new FormData(form,event.submitter);
  write("submitイベント発火 / submitter="+(event.submitter?.value??"なし")+" / name="+JSON.stringify(data.get("person"))+" / action="+JSON.stringify(data.get("action")));
});
form.addEventListener("invalid",event=>write("invalidイベント: "+event.target.name),true);
document.querySelector("#request").addEventListener("click",()=>{
  try{form.requestSubmit(document.querySelector("#send"));write("requestSubmit呼び出し完了");}
  catch(error){write("requestSubmit失敗: "+error.message);}
});
document.querySelector("#native").addEventListener("click",()=>{
  // submit() は検証とsubmitイベントを迂回する。実送信を防ぐため実行しない。
  write("form.submit()は実行しません（検証とsubmitイベントを迂回し、ページ遷移し得るため）");
});
document.querySelector("#reset").addEventListener("click",()=>{form.reset();log.textContent="";count=0;note.textContent="入力を初期化しました";});
document.querySelector("#request").addEventListener("click",()=>{note.textContent=nameInput.validity.valueMissing?"必須入力が空ならinvalid、submitは発火しません":"入力が有効ならsubmitイベントでpreventDefaultします";});
