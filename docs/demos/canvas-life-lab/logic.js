"use strict";
(function (root) {
  function blank(size = 16) {
    if (!Number.isInteger(size) || size < 3 || size > 64) throw new RangeError("size 3..64");
    return Array.from({ length: size }, () => Array(size).fill(false));
  }
  function count(board) { return board.flat().filter(Boolean).length; }
  function neighbours(board, row, col) {
    let n = 0;
    for (let dr = -1; dr <= 1; dr++) for (let dc = -1; dc <= 1; dc++) {
      if (dr === 0 && dc === 0) continue;
      const r = row + dr, c = col + dc;
      if (r >= 0 && c >= 0 && r < board.length && c < board.length && board[r][c]) n++;
    }
    return n;
  }
  function next(board) {
    const size = board.length, out = blank(size);
    for (let r = 0; r < size; r++) for (let c = 0; c < size; c++) {
      const n = neighbours(board, r, c);
      out[r][c] = board[r][c] ? (n === 2 || n === 3) : n === 3;
    }
    return out;
  }
  function preset(name, size = 16) {
    const board = blank(size), mid = Math.floor(size / 2);
    const shapes = {
      blinker: [[0,-1],[0,0],[0,1]],
      block: [[0,0],[0,1],[1,0],[1,1]],
      glider: [[-2,-1],[-1,0],[0,-2],[0,-1],[0,0]],
      empty: []
    };
    if (!(name in shapes)) throw new RangeError("unknown preset");
    for (const [dr, dc] of shapes[name]) {
      const r = mid + dr, c = mid + dc;
      if (r >= 0 && c >= 0 && r < size && c < size) board[r][c] = true;
    }
    return board;
  }
  const api = { blank, count, neighbours, next, preset };
  root.LifeLogic = api;
  if (typeof module !== "undefined" && module.exports) module.exports = api;
})(typeof window !== "undefined" ? window : globalThis);
