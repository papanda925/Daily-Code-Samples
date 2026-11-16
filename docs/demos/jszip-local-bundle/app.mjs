import {makeFiles,names,DEFAULT_NOTE} from "./logic.mjs";
const note=document.getElementById("note"),extra=document.getElementById("extra"),
 status=document.getElementById("status"),output=document.getElementById("contents"),
 download=document.getElementById("download"),build=document.getElementById("build");
let lastURL=null;
function revoke(){if(lastURL!==null){URL.revokeObjectURL(lastURL);lastURL=null;}}
function resetResult(){revoke();download.hidden=true;download.removeAttribute("href");output.textContent="";}
if(typeof window.JSZip!=="function"){status.textContent="JSZipを読み込めませんでした。vendor/jszip.min.jsを確認してください。";build.disabled=true;}
else{
 build.addEventListener("click",async ()=>{
  resetResult();build.disabled=true;status.textContent="ZIPを生成しています…";
  try{
   const files=makeFiles(note.value,extra.checked),archive=new window.JSZip();
   for(const file of files)archive.file(file.name,file.content);
   const blob=await archive.generateAsync({type:"blob",compression:"DEFLATE"});
   lastURL=URL.createObjectURL(blob);
   download.href=lastURL;download.download="daily-code-demo.zip";download.hidden=false;
   output.textContent=`中に入るファイル：${names(files)}`;
   status.textContent=`成功：${files.length}ファイル、${blob.size}バイトのZIPを生成しました。保存はまだ行っていません。`;
  }catch(error){status.textContent="生成できませんでした。200文字以内の入力とライブラリの読み込みを確認してください。";}
  finally{build.disabled=false;}
 });
 document.getElementById("reset").addEventListener("click",()=>{
  note.value=DEFAULT_NOTE;extra.checked=false;resetResult();status.textContent="初期の架空入力に戻しました。";
 });
 window.addEventListener("pagehide",revoke,{once:true});
}
