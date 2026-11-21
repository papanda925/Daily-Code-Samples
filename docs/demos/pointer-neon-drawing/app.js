const canvas=document.querySelector("#pad"),ctx=canvas.getContext("2d"),status=document.querySelector("#status");let last=null,hue=180;
function segment(x,y,from){ctx.lineCap="round";ctx.lineJoin="round";ctx.strokeStyle="hsl("+hue+" 100% 68%)";ctx.lineWidth=5;ctx.shadowColor=ctx.strokeStyle;ctx.shadowBlur=Number(document.querySelector("#glow").value);ctx.beginPath();ctx.moveTo(from.x,from.y);ctx.lineTo(x,y);ctx.stroke();ctx.shadowBlur=0;hue=(hue+7)%360;}
function point(e){const r=canvas.getBoundingClientRect();return{x:(e.clientX-r.left)*canvas.width/r.width,y:(e.clientY-r.top)*canvas.height/r.height};}
canvas.addEventListener("pointerdown",e=>{canvas.setPointerCapture(e.pointerId);last=point(e);status.textContent="描画中："+e.pointerType;});
canvas.addEventListener("pointermove",e=>{if(!last)return;const p=point(e);segment(p.x,p.y,last);last=p;});
for(const event of ["pointerup","pointercancel","lostpointercapture"]){canvas.addEventListener(event,()=>{last=null;status.textContent="線を描けました。";});}
document.querySelector("#clear").onclick=()=>{ctx.clearRect(0,0,canvas.width,canvas.height);status.textContent="消去しました。";};
document.querySelector("#sample").onclick=()=>{let prev={x:50,y:180};for(let i=1;i<=80;i++){const p={x:50+i*8.5,y:180+95*Math.sin(i/6)};segment(p.x,p.y,prev);prev=p;}status.textContent="サンプルの波線を描きました。";};