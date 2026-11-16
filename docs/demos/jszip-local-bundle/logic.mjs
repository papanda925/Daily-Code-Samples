// この教材は架空テキストしか扱いません。ブラウザー上の既存ファイルは読みません。
export const MAX_CHARS=200;
export const DEFAULT_NOTE="架空の作業メモ：確認手順を先にまとめる。";
export function makeFiles(note,includeChecklist=false){
 if(typeof note!=="string")throw new TypeError("入力は文字列で指定");
 if([...note].length>MAX_CHARS)throw new RangeError("メモは200文字以内");
 const files=[
  {name:"README.txt",content:"JSZipの静的実験です。入力はブラウザー外へ送信しません。\n"},
  {name:"memo.txt",content:note+"\n"}
 ];
 if(includeChecklist===true)files.push({name:"checklist.txt",content:"1. 架空データで確認\n2. 結果を観察\n3. 本番データを使わない\n"});
 return files;
}
export function names(files){return files.map(file=>file.name).join(", ");}
