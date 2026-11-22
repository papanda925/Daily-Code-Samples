# UTF-16不正サロゲートの検査ラボ

JavaScript文字列に単独サロゲートが含まれるかを判定し、U+FFFDへの置換を観察する初心者向け教材です。

## ライブデモ
[公開先（到達・ブラウザー動作未確認）](https://papanda925.github.io/Daily-Code-Samples/demos/string-wellformed-surrogate-lab/)

## 実ファイル
- [index.html](../../docs/demos/string-wellformed-surrogate-lab/index.html)
- [app.js](../../docs/demos/string-wellformed-surrogate-lab/app.js)

## 実行環境と手順
isWellFormedとtoWellFormedに対応したブラウザーが必要。ライブラリ、外部通信、ログイン、権限は不要です。
1. 公開デモを開くか、HTMLとJavaScriptを同じフォルダに保存しHTMLを開きます。
2. 「通常文字」「絵文字」「不正サロゲート」を順に押します。
3. 結果の元のUTF-16、判定、置換後を比べます。
4. テキスト欄をABCに変え「調べる」を押します。

## 期待結果と観察ポイント
- 通常文字「東京ABC」: 判定true、置換前後一致。
- 絵文字「A😀B」: UTF-16にD83D DE00が並び、判定true。
- 不正サロゲート: 元のUTF-16は0041 D800 0042、判定false、置換後は0041 FFFD 0042、置換後判定true。
- ABC: 0041 0042 0043、判定true。

## 仕組みと変更実験
JavaScript文字列はUTF-16コード単位を持ちます。上位サロゲートD800〜DBFFは下位サロゲートDC00〜DFFFと組である必要があります。isWellFormedは真偽値、toWellFormedは不正な単独サロゲートをU+FFFDに変えた新文字列を返します。元の文字列は変更しません。
app.jsの0xD800を0xDC00へ変更すると、単独の下位サロゲートでもfalseになります。正しいペアを試すならString.fromCharCode(0xD83D,0xDE00)へ変更します。

## 失敗時の切り分け
- API未対応: ブラウザー更新、MDN互換性表を確認。
- 結果が空: index.htmlとapp.jsの同一フォルダ配置とConsoleのエラーを確認。
- 見た目に差がない: 文字表示ではなくUTF-16の16進数を比較。
- 手入力で結果が変わる: 入力欄が不正なコード単位を置換することがあるため、専用ボタン直後の結果を参照。

## 安全・検証・出典
架空入力のみ。通信、保存、権限、外部依存なし。結果表示はtextContentでHTML解釈しません。静的レビューのみ実施。実ブラウザー、Pages到達、全ブラウザー互換性は未確認。
- https://tc39.es/ecma262/#sec-string.prototype.iswellformed
- https://tc39.es/ecma262/#sec-string.prototype.towellformed
- https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/isWellFormed

## 対応ブログ記事
記事ID: 20261123-10。ブログで用途・結果・実務上の制限を説明し、完全なコードは本教材に置きます。WordPress公開URLは未確定です。
