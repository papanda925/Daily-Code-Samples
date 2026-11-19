# requestSubmit() と submit() の違いを試す

HTMLフォームをJavaScriptから送信するとき、ブラウザーの入力検証と submit イベントがどう変わるかを観察する教材です。**外部送信はしません**。

## ライブデモ
https://papanda925.github.io/Daily-Code-Samples/demos/form-requestsubmit-vs-submit/

## まず試す
1. デモを開き、氏名を空欄のまま「requestSubmitを呼ぶ」を押す。
2. invalidイベントが記録され、submitイベントが発火しないことを確認する。
3. 「山田（架空）」と入力してもう一度押すと、submitイベントと送信ボタンのvalueが記録される。
4. 「submit()との違いを表示」は危険な実送信を行わず、違いの説明だけを表示する。

## ファイルと仕組み
- [公開用HTML](../../docs/demos/form-requestsubmit-vs-submit/index.html)
- [JavaScript](../../docs/demos/form-requestsubmit-vs-submit/app.js)
- `requestSubmit(button)` は指定ボタンを使った送信を要求し、制約検証とsubmitイベントを経由する。
- `form.submit()` は制約検証とsubmitイベントを経由しない。実際に呼ぶとページ遷移・送信が起こり得るのでデモでは呼ばない。
- `event.preventDefault()` は通常送信を止める。invalid時はsubmit自体が発火しない。
- `new FormData(form,event.submitter)` で押されたボタンのname/valueも観察できる（対応ブラウザーが必要）。

## ここを見る・1か所変える
`required` をHTMLから外すと、空欄でもsubmitイベントが発火する。入力検証が「送信イベントの前」にあることを確認できる。

## うまくいかないとき
- ログが空：ブラウザーの開発者ツールでapp.jsの読み込みを確認する。
- 入力が空でsubmitが出ない：requiredによる正常な検証。invalidログを確認する。
- FormDataの第2引数でエラー：ブラウザー対応を確認する。デモは最新のChromium/Firefox/Safari系を想定。

## 仕事で使うなら
保存ボタンとプレビューボタンのような複数の送信ボタンを使う場合、`requestSubmit(対象ボタン)` でどの操作かを明示できる。ただしサーバー側検証は必須であり、クライアント側のrequiredだけを信用しない。

## 安全・検証
架空入力のみ。外部API・CDN・ライブラリ・権限・ストレージ不要。実送信はpreventDefaultで阻止。静的コード確認済み、ブラウザー操作と公開URL到達は未確認。

公式資料: https://developer.mozilla.org/en-US/docs/Web/API/HTMLFormElement/requestSubmit ・ https://html.spec.whatwg.org/multipage/forms.html#dom-form-requestsubmit-dev

対応記事ID: 20261119-09（公開URLは未確定）。
