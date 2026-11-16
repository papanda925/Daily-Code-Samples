import{axis,surface,maximum}from "./logic.mjs";
const slider=document.getElementById("scale"),value=document.getElementById("value"),status=document.getElementById("status"),div=document.getElementById("visual");
if(!window.Plotly){status.textContent="Plotly.jsを読み込めません。配布ファイルとWebGL対応を確認してください。";}else{
function update(){const scale=Number(slider.value),z=surface(scale);value.textContent=scale;status.textContent=`格子点25個。最大高さ${maximum(z)}。架空データであり実測値ではありません。`;
window.Plotly.react(div,[{type:"surface",x:axis,y:axis,z,colorscale:"Viridis"}],{title:"架空の3D格子",autosize:true,margin:{l:0,r:0,t:45,b:0},scene:{xaxis:{title:"X"},yaxis:{title:"Y"},zaxis:{title:"高さ"}}},{responsive:true,displaylogo:false}).catch(()=>{status.textContent="3D表示に失敗しました。WebGL設定やブラウザーの対応を確認してください。";});}
slider.addEventListener("input",update);update();}