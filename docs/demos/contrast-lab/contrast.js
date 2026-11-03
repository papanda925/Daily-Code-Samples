/* WCAG 2.2 sRGB contrast, no network or storage. */
(function(root){
"use strict";
function parseHex(value){
  if(typeof value!=="string"||!/^#[0-9a-fA-F]{6}$/.test(value)) throw new TypeError("色は #RRGGBB の形式で入力してください");
  return [1,3,5].map(i=>parseInt(value.slice(i,i+2),16));
}
function channel(n){const s=n/255;return s<=0.04045?s/12.92:Math.pow((s+0.055)/1.055,2.4);}
function luminance(hex){const [r,g,b]=parseHex(hex).map(channel);return 0.2126*r+0.7152*g+0.0722*b;}
function ratio(foreground,background){const a=luminance(foreground),b=luminance(background);return (Math.max(a,b)+0.05)/(Math.min(a,b)+0.05);}
function evaluate(foreground,background){
  const value=ratio(foreground,background);
  return {ratio:value,aaNormal:value>=4.5,aaLarge:value>=3,aaaNormal:value>=7,aaaLarge:value>=4.5};
}
const api=Object.freeze({parseHex,luminance,ratio,evaluate});
if(typeof module==="object"&&module.exports)module.exports=api;
root.ContrastLab=api;
})(typeof globalThis!=="undefined"?globalThis:this);
