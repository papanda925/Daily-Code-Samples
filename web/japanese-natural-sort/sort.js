/* Offline Japanese file-name sort lab: no network, no storage. */
(function(root){
"use strict";
function sortNames(values, {locale="ja-JP", numeric=true, sensitivity="base"}={}){
  if(!Array.isArray(values)||values.length>100) throw new TypeError("配列は100件以内");
  if(values.some(v=>typeof v!=="string"||v.length>120)) throw new TypeError("各項目は120文字以内の文字列");
  const allowed=["ja-JP","en-US"]; if(!allowed.includes(locale)) throw new RangeError("localeが不正");
  if(typeof numeric!=="boolean"||!["base","variant"].includes(sensitivity)) throw new TypeError("optionが不正");
  const collator=new Intl.Collator(locale,{numeric,sensitivity,usage:"sort"});
  return values.map((name,index)=>({name,index})).sort((a,b)=>collator.compare(a.name,b.name)||a.index-b.index).map(x=>x.name);
}
root.SortLab={sortNames};
if(typeof module!=="undefined"&&module.exports) module.exports={sortNames};
})(typeof globalThis!=="undefined"?globalThis:this);
