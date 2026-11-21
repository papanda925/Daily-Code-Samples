# Array.toSorted()とsort()：元データを守る並べ替え
数値の一覧を昇順にするとき、`sort()` は元配列を変更します。`toSorted()` は新しい配列を返すため、入力データを残したまま表示順だけ変更できます。初心者向けに架空の数値で比較します。

## ライブデモ
[ブラウザーで比較する](https://papanda925.github.io/Daily-Code-Samples/demos/array-tosorted-nonmutating-lab/)（GitHub Pagesへの反映・実ブラウザーでの到達は未確認）。
実装: [index.html](../../docs/demos/array-tosorted-nonmutating-lab/index.html) / [app.js](../../docs/demos/array-tosorted-nonmutating-lab/app.js)

## 環境と実行手順
`toSorted()` 対応の現代的ブラウザー、JavaScript有効。ライブラリ、CDN、ログイン、APIキー、特別な権限は不要です。
1. ライブデモを開き、入力 `10,2,7,2` を確認します。
2. 「比較する」を押します。
3. `original`、`sortedCopy`、`sortedInPlace`、`unchanged` を見比べます。
4. `10,2,7,2` を `3,20,1` に変えて再実行します。
ローカル実行ならリポジトリのルートで `python3 -m http.server 8000` を起動し、`http://127.0.0.1:8000/docs/demos/array-tosorted-nonmutating-lab/` を開きます。終了はCtrl+Cです。

## 期待結果と観察
| 入力 | original | sortedCopy | unchanged |
|---|---|---|---|
| `10,2,7,2` | `[10,2,7,2]` | `[2,2,7,10]` | `true` |
| `3,20,1` | `[3,20,1]` | `[1,3,20]` | `true` |
| `3,,1` | エラー | エラー | 出力なし |

`sortedInPlace` も数値の昇順ですが、比較のために `[...values]` で作った別配列へ `sort()` を適用しています。入力自体を変更していません。

## 仕組みと変更実験
`sort()` は破壊的変更（元の配列を書き換える操作）、`toSorted()` は非破壊的操作です。`(a,b)=>a-b` は数値の昇順比較です。これを `(a,b)=>b-a` に変えると降順になります。比較関数を省くと文字列として比較され、`10` と `2` の順が直感と異なる場合があります。`toSorted()` は**浅いコピー**なので、要素がオブジェクトならその内部オブジェクトは共有されます。深いコピーではありません。

## うまくいかないとき
- `toSorted is not a function`：対応していないブラウザーです。ブラウザーを更新するか、`[...values].sort((a,b)=>a-b)` を代替にします。
- ボタンを押しても変化しない：JavaScriptが有効か、開発者ツールConsoleにエラーがないか、`app.js` が読み込まれたか確認します。
- `3,,1` や文字が混じる：空欄や不正値は入力エラーにします。
- `10,2` が `10,2` のままになる：ボタン操作と比較関数の有無を確認します。

## 安全・検証・出典
架空数値のみをブラウザー内で扱い、通信、保存、権限要求、個人情報の収集はありません。外部ライブラリなし。コードの静的点検と期待値の論理確認を実施。実ブラウザー実行、Pages公開反映、各OSでの動作は未確認です。
- [MDN: Array.prototype.toSorted()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/toSorted)
- [MDN: Array.prototype.sort()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/sort)
- [ECMAScript: Array.prototype.toSorted](https://tc39.es/ecma262/#sec-array.prototype.tosorted)

## ブログとの対応
記事ID: `20261122-09`（WordPress公開URLは公開後のGET確認まで未確定）。記事は最小例と判断方法を説明し、この教材は入力検証と比較表示を備えた完全版です。
