# URLSearchParams.sort()で重複キーの順番を観察する

ブラウザーでURLのクエリ文字列を扱う開発者向け。キーを並べ替えても、同名キーに紐づく値の相対順序が保持されることを実験します。

## ライブデモ

https://papanda925.github.io/Daily-Code-Samples/demos/urlsearchparams-stable-sort-lab/

実装: [index.html](../../docs/demos/urlsearchparams-stable-sort-lab/index.html) / [app.js](../../docs/demos/urlsearchparams-stable-sort-lab/app.js)

## まず試す

1. JavaScriptを有効にしたブラウザーでデモを開きます。ログイン・権限・通信は不要です。
2. 初期入力 `tag=red&z=9&tag=blue&a=1&tag=green` で「並べ替えて比較」を押します。
3. 変更後は `a=1&tag=red&tag=blue&tag=green&z=9`。tag値は red→blue→green の順を保ちます。
4. 入力を `b=2&a=1&b=3` に変え、`a=1&b=2&b=3` になることを観察します。

## 仕組みと1か所変更

`URLSearchParams` は重複キーを保持するリストです。`sort()` はキーをUTF-16コード単位順に**安定ソート**します。値でソートするものではありません。`get("tag")` は最初の値だけ、`getAll("tag")` は全値を順に返します。

`tag=red&tag=blue` の順を入れ替えて再実行し、並べ替え後も入力時の相対順が維持されることを確かめます。

## うまくいかないとき

- ボタンが反応しない: JavaScriptが有効か、`app.js` が読み込めているか開発者ツールで確認します。
- `+` が空白になる: `application/x-www-form-urlencoded` の規則です。リテラルのプラスは `%2B` を使います。
- 大文字小文字が期待と違う: キー名の比較はロケール依存の辞書順ではありません。
- 入力に `?` が付いている: 先頭の1文字のみ除去します。URL全体ではなくクエリ部分を入力してください。

## 安全・検証・応用

架空の文字列のみをブラウザー内で処理し、送信・保存・外部ライブラリはありません。Node.jsでの単体テストは別途実施し、ブラウザー実操作とPages到達は未確認です。署名付きURLや認証クエリを安易に並べ替えると署名が壊れることがあります。キャッシュキーや検索条件の正規化では、重複キーと値の順番が業務上意味を持つか確認してください。

公式資料:
- https://developer.mozilla.org/en-US/docs/Web/API/URLSearchParams/sort
- https://url.spec.whatwg.org/#dom-urlsearchparams-sort
- https://developer.mozilla.org/en-US/docs/Web/API/URLSearchParams/getAll

対応ブログ記事ID: 20261122-06（公開URLはWordPress GET後に確定）。
