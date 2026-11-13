# URLSearchParams重複キー実験：get / getAll / append / set

フォームから複数値の検索条件を送ると、クエリー文字列に同じキーが2度以上現れることがあります。この教材は`get()`で先頭1件しか得られない原因と、`getAll()`・`append()`・`set()`の違いを体験するものです。データはすべて架空です。

## ライブデモ

[URLSearchParamsの重複キー実験](https://papanda925.github.io/Daily-Code-Samples/demos/urlsearchparams-duplicate-keys-lab/)（公開予定のGitHub Pagesパス。実ブラウザーでの到達・描画は未確認）

[HTML](../../docs/demos/urlsearchparams-duplicate-keys-lab/index.html) ／ [画面コード](../../docs/demos/urlsearchparams-duplicate-keys-lab/app.mjs) ／ [解析ロジック](../../docs/demos/urlsearchparams-duplicate-keys-lab/query-utils.mjs) ／ [Nodeテスト](test.mjs)

## まず試す

1. ページを開き、初期入力 `tag=red&tag=blue&task=check+only&empty=` と検索キー `tag` を確認します。
2. **解析**を押すと`get("tag")`は`red`、`getAll("tag")`は`["red","blue"]`、件数は2と表示されるはずです。
3. 追加する値`green`を入れ、**appendで追加**を押すと`tag`が3件になります。
4. **setで置換**を押すと、同じキーの値は`green`1件だけになります。
5. **サンプルに戻す**で元の入力へ戻せます。

## 期待する観察結果

| 状況 | get("tag") | getAll("tag") |
|---|---|---|
| 初期入力 | red | ["red","blue"] |
| appendでgreen追加 | red | ["red","blue","green"] |
| setでgreen置換 | green | ["green"] |
| ないキーを指定 | null | [] |

`get()`と`getAll()`は同じキーに複数値があるときに結果が違います。`append()`は追加、`set()`は同名の他の値を削除する置換です。両者を同じ更新操作と見なすと、複数選択の値が失われます。

## 1か所変える

検索キーを`tag`から`task`へ変更し、**解析**を押します。初期値の`task=check+only`が`check only`と表示されるのは、クエリー文字列の`+`が空白として解釈されるためです。 `toString()`は必要な符号化を行い、先頭の`?`を付けません。複数値を残す場面では`append()`、ひとつへ整理するときだけ`set()`を使います。

## 実装の仕組み

`query-utils.mjs`は`new URLSearchParams()`とそのメソッドを包み、`inspectQuery()`が最初の値・全値・パラメーターの並びを返し、`updateQuery()`が追加・置換後のクエリー文字列を返します。`app.mjs`はボタンのイベントを受け取り、`textContent`で結果を表示します。入力されたHTML風文字列をタグとしてDOMへ挿入しません。

`URLSearchParams`はURL全体を解析する道具ではありません。入力するのはURLの`?`より後ろのクエリー部分だけです。デモは実URLの`location.search`を読み取ったり、サイトへ送信したりしません。

## 実行環境・動かないとき

- ブラウザーのJavaScriptとES Modulesに対応した環境が必要です。外部JavaScriptライブラリ、APIキー、ログイン、権限要求は不要です。
- GitHub Pagesの公開URLを開く際にはページの取得通信が発生します。ただしデモの入力値を他所へ送る通信は実装していません。実トークンや個人情報を貼り付けないでください。
- `file://`直開きではES Moduleの読込が制限される場合があります。ローカル利用はリポジトリ直下で`python -m http.server 8000 --directory docs`を起動し、`http://localhost:8000/demos/urlsearchparams-duplicate-keys-lab/`へアクセスしてください。
- 表示されない場合は開発者ツールのConsole/Networkで`app.mjs`と`query-utils.mjs`の読込を確認します。
- `empty=`は値が空文字、存在しないキーは`null`です。これは同じではありません。
- 入力は2000文字、行の表示は最大80件に限定しています。これらはデモ固有の制限でありWeb標準の上限ではありません。

## テストと未確認

Node.jsが利用できれば、リポジトリ直下で`node --test web/urlsearchparams-duplicate-keys-lab/test.mjs`を実行できます。入力が重複、空値、欠落、追加、置換、エンコード、他キー保持の場合を扱います。実ブラウザーDOM、GitHub Pages実配信、画面の操作、スマートフォン、スクリーンリーダー、WordPress表示は**未確認**と区別します。

## 公式情報

- [MDN：URLSearchParams](https://developer.mozilla.org/en-US/docs/Web/API/URLSearchParams)
- [MDN：getAll](https://developer.mozilla.org/en-US/docs/Web/API/URLSearchParams/getAll)
- [MDN：toString](https://developer.mozilla.org/en-US/docs/Web/API/URLSearchParams/toString)

## ブログとの対応

記事ID：`20261113-03`（WordPress公開URLは未確定）。ブログ記事では問題の意味と最小コードを説明し、この教材ではボタン操作・全パラメーターの一覧・テストを試します。
