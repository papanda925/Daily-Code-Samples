# JavaScriptの配列をページ単位で取り出す

`node pagination.mjs` を実行すると、5件のデータを2件ずつ取り出した結果が4行に出ます。期待値は `[A, B]`、`[C, D]`、`[E]`、空配列です。

表示件数を3にして、最後のページの件数を比較できます。ページ番号と表示件数は正の整数です。0を渡すと入力エラーになり、存在しないページは空配列になります。

[配列のslice](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/slice) は終了インデックスを含みません。この教材はNode.js用です。
