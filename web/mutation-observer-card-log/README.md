# MutationObserverでカードの追加・削除・状態変更を観察する

ページ内の架空カードを操作し、DOM（HTMLの要素ツリー）の変化が通知される仕組みを理解する教材です。JavaScript初学者が、クリックによる変更と監視通知の違いを体験できます。

## ライブデモ

[カードの変更監視デモ](https://papanda925.github.io/Daily-Code-Samples/demos/mutation-observer-card-log/)（GitHub Pagesへの反映・ブラウザでの動作は未確認）

実装は [index.html](../../docs/demos/mutation-observer-card-log/index.html) と [app.js](../../docs/demos/mutation-observer-card-log/app.js) にあります。ビルド、外部ライブラリ、アカウント、APIキーは不要です。

## まず試す

1. デモを開き、**「カードを追加」**を押します。初期2枚が3枚になり、ログに「追加：1枚」が出る想定です。
2. **「先頭の状態を切替」**を押します。カードAが「完了」になり、ログに「pending → done」が出る想定です。
3. **「監視を停止」**を押し、さらにカードを追加します。カードは増えますが、通知ログは増えません。**「監視を再開」**してもう一度追加すると新しい通知が出る想定です。

| 操作 | カード一覧 | 通知ログ |
|---|---|---|
| 追加 | 1枚増える | 追加：1枚 |
| 先頭を切替 | 状態が変わる | pending → done |
| 停止して追加 | 1枚増える | 増えない |
| 再開して追加 | 1枚増える | 新規の追加通知 |

ログは最新12行まで、カードは最大8枚です。「最後のカードを削除」で戻せます。「ログを消す」はカードには触れません。

## 仕組み

`new MutationObserver(callback)` で変更通知の受け手を作り、`observer.observe(list, options)` で監視対象をカード一覧に限定します。

- `childList: true` はカードの追加・削除を監視します。教材では一覧直下の変更だけをログに記録します。
- `attributes: true` と `subtree: true` は各カードの `data-state` 属性変更を監視します。
- `attributeFilter: ["data-state"]` で無関係な属性変更を除外します。
- `attributeOldValue: true` で変更前の状態を取得し、`pending → done` と表示します。
- `disconnect()` で通知を止め、`observe()` で再開します。停止中の変更履歴を自動補完する機能ではありません。

ログ欄は監視対象の外側です。監視対象内にログを追記すると、ログ追加自体が新しい変更として検出される設計ミスになりやすいためです。

## 1か所変えてみる

`app.js` の `attributeOldValue: true` を `false` に変更し、ページを再読込して「先頭の状態を切替」を押します。変更通知は届きますが、変更前の値が記録されないため、ログが「不明 → done」になると予想できます。元に戻して比較してください。

## 自分のPCで動かす

`docs/demos/mutation-observer-card-log/` の `index.html` と `app.js` を同じフォルダへ保存し、HTMLをブラウザで開きます。ローカルファイルの実動作は未確認です。開けない場合はローカルHTTPサーバー（例：`python3 -m http.server 8000 --bind 127.0.0.1`）を使い、作業終了後に `Ctrl+C` で止めます。

## うまく動かないとき

| 症状 | 確認 | 対処 |
|---|---|---|
| ボタンが反応しない | 開発者ツールのConsole | `app.js` が同じフォルダにあるか確認 |
| 通知が増えない | 「停止中」の表示 | 「監視を再開」を押す |
| 変更前が「不明」 | `attributeOldValue` | `true` に戻す |
| 追加できない | カード枚数 | 最大8枚。先に削除 |
| 通知が複数行になる | 監視設定 | DOM変更の種類と対象を確認 |

## 安全と検証

入力は固定の架空カードだけで、外部通信、端末権限、認証、課金、音、点滅、データ保存はありません。依存ライブラリはなく、追加ライセンスはありません。DOMへの表示は `textContent` を使用します。

2026-11-02にMDNの `MutationObserver`、`observe()`、`disconnect()` を照合しました。JavaScriptの構文はV8で検査した場合にのみ、その結果を制作記録へ記載します。**実ブラウザ、GitHub Pages到達、WordPress表示、モバイル、印刷/PDFの実確認は未実施**です。

公式資料：
- https://developer.mozilla.org/en-US/docs/Web/API/MutationObserver
- https://developer.mozilla.org/en-US/docs/Web/API/MutationObserver/observe
- https://developer.mozilla.org/en-US/docs/Web/API/MutationObserver/disconnect

## ブログとの対応

papanda925.com向け記事ID：`20261102-03`（記事URLは公開後に確定）。記事本文は操作と原理の要点、こちらは完全なHTML・JavaScriptと検証・改造方法を担当します。
