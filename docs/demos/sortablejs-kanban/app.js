const todo=document.querySelector('#todo'),done=document.querySelector('#done');
const update=()=>document.querySelector('#status').textContent='SUCCESS: 未着手 '+todo.children.length+' / 完了 '+done.children.length;
// 同じgroupを指定すると別の列へ移動できる。
for(const el of [todo,done])Sortable.create(el,{group:'tasks',animation:160,onEnd:update});
document.querySelector('#move').onclick=()=>{if(todo.firstElementChild)done.append(todo.firstElementChild);update()};update();
