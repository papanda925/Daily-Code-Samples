import * as THREE from "https://cdn.jsdelivr.net/npm/three@0.180.0/build/three.module.js";
// 3Dの表示位置は架空のモデルで、ネットワークへ数値を送信しない。
const scene=new THREE.Scene(),camera=new THREE.PerspectiveCamera(60,640/350,.1,100);
camera.position.z=5;
const renderer=new THREE.WebGLRenderer({antialias:true});
renderer.setSize(640,350);renderer.setPixelRatio(Math.min(devicePixelRatio,2));
document.querySelector('#scene').append(renderer.domElement);
scene.add(new THREE.AmbientLight(0xffffff,1.4));
const light=new THREE.PointLight(0xffffff,40);light.position.set(2,3,4);scene.add(light);
const ball=new THREE.Mesh(new THREE.SphereGeometry(1.4,32,24),new THREE.MeshStandardMaterial({color:0x48bcb7,wireframe:true}));scene.add(ball);
let last=performance.now();
function frame(now){const dt=Math.min((now-last)/1000,.1);last=now;ball.rotation.y+=dt*Number(document.querySelector('#v').value);renderer.render(scene,camera);requestAnimationFrame(frame)}
requestAnimationFrame(frame);document.querySelector('#status').textContent='RUNNING: 3Dを表示';
window.addEventListener('pagehide',()=>{ball.geometry.dispose();ball.material.dispose();renderer.dispose()});
