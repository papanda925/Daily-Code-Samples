# RegExp.escape()で検索文字列を安全に正規表現へ入れる
商品説明の「A+B」や「(税込)」を、正規表現の演算子ではなく文字そのものとして検索する体験教材です。初学者向け。文字列の入力だけで結果が変わります。

## ライブデモ
[ブラウザーで試す（Pages到達未確認）](https://papanda925.github.io/Daily-Code-Samples/demos/regexp-escape-search-lab/)

## ファイル
- [index.html](../../docs/demos/regexp-escape-search-lab/index.html) — 画面と入力欄
- [app.js](../../docs/demos/regexp-escape-search-lab/app.js) — 文字列検索と結果表示

## 動かし方
1. `index.html` と `app.js` を同じフォルダへ保存し、RegExp.escape()対応の新しいブラウザーでHTMLを開く（またはライブデモを開く）。
2. 「探したい文字列」に `A+B` を入力し「検索する」を押す。
3. 結果のエスケープ表現と一致件数を確認する。
4. `(税込)`、`AB`、`.`、空欄でも比較する。

## 期待結果
| 入力 | 一致件数 | 観察 |
|---|---:|---|
| A+B | 1 | プラス記号も文字として扱う |
| AB | 1 | A+Bとは別の部分 |
| (税込) | 1 | 括弧も文字として扱う |
| . | 0 | ドットを任意の1文字と解釈しない |
| 空欄 | 0 | 意図しない大量一致を防ぐ |

## 仕組み・変更実験
`RegExp.escape(keyword)`でユーザー入力を正規表現のリテラルパターンへ変換し、`new RegExp(expression, "g")`で全文から検索します。返り値のエスケープ表現は実装により見慣れない16進表記になることがあります。件数を観察してください。実験では`app.js`の`sample`を「A+B A+B AB」に変更し、A+Bが2件になることを確認します。

## 失敗時の切り分け
- 「未対応」: `RegExp.escape`がない環境。対応ブラウザーへ更新する。手製の簡易エスケープへ安易に置き換えない
- 画面が更新されない: HTMLとJSが同じ階層か、開発者ツールに404/構文エラーがないか確認
- 0件: 全角/半角、空白、大文字小文字、入力値を確認
- Pagesで404: GitHub Pages反映は未確認。ローカルの2ファイルで試す

## 安全・検証・出典
通信・権限要求・ストレージ保存・外部ライブラリはありません。架空の文字列のみを使用。入力をHTMLとして解釈せずtextContentで表示します。正規表現DoS対策の全般や認証・アクセス制御を提供する教材ではありません。
検証: ソース静的確認。実ブラウザーでの操作、Pages到達、CodeQLは未実施。
公式資料: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/RegExp/escape 、https://tc39.es/ecma262/#sec-regexp.escape

## ブログとの対応
記事ID: `20261124-02`。記事は最小コードと考え方、こちらは操作できる完全版です。
