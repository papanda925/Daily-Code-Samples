# Promise.withResolvers()で完了通知を分離する
JavaScriptの非同期処理を初めて学ぶ方向けに、Promiseを作る場所と、成功・失敗を通知する場所を分ける実験です。ボタンを押すと「保留中→resolve/reject→結果」が順に表示されます。

## ライブデモ
[Promise完了通知の比較デモ](https://papanda925.github.io/Daily-Code-Samples/demos/promise-withresolvers-queue-lab/)（Pages反映・ブラウザー到達は未確認）

## ファイルと実行環境
- [公開用HTML](../../docs/demos/promise-withresolvers-queue-lab/index.html)
- [JavaScript完全版](../../docs/demos/promise-withresolvers-queue-lab/app.js)
- 前提：Promise.withResolvers()に対応する現行ブラウザー。ライブラリ、ログイン、権限、通信は不要です。
- ローカル実行：`docs/demos/promise-withresolvers-queue-lab/index.html`をブラウザーで開きます。開けない場合はフォルダ構造とConsoleを確認してください。

## 手順と期待結果
1. 待ち時間を初期値500のまま「処理を開始」を押す。
2. 「1. Promise作成：まだ保留中」→「2. resolveを呼び出し」→「3. 成功：架空の処理が完了しました」の順に表示される設計です。
3. 「失敗させる」にチェックして再実行すると、2番目がreject、3番目が失敗の表示になります。
4. 待ち時間を1000に変更し、表示順は同じで待機が長くなることを比較します。入力を4000にするとエラーを表示します。

## 仕組み
`Promise.withResolvers()`は`{promise, resolve, reject}`を返します。`resolve`で成功、`reject`で失敗を通知し、`await promise`が結果を待ちます。教材は`setTimeout`で架空の完了通知を作ります。実際のネットワーク処理ではありません。例外時も`finally`でタイマーを片付け、ボタンを再び押せるようにします。

## うまくいかないとき
- `Promise.withResolvers is not a function`：対応ブラウザーを確認。未対応環境では従来の`new Promise((resolve,reject)=>...)`を使います。
- ログが出ない：HTMLとapp.jsが同じフォルダにあるか、開発者ツールConsoleの404/構文エラーを確認。
- 結果が遅い：待ち時間を0〜3000へ戻します。ブラウザーのタイマーは厳密な実時間保証ではありません。
- 失敗表示が出る：チェックボックスを外して再実行します。

## 安全・検証・出典
入力は架空の待ち時間と成功/失敗フラグのみ。通信・永続保存・個人情報・外部依存はありません。2026-11-22にコードを作成。Node.js構文/ロジック検査と実ブラウザー操作、Pages到達は別に記録し、未実施をPASSとしません。
- [ECMAScript Promise.withResolvers](https://tc39.es/ecma262/#sec-promise.withresolvers)
- [MDN Promise.withResolvers](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise/withResolvers)

## 対応記事
記事ID：`20261123-04`。記事は考え方と最小コード、GitHub教材はボタン・ログ・失敗切替を含む完全版です。
