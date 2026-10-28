let synth=null;
// ユーザーが再生を押してからオーディオを開始する。
document.querySelector('#play').onclick=async()=>{try{await Tone.start();if(!synth)synth=new Tone.Synth({volume:-18}).toDestination();const beat=60/Number(document.querySelector('#v').value);['C4','E4','G4','C5'].forEach((n,i)=>synth.triggerAttackRelease(n,'8n',Tone.now()+0.05+i*beat));document.querySelector('#status').textContent='SUCCESS: 4音を予約した';}catch(e){document.querySelector('#status').textContent='FAILED: '+e.name}};
document.querySelector('#stop').onclick=()=>{if(synth){synth.dispose();synth=null}document.querySelector('#status').textContent='STOPPED: 音源を解放'};
window.addEventListener('pagehide',()=>{if(synth)synth.dispose()});
