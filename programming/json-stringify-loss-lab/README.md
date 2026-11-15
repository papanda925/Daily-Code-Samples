# JSON.stringify loss lab
Node.js 20以上、追加依存なし。実データを使わず架空の DUMMY-001 を扱います。
## 実行
```sh
node app.mjs
node --test test.mjs
```
初回の出力は JSON 文字列と判定オブジェクトです。テストは Node 標準の assert を使います。
## 何を観察するか
オブジェクトの undefined プロパティは省略、配列内 undefined は null、NaN/Infinity は null、Date は ISO 8601 文字列になります。元の型が復元されるわけではありません。
## 1条件変更
`score: NaN` を `score: 0` にすると、JSON の score は null でなく 0 になります。
## 失敗・境界条件
BigInt は通常 TypeError、循環参照も TypeError。JSON.stringify の戻り値が undefined の場合、JSON.parse に渡さないでください。データ欠落を避けるには入力のスキーマ検証と、日付などの明示的な変換規則が必要です。
## 検証
この教材のテストは Node.js での実行を想定します。実行済みの環境・結果は記事の制作記録で区別します。ブラウザ、Windows、WordPressでの動作は未確認です。
## 一次資料
https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/JSON/stringify
https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/JSON/parse
