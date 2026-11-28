'use strict';
const byId = id => document.getElementById(id);
const width = byId('width');
const count = byId('count');
function render() {
  const w = Number(width.value);
  const n = Number(count.value);
  byId('widthValue').textContent = String(w);
  byId('countValue').textContent = String(n);
  for (const mode of ['fill', 'fit']) {
    const grid = byId(mode);
    // 両方の条件を同じにする。列の幅や個数はCSS自身に計算させる。
    grid.style.width = `${w}px`;
    const cards = Array.from({length: n}, (_, i) => {
      const card = document.createElement('div');
      card.className = 'card';
      card.textContent = `カード ${i + 1}`;
      return card;
    });
    grid.replaceChildren(...cards);
    // 計算式の推定ではなく、実際のブラウザーの解決済みトラック幅を読む。
    byId(`${mode}Result`).textContent = `列幅: ${getComputedStyle(grid).gridTemplateColumns}`;
  }
}
width.addEventListener('input', render);
count.addEventListener('input', render);
render();
