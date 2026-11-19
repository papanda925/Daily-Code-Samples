# URL.canParseで入力URLを事前判定する

フォームに入力された絶対URL・相対URLを、通信せずに解析できるか比較するブラウザー教材です。対象はWeb開発初学者です。

## ライブデモ

https://papanda925.github.io/Daily-Code-Samples/demos/url-canparse-input-check/

実装は [index.html](../../docs/demos/url-canparse-input-check/index.html) と [app.js](../../docs/demos/url-canparse-input-check/app.js) です。

## まず試す

1. URL欄が `../guide?lang=ja`、基準URL欄が `https://example.com/docs/start` であることを確認します。
2. 「URLを確認」を押します。正規化URL `https://example.com/guide?lang=ja` が表示される想定です。
3. 基準URLを空欄にして再実行すると、相対URLだけでは解析できません。
4. URLを `https://example.com/a` に変更すると基準URLなしでも成功します。

## ここを見る

`URL.canParse(input, base)` は解析可能かを真偽値で返します。成功時だけ `new URL(input, base)` で構成要素を表示します。基準URL自体が不正な場合は `URL.canParse` がfalseになるため、入力と基準の両方を確認してください。

## 1か所変える

URL欄を `mailto:hello@example.com` にすると解析には成功しますが、Web URLは「いいえ」になります。**解析可能とHTTP(S)であることは別条件**です。空欄はフォームの必須入力で送信が止まります。

## 仕事で使うなら

ユーザーが入力したリンクの形式を確かめる前段階で利用できます。ただしURLの形式判定だけで安全性を判断せず、許可するスキーム・ホストを別途検証してください。サーバー側のSSRF対策にはなりません。

## うまくいかないとき

ボタンが動かない場合は開発者ツールのConsoleで `URL.canParse` の対応状況と `app.js` の読込を確認してください。相対URLが失敗する場合は基準URLの絶対URL形式を確認します。フォームが空欄の場合はブラウザーの必須入力検証が働きます。

## 安全・検証・出典

外部ライブラリ、CDN、外部通信、個人情報取得、永続保存はありません。入力は画面内でのみ処理します。静的コード確認済み。ブラウザー操作とPages URL到達は未確認です。ブラウザー実測結果ではなく仕様上の期待値を記載しています。

- https://developer.mozilla.org/en-US/docs/Web/API/URL/canParse_static
- https://developer.mozilla.org/en-US/docs/Web/API/URL/URL
- https://url.spec.whatwg.org/

対応記事ID: 20261120-06。記事は仕組みと実務判断を、こちらは入力を変える実験を扱います。
