# Intl.Segmenter 書記素カウンター（Daily Code）

## 目的
絵文字・結合文字を「何文字」と数えるかは仕様次第。ブラウザーの入力欄で `String.length`（UTF-16単位）、`Array.from`（コードポイント）、`Intl.Segmenter`（書記素クラスター）を同時表示します。**入力内容を送信・保存しません**。

## 対象と依存
モダンブラウザー（`Intl.Segmenter`対応を実行時判定）。ローカル実行は Python 3 の静的サーバーが任意。自動テストは Node.js 22.x（標準ライブラリーのみ）。CDN、APIキー、課金、ビルド不要。古いブラウザーは書記素欄を「未対応」とし、別の数値で代用しません。

## 起動
リポジトリのルートで `python3 -m http.server 8000` を実行し、`http://127.0.0.1:8000/web/grapheme-counter/` を開きます。ローカルファイルとして `index.html` を開く方法もありますが、ブラウザーのローカルファイル制限がある場合はHTTPサーバーを使用してください。終了はCtrl+C。

## 操作→観察→条件変更
1. 初期値の家族絵文字ではUTF-16=11、コードポイント=7、書記素=1を**期待**します。
2. 「日本語（基準）」を押すと3/3/3を**期待**します。
3. 「11個の英字」を押すと11/11/11となり、書記素10個の警告が出ることを**期待**します。
4. 自分で架空の文字を入力すると数値が更新されます。個人情報や秘密を入力しないでください。

## 実行テスト
`node --test web/grapheme-counter/test.mjs`
8つの固定入力と、`Intl.Segmenter`未対応を模した1件を確認します。実際にテストを実行した環境と結果は記事の検証欄を参照してください。ブラウザーでの画面表示、スマートフォン、GitHub Pages公開URLは別検証です。

## 制約とトラブル対処
- 値が「未対応」なら `Intl.Segmenter` が存在するか開発者ツールで確認。対応ブラウザーで試してください。コードポイント数を代用しません。
- 値が更新されない場合はConsoleで構文エラー、Networkで `app.js` の取得を確認。
- `maxlength` はUTF-16単位であり、書記素の10個制限と同一ではありません。実業務の保存上限やバイト制限はサーバー側でも別途検証が必要です。
- Unicode/ICUの版によって書記素分割が異なる可能性があります。視覚上の幅、印刷上の文字数、バイト数を保証しません。
- 画面の10個警告は入力を遮断しません。UIの文字数ルールの教材です。

## 一次資料
- https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Intl/Segmenter
- https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/length
- https://www.unicode.org/reports/tr29/
