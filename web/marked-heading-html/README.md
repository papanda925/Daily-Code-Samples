# Markdownの見出しがどのHTMLになるか見る｜marked

同じ「見出し」という文でも、先頭の記号でページ内の階層が変わります。変換後のHTMLを観察し、編集した箇所を確かめます。

## 最初に知っておく用語

- **Markdown**は、見出しや箇条書きを記号で書く形式です。
- **HTML**は、ページ構造を表す形式です。

## 処理のフローチャートで考える

左から右に読みます。「変換後のHTML」が変わると「表示先」にどう影響するかを予想します。

```mermaid
flowchart LR
    A["Markdown"] --> B["変換後のHTML"] --> C["表示先"]
```

## ライブデモ

[公開用ライブデモ](https://papanda925.github.io/Daily-Code-Samples/demos/marked-heading-html/#live) ／ [実装HTML](../../docs/demos/marked-heading-html/index.html) ／ [共通JavaScript](../../docs/demos/browser-library-labs/daily.js)

1. 現行のブラウザーでデモを開く。Mermaidの描画や一部のライブラリーに外部通信を使用する。
2. 「実行」を押す。下記の値や画面内の操作欄を試す。

# を ## に変える。出力タグを見比べる。

### 結果の見方

h1 が h2 に変わる。

見出しの順番を変えると、ページの構造にも反映される。HTMLを文字として出すことで、生成結果を一つずつ読み取れる。

## コードの要点

marked.parse の出力をプレビュー欄の textContent に入れる。

実装はデモ画面の「実装コード」で確認できます。

## 仕事で使うとき

ユーザーが書いた文をHTMLとして表示する場合は、危険なタグや属性を除く処理を設ける。

## 参考資料

- [markedの参照資料](https://github.com/markedjs/marked)
- [Mermaidの図の書き方](https://mermaid.js.org/intro/syntax-reference.html)

本文はAIを利用して作成しました。

## 実行環境と検証

Node.jsで実行処理を確認した。 Pagesでの各機能の実行とMermaidの描画は検証範囲に含まれていない。

図が表示されない場合は、本文の読み方とMermaidソースを参照する。デモ欄に取得エラーが出る場合は通信条件を確認する。検証用の架空データを使う。
