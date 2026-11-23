# Array.fromAsync()で非同期の値を配列に集める

非同期ジェネレーターから1件ずつ届く架空の作業名を、**すべて取得し終えてから配列として表示**する教材です。非同期の処理順と、画面に結果が現れるタイミングの違いを観察します。

## ライブデモ
[ブラウザーで操作する（GitHub Pagesへの反映・到達は未確認）](https://papanda925.github.io/Daily-Code-Samples/demos/array-fromasync-stream-lab/)

実装: [index.html](../../docs/demos/array-fromasync-stream-lab/index.html) / [app.js](../../docs/demos/array-fromasync-stream-lab/app.js)

## 前提と実行
- `Array.fromAsync`に対応したブラウザー（未対応の場合は明示的にエラー表示）。
- 外部ライブラリ、アカウント、権限、通信は不要。デモURLを開くか、上記2ファイルを同じフォルダーに保存して`index.html`を開く。
1. 初期入力「受付」「確認」「完了」のまま「収集する」を押す。
2. 収集中の表示が出た後、約300ms以降に3件のJSON配列が表示される。時間は目安で実測値ではない。
3. 待機時間を500msに変えて再実行する。約1.5秒以上の待機になる。
4. 入力を空欄にすると`[]`、21行以上の非空行にすると上限エラーを表示する。

## 期待結果
初期入力では`number`が1,2,3、`text`が受付・確認・完了、`length`が各2となります。途中の要素は画面に表示せず、完了後まとめて表示します。空欄行は除外されます。

## 仕組みと変更実験
`async function*`は`await`を含めた値の逐次生成を可能にします。`Array.fromAsync(asyncIterable, mapFn)`はそれを最後まで消費し、マッピングした配列をPromiseとして返します。`Array.from()`は非同期反復子を同じ方法では消費できません。
`delay`を100から500に変えると処理完了までの待ち時間が増えます。**Array.fromAsyncは逐次入力を自動的に並列化しません**。大量の値を配列へ保持するためメモリにも注意してください。

## うまくいかないとき
- `Array.fromAsync 非対応`: Consoleで`typeof Array.fromAsync`を確認し、対応する新しい環境で実行する。
- ボタンが反応しない: `index.html`と`app.js`を同じ場所に配置したか、Consoleの404/構文エラーを確認する。
- いつまでも収集中: 20行上限と待機時間を確認する。待機時間は1件あたりなので件数に比例する。
- Pagesが404: 公開反映は未確認。GitHubの2ファイルをローカルで開く。

## 安全・検証・出典
架空の作業名のみ使用。入力の送信・保存・HTML解釈はなく、表示には`textContent`を使います。JavaScriptの処理はNode.js v22.16.0で検証対象とし、ブラウザー実操作、Pages到達、CodeQLは未実施です。
- [MDN Array.fromAsync](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/fromAsync)
- [ECMAScript Array.fromAsync](https://tc39.es/ecma262/#sec-array.fromasync)

## ブログとの対応
記事ID: `20261124-09`。記事では最小例と業務判断を説明し、この教材に画面・入力制限・失敗時の処理を置きます。
