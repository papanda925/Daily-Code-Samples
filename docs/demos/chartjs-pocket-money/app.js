const chart=new Chart(document.querySelector('#graph'),{type:'bar',data:{labels:['食費','交通費','教材'],datasets:[{label:'架空の円',data:[5000,3000,1800],backgroundColor:['#2c829b','#efab64','#76b98b']}]},options:{responsive:true,maintainAspectRatio:false,scales:{y:{beginAtZero:true}}}});
function update(){const n=Number(document.querySelector('#v').value);chart.data.datasets[0].data[1]=n;chart.update();document.querySelector('#status').textContent='SUCCESS: 合計 '+(6800+n)+'円（架空）';}
document.querySelector('#v').addEventListener('input',update);update();
