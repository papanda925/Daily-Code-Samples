# 金額表示の分解ラボ

通貨記号や小数部分を個別に装飾する。金額、ロケール、通貨を変えて、表示部品の順序を観察する教材である。為替換算ではない。

## ライブデモ

[金額表示の分解ラボ](https://papanda925.github.io/Daily-Code-Samples/demos/javascript-intl-number-format-parts/)（Pages反映・公開URL到達は未確認）

[実装：index.html](../../docs/demos/javascript-intl-number-format-parts/index.html) ／ [Node.js版と7テスト](../../programming/javascript-intl-number-format-parts/README.md)

## まず試す

1. デモを開く。初期値は1234.5、en-US、USD。
2. ロケールをde-DE、通貨をEURに変更する。通貨記号が末尾へ移る。
3. 「正負を反転」を押す。負号のカードと赤い負号が現れる。
4. 「初期値に戻す」で元に戻す。

| 条件 | 表示の期待例 | 観察 |
|---|---|---|
| en-US / USD | $1,234.50 | 通貨記号が先頭 |
| de-DE / EUR | 1.234,50 € | 通貨記号が末尾、空白部品 |
| ja-JP / JPY | ￥1,235 | 既定では小数なし |
| 空欄 | エラー表示 | 0として扱わない |

対応環境はIntl.NumberFormat.formatToParts()と現行DOM APIを利用できるブラウザー。外部ライブラリ、アカウント、追加権限は不要。Pagesの取得以外に外部通信は行わない。

## 仕組みと変更実験

format()は文字列を返す。formatToParts()はtype/valueの配列を返す。各valueを元の順序でspanへ入れる。CSSでcurrency、fraction、minusSignだけを装飾する。空白はカードで可視化するが金額表示では保持する。「復元結果」で通常表示との一致を確認する。

ロケールだけを変更し、通貨はUSDのまま比較する。次に通貨だけをJPYにする。表示の慣習と通貨の小数桁が別の条件であることを観察できる。

## 開けない・動かないとき

Pagesが未反映なら、実装HTMLを保存しブラウザーで開く（ローカルファイルを許可する環境）。Node.js版でも部品を確認できる。空欄時は有限の数値を入力する。表示の細部が違う場合はロケールデータと通貨を確認する。

## 安全・検証

架空データのみ。入力を送信・保存しない。DOMへの挿入はtextContent。会計計算や為替換算は行わない。

2026-11-27、Chromium 144.0.7559.96のHTML内容直接読み込みで390px・1200pxの各画面を検証。初期値、地域・通貨変更、負号、日本円、空欄、初期化、横幅、ページエラーなしを確認。検査したHTMLのGit blobと保存予定の実装を照合。実端末、Pages公開URL、CodeQLは未検証。ローカルfile URLは検証環境で制限されていた。

- [ECMA-402](https://tc39.es/ecma402/#sec-intl.numberformat.prototype.formattoparts)
- [MDN](https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Global_Objects/Intl/NumberFormat/formatToParts)

ブログ記事ID：20261127-27-02。記事は最小例、教材は操作画面と既存Node.js版を提供する。
