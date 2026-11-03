/* UI layer: textContent only; all inputs are local. */
(()=>{"use strict";
const api=globalThis.ContrastLab;
const fg=document.getElementById("fg"),bg=document.getElementById("bg");
const preview=document.getElementById("preview"),ratio=document.getElementById("ratio");
const normal=document.getElementById("normal"),large=document.getElementById("large"),aaa=document.getElementById("aaa");
const status=document.getElementById("status");
function update(){
  if(!api){status.textContent="計算プログラムを読み込めませんでした。";return;}
  try{
    const result=api.evaluate(fg.value,bg.value);
    preview.style.color=fg.value;preview.style.backgroundColor=bg.value;
    ratio.textContent=result.ratio.toFixed(2)+":1（判定は丸め前の数値）";
    normal.textContent=result.aaNormal?"AA通常文字：適合":"AA通常文字：未達";
    large.textContent=result.aaLarge?"AA大きな文字：適合":"AA大きな文字：未達";
    aaa.textContent=result.aaaNormal?"AAA通常文字：適合":"AAA通常文字：未達";
    status.textContent="文字色 "+fg.value+" ／ 背景色 "+bg.value+"。すべて端末内で計算しています。";
  }catch(error){status.textContent="入力エラー："+error.message;}
}
document.querySelectorAll("[data-fg][data-bg]").forEach(button=>button.addEventListener("click",()=>{
  fg.value=button.dataset.fg;bg.value=button.dataset.bg;update();
}));
fg.addEventListener("input",update);bg.addEventListener("input",update);
document.getElementById("swap").addEventListener("click",()=>{const old=fg.value;fg.value=bg.value;bg.value=old;update();});
update();
})();
