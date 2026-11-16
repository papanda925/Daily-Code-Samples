import{usage,days,alertDays,maxUsage}from "./logic.mjs";
const status=document.getElementById("status"),slide=document.getElementById("threshold"),value=document.getElementById("value");
if(!window.echarts){status.textContent="EChartsの読み込みに失敗しました。vendorの配置を確認してください。";}
else{const chart=window.echarts.init(document.getElementById("visual"));
function update(){const n=Number(slide.value);value.value=n;value.textContent=n;
chart.setOption({animationDuration:250,tooltip:{trigger:"axis"},legend:{data:["架空CPU使用率","警告ライン"]},grid:{left:55,right:24,top:60,bottom:45},xAxis:{type:"category",data:days},yAxis:{type:"value",min:0,max:100,name:"%"},series:[{name:"架空CPU使用率",type:"line",data:usage,smooth:true},{name:"警告ライン",type:"line",data:usage.map(()=>n),lineStyle:{type:"dashed"},symbol:"none"}]});
status.textContent=`警告しきい値${n}%より高い日：${alertDays(n)}日／7日。最大CPU${maxUsage()}%。これは架空データです。`;}
slide.addEventListener("input",update);window.addEventListener("resize",()=>chart.resize());update();}