const tiles=[...document.querySelectorAll('.tile')];let timeline=null;
function reset(){if(timeline)timeline.kill();gsap.set(tiles,{clearProps:'all'});document.querySelector('#status').textContent='READY: 元の配置';}
document.querySelector('#play').onclick=()=>{reset();if(document.querySelector('#reduce').checked||matchMedia('(prefers-reduced-motion: reduce)').matches){document.querySelector('#status').textContent='SUCCESS: 静止表示';return}timeline=gsap.timeline({onComplete:()=>document.querySelector('#status').textContent='SUCCESS: 再生終了'}).from(tiles,{opacity:0,y:45,stagger:.35,duration:.8});document.querySelector('#status').textContent='RUNNING: アニメーション';};
document.querySelector('#reset').onclick=reset;
