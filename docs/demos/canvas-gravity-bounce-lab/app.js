(function () {
"use strict";
// position in px, velocity in px/s, acceleration in px/s^2
function stepBall(b,g,e,dt,floor,r){
  if (b.y >= floor-r && b.vy === 0 && b.hits > 0) return {y:floor-r,vy:0,hits:b.hits};
  let vy=b.vy+g*dt, y=b.y+vy*dt, hits=b.hits;
  if(y>=floor-r && vy>0){y=floor-r;vy=-vy*e;hits++;
    if(Math.abs(vy)<25)vy=0;
  }
  return {y,vy,hits};
}
if(typeof module!=="undefined"&&module.exports)module.exports={stepBall};
if(typeof document==="undefined")return;
const c=document.getElementById("scene"),ctx=c.getContext("2d"),
gInput=document.getElementById("gravity"),eInput=document.getElementById("bounce"),
gOut=document.getElementById("gravity-value"),eOut=document.getElementById("bounce-value"),
play=document.getElementById("play"),pause=document.getElementById("pause"),
step=document.getElementById("step"),reset=document.getElementById("reset"),
status=document.getElementById("status"),metrics=document.getElementById("metrics");
const W=720,H=360,FLOOR=330,R=23,START=58;
const media=window.matchMedia?window.matchMedia("(prefers-reduced-motion: reduce)"):{matches:false};
let ball={y:START,vy:0,hits:0},raf=null,last=null,running=false;
const gravity=()=>Number(gInput.value);
const elasticity=()=>Number(eInput.value)/100;
const notice=s=>{status.textContent=s};
function draw(){
  if(!ctx)return;
  ctx.fillStyle="#edf8ff";ctx.fillRect(0,0,W,H);
  ctx.strokeStyle="#cee2ed";ctx.lineWidth=1;
  for(let x=0;x<W;x+=60){ctx.beginPath();ctx.moveTo(x,0);ctx.lineTo(x,FLOOR);ctx.stroke();}
  for(let y=30;y<FLOOR;y+=50){ctx.beginPath();ctx.moveTo(0,y);ctx.lineTo(W,y);ctx.stroke();}
  ctx.fillStyle="#195979";ctx.fillRect(0,FLOOR,W,H-FLOOR);
  ctx.beginPath();ctx.arc(W/2,ball.y,R,0,Math.PI*2);
  ctx.fillStyle="#3287c2";ctx.fill();
  ctx.beginPath();ctx.arc(W/2-8,ball.y-8,5,0,Math.PI*2);
  ctx.fillStyle="#fff";ctx.fill();
  metrics.textContent="床からの高さ：約"+Math.max(0,FLOOR-R-ball.y).toFixed(0)+"px／衝突回数："+ball.hits;
}
function stop(message){
  running=false;
  if(raf!==null){cancelAnimationFrame(raf);raf=null;}
  last=null;if(message)notice(message);
}
function advance(sec){
  const n=Math.max(1,Math.ceil(sec/(1/120))),dt=sec/n;
  for(let i=0;i<n;i++)ball=stepBall(ball,gravity(),elasticity(),dt,FLOOR,R);
  draw();
}
function tick(now){
  if(!running)return;
  if(last===null)last=now;
  advance(Math.max(0,Math.min((now-last)/1000,0.05)));
  last=now;raf=requestAnimationFrame(tick);
}
function preference(){
  if(media.matches){
    stop("動きを減らす設定が有効：0.2秒進めるボタンで静止画を観察できます。");
    play.disabled=true;pause.disabled=true;
  }else{
    play.disabled=false;pause.disabled=false;
    notice("準備完了。再生か0.2秒進めるを押してください。");
  }
}
function restart(){stop();ball={y:START,vy:0,hits:0};draw();preference();}
gInput.addEventListener("input",()=>{gOut.textContent=gravity()+" px/s²";notice("重力設定を変更。比較するときはリセットしてください。");});
eInput.addEventListener("input",()=>{eOut.textContent=elasticity().toFixed(2);notice("跳ね返り係数を変更。次の衝突から反映します。");});
play.addEventListener("click",()=>{
  if(running||media.matches)return;
  running=true;last=null;raf=requestAnimationFrame(tick);
  notice("再生中。ボールの高さと衝突回数を観察してください。");
});
pause.addEventListener("click",()=>stop("一時停止しました。"));
step.addEventListener("click",()=>{stop();advance(.2);notice("0.2秒進めました。高さと回数を比較してください。");});
reset.addEventListener("click",restart);
document.addEventListener("visibilitychange",()=>{if(document.hidden)stop("画面が非表示になったため停止しました。");});
if(typeof media.addEventListener==="function")media.addEventListener("change",preference);
if(!ctx){notice("Canvas 2Dが利用できません。");[play,pause,step].forEach(b=>b.disabled=true);return;}
gOut.textContent=gravity()+" px/s²";eOut.textContent=elasticity().toFixed(2);
restart();
})();