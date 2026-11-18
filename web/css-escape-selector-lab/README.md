# CSS.escape と querySelector：IDの特殊文字を安全に扱う

## ライブデモ

https://papanda925.github.io/Daily-Code-Samples/demos/css-escape-selector-lab/

GitHub PagesのURLを記載していますが、**Pages到達・実ブラウザーでの表示と操作は未確認**です。ローカルでも同じHTML/JSを開いて試せます。

## 動作条件・依存関係

- ブラウザー：`CSS.escape()`、`querySelector()`、`textContent`に対応するブラウザー。Node.jsテストのみNode.js 22で実行を確認。
- コード：`docs/demos/css-escape-selector-lab/index.html` と `app.js`。第三者ライブラリ、CDN、APIキー、外部APIは不要。
- 個人情報・実案件IDを入れず、添付の架空IDだけで試す。入力はサーバーへ送らず保存もしない。

## まず試す

1. `docs/demos/css-escape-selector-lab/index.html` をブラウザーで開きます（ブラウザー表示そのものは未検証）。
2. `ticket:01` を検索すると「コロン付きID」が見つかる想定です。
3. `ticket.02`、`123-start`、`a[b]` に一つずつ変え、セレクター文字列の扱いを比べます。
4. `missing` と空文字は「一致なし」の想定です。81文字以上を関数に渡すと`RangeError`です（画面の入力欄は80字制限）。

## ここを見る：なぜそのまま`#`に付けてはいけないのか

`.`はクラス、`:`は疑似クラス、`[`は属性セレクターなど、CSSセレクターで独自の意味を持ちます。`"#" + id`では意図しない解釈、例外、未検出が起きます。`"#" + CSS.escape(id)`は**ID値だけ**をCSS識別子としてエスケープします。CSS.escapeはHTML無害化・権限制御・SQL対策ではありません。

## 1か所変える

`ticket:01`から`ticket.02`へ変更。比較したいのは**セレクターとしての特殊文字だけ**で、検索対象リストやDOM構造は変えません。

## 失敗・境界条件

- 存在しないIDや空文字：`null`となるため「一致なし」。空文字で不正な`#`セレクターを作らない修正を実施。
- 長すぎる入力：80文字を超えたら明示的に停止。これはデモ固有の制限で、CSS.escape一般の仕様上限ではありません。
- `CSS.escape`非対応：空文字以外の検索は`TypeError`を表示。代替としてIDが分かっているなら`getElementById`も検討できます。
- 重複ID：HTMLのIDは文書内で一意である必要があります。CSS.escapeを使っても重複IDは修復されません。
- ASCII空白入りID：HTML仕様に適合しないためサンプルIDから除去し、代わりに`a[b]`を使用しました。
- DOM未構築や読み込み順の問題：存在しない要素にイベントを結び付けようとしないよう、`script`を本文末尾で読み込みます。

## 仕事で使うなら

外部システムから渡るチケットコードや項目識別子が`:`や`.`を含むとき、CSSセレクターに連結する前に必要な処理です。ただし、管理できるIDは初めから単純な英数字とハイフンにする、単なるID探索なら`getElementById`を使うという設計の方が容易な場合もあります。業務画面には対象範囲の限定、重複ID検査、DOM更新タイミングの配慮が必要です。

## テスト

```bash
node web/css-escape-selector-lab/test.cjs
```

2026-11-18のローカルNode.js 22.16.0で、**疑似rootを注入した13項目がPASS**。これはID値のバリデーション、エスケープ関数への引渡し、未検出・空文字・80文字超過・API非対応の論理テストです。**実ブラウザーのCSSパーサー、GitHub Pagesへの到達、WordPress内表示は未確認**です。

## 一次資料

- [MDN CSS.escape()](https://developer.mozilla.org/en-US/docs/Web/API/CSS/escape_static)
- [MDN querySelector()](https://developer.mozilla.org/en-US/docs/Web/API/Document/querySelector)
- [MDN HTML id属性](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Global_attributes/id)
- [CSSWG CSSOM草案（参照時点の案）](https://drafts.csswg.org/cssom/#the-css.escape()-method)
