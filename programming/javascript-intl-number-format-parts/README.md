# 金額表示を部品に分ける — Intl.NumberFormat.formatToParts()

通貨記号だけ色を変えたい場合や、金額の小数部分を小さく表示したい場合に、表示文字列を自力で切り分けず、部品の種類と順序を調べる教材です。架空の金額1234.5を米ドル・ユーロ・日本円として別々に表示します。為替換算ではありません。

## まず試す

Node.js 22系を使用します。外部パッケージ・ネットワーク接続は不要です。

1. [parts.mjs](parts.mjs)、[demo.mjs](demo.mjs)、[parts.test.mjs](parts.test.mjs) を同じフォルダに保存します。
2. ターミナルでそのフォルダを開き、`node demo.mjs` を実行します。
3. `node --test parts.test.mjs` を実行します。

Node.js v22.16.0での実測結果：

| 設定 | 表示 |
|---|---|
| en-US / USD | $1,234.50 |
| de-DE / EUR | 1.234,50 € |
| ja-JP / JPY | ￥1,235 |

ユーロの直前には通常の空白と異なる改行しない空白が入っています。ロケールデータにより表示の細部は異なることがあります。各行の次には部品の種類と値が表示されます。

## 仕組みと変更実験

`currencyParts` は有限の数値だけを受け付け、通貨表示の部品を返します。`joinParts` は値を順番に連結します。整数部分は桁区切りで複数に分かれるため、最初の integer だけを選ばないでください。通貨記号の位置や空白を固定せず、全ての部品を順番に扱います。

`demo.mjs` の1234.5を-1234.5に変えると負号の部品が加わります。小数表示を変えるには、`parts.mjs` のオプションに `minimumFractionDigits: 2, maximumFractionDigits: 2` を加えて比較します。JPYの既定の小数桁を確認するテストは、この変更後は元に戻すまで失敗します。元の数値は変わりません。

## うまくいかないとき

| 現象 | 確認 |
|---|---|
| node がない | Node.jsを導入し、node --version を確認 |
| ファイルが見つからない | 三つの .mjs ファイルと実行フォルダを確認 |
| TypeError | 入力は有限の number 型か確認。数値文字列はこの関数で許可していない |
| RangeError | ロケールと通貨コードの形式を確認 |
| 期待値と違う | ロケール、通貨、小数桁オプション、実行環境を確認 |

## 安全・検証

架空の金額のみで実行し、通信・保存・外部依存はありません。金額計算や換算ではなく表示用の処理です。会計処理では別途端数処理や正確な数値の持ち方を設計してください。HTMLに適用する場合は文字列をHTMLとして直接挿入せず、テキストとして表示します。

2026-11-27 JST、Node.js v22.16.0で3ファイルの構文検査、デモ実行、7テスト（3ロケールの復元、負号、日本円の既定小数桁、型と非有限数の拒否、通貨コード形式）に成功。ブラウザー、CodeQL、実サービスは未検証です。

- [MDN: formatToParts()](https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Global_Objects/Intl/NumberFormat/formatToParts)
- [ECMA-402: NumberFormat.prototype.formatToParts](https://tc39.es/ecma402/#sec-intl.numberformat.prototype.formattoparts)

関連ブログ記事ID：20261127-27-02（公開URL未確定）。ブログでは最小例と表示設計を、ここでは再利用可能な関数とテストを扱います。
