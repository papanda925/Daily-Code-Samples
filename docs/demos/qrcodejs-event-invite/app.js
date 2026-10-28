const qr=new QRCode(document.querySelector('#qrcode'),{text:'初期値',width:180,height:180});
function update(){const name=document.querySelector('#event').value.trim();if(!name){document.querySelector('#status').textContent='FAILED: 空欄です';return}const payload='架空のイベント：'+name+' / 日時未定';qr.clear();qr.makeCode(payload);document.querySelector('#plain').textContent='格納文字列: '+payload;document.querySelector('#status').textContent='SUCCESS: QRを更新';}
document.querySelector('#make').onclick=update;update();
