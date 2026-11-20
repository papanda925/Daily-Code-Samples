# AbortSignal.any() と timeout() — 手動停止と時間制限の実験

ブラウザーで非同期処理を扱う人向け。通信を行わず、タイマーで擬似処理を再現します。処理の完了・手動停止・時間切れを画面で比較できます。

## ライブデモ

https://papanda925.github.io/Daily-Code-Samples/demos/abortsignal-any-timeout-lab/

実装: [index.html](../../docs/demos/abortsignal-any-timeout-lab/index.html) / [app.js](../../docs/demos/abortsignal-any-timeout-lab/app.js)

## まず試す

1. 対応ブラウザーでデモを開きます。外部ライブラリ、ログイン、権限許可は不要です。
2. 初期値「処理3000ms、制限1500ms」で「開始」→約1.5秒後に「時間切れで中止（TimeoutError）」。
3. 「処理500ms、制限3000ms」に変更→「処理完了（中止なし）」。
4. 「処理3000ms、制限5000ms」で開始し、直後に「手動停止」→「手動で中止（AbortError）」。

## ここを見る・仕組み

`AbortSignal.timeout(ms)` は時間切れ時に中止されるsignalを作り、`AbortSignal.any([manual, timeout])` はどちらか先に中止された理由を採用します。`AbortController.abort(reason)` は手動停止の理由を指定します。中止は処理を強制停止する魔法ではなく、受け取る側の実装がsignalを監視して後始末する必要があります。この例はタイマーをclearTimeoutしてPromiseをrejectします。

## 1か所変える

処理3000ms、制限1500msの状態で、制限だけを4000msへ変更します。時間切れから正常完了へ結果が変わります。処理と制限を同値にした場合は実行順序に依存するため、境界値で必ず同じ結果になるとは限りません。

## うまくいかないとき

- ボタンが動かない: ブラウザーのJavaScriptが有効か、開発者ツールにエラーがないかを確認。
- API非対応: `AbortSignal.any` / `AbortSignal.timeout` の対応を確認。
- 数値がおかしい: 0〜10000ms、制限は1ms以上で入力。
- 手動停止できない: 完了後はボタンが無効になります。処理時間を長くしてください。

## 仕事で使うなら

`fetch(url,{signal:AbortSignal.any([...])})` のようにキャンセル可能なAPIへ渡します。ただしサーバー側の処理停止、ロールバック、通信済みデータの削除は保証されません。画面遷移時のキャンセル、検索入力の再実行、時間制限を組み合わせる場合に役立ちます。実際の通信ではHTTPエラー、再試行、認証、ユーザーへの説明を別途設計します。

## 安全・検証・出典

架空の数値のみを扱い、ネットワーク送信・個人情報取得・保存・外部CDNはありません。ソースとロジックを静的確認。ブラウザー操作とPages公開到達は未検証です。

- https://developer.mozilla.org/en-US/docs/Web/API/AbortSignal/any_static
- https://developer.mozilla.org/en-US/docs/Web/API/AbortSignal/timeout_static
- https://developer.mozilla.org/en-US/docs/Web/API/AbortController/abort
- https://developer.mozilla.org/en-US/docs/Web/API/AbortSignal

対応ブログ記事ID: 20261121-05（公開URLはWordPress GET確認後に確定）。
