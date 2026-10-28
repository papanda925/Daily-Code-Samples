const fish=[{x:50,y:80,v:1},{x:220,y:160,v:-1.5}];
// p5.jsがsetupを一度、drawを継続的に呼び出す。
function setup(){createCanvas(640,350).parent('scene')}
function draw(){background(19,62,98);fish.forEach(f=>{f.x+=f.v;if(f.x>670)f.x=-30;if(f.x<-30)f.x=670;push();translate(f.x,f.y);if(f.v<0)scale(-1,1);fill(248,188,93);ellipse(0,0,53,25);triangle(-20,0,-40,-20,-40,20);fill(12,41,65);circle(18,-4,5);pop()});document.querySelector('#status').textContent='RUNNING: 魚 '+fish.length+'匹';}
document.querySelector('#add').onclick=()=>{if(fish.length<30)fish.push({x:15,y:35+fish.length*8,v:fish.length%2?1.2:-1.4})};
document.querySelector('#reset').onclick=()=>fish.splice(0);
