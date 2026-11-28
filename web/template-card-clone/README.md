# カードのひな形を複製して別々の内容を入れる｜template

HTMLの `<template>` にカードの構造を作り、入力した名前ごとに複製します。空欄を除外し、文字列をHTMLとして解釈せず表示する流れを試せます。

対応記事ID: `20261128-79-02`

## ライブデモ

[カードひな形の複製デモ](https://papanda925.github.io/Daily-Code-Samples/demos/template-card-clone/#live)

## 試し方

1. 初期値 `備品A,備品B` のまま「実行」を押します。2つのカードが表示されます。
2. `備品A,備品B,備品C` に変えて再実行します。3枚になり、既存カードと新しいカードが別の内容を持ちます。
3. `備品A,,備品B,` と入力します。カンマ区切り要素の前後空白を除去したあと、空欄は捨てるため2枚だけ表示されます。
4. `<img src=x onerror=alert(1)>` のような文字列を試すと、HTML要素にならず文字として表示されます。

## 仕組み

実行コードは空の `template` 要素を作り、その `content`（DocumentFragment）へ `p.card` のひな形を1つ入れます。各名前ごとに `cloneNode(true)` で複製し、`textContent` を設定してから画面へ追加します。名前を入れた後に複製するのではなく、同じ形のひな形から独立したノードを作ります。

`<template>` の中身は文書にそのまま表示されません。複製し、文書へ挿入した後にカードとして見えるようになります。空欄は `split(v).filter(Boolean)` で無視します。

## 実務に使うとき

- 同じ構造の行やカードを作るときに使えます。構造の修正場所をひな形へまとめられます。
- ひな形に `id` を含めて複数複製する場合、複製後に一意なIDへ書き換えます。重複IDはラベル、ARIA参照、CSS/JavaScriptの検索を誤らせます。
- ユーザー入力を `innerHTML` に流し込まず、文字として表示したい箇所には `textContent` を使います。
- このデモはカンマを区切り文字とする簡易入力です。名前にカンマを含めるCSVエスケープには対応していません。

## トラブルシューティング

- カードが表示されない: 「実行」を押したか、入力に空白以外の名前があるか確認します。
- 1枚しか出ない: 区切りが半角カンマ `,` か確認します。
- 空白カードが出る: 固定した教材版で `filter(Boolean)` が反映されているかを確認します。
- 名前がHTMLとして働く: 実装が `textContent` ではなく `innerHTML` を使っていないか確認します。
- 図が見えない: Mermaidの外部読込条件を確認し、本文にある図の説明とソースも参照します。

## 公式資料とライセンス

- [WHATWG HTML Standard: template element](https://html.spec.whatwg.org/multipage/scripting.html#the-template-element)
- [WHATWG DOM Standard: Node.cloneNode](https://dom.spec.whatwg.org/#dom-node-clonenode)
- [WHATWG DOM Standard: Node.textContent](https://dom.spec.whatwg.org/#dom-node-textcontent)
- [MDN: HTMLTemplateElement.content](https://developer.mozilla.org/en-US/docs/Web/API/HTMLTemplateElement/content)
- [MDN: Node.cloneNode()](https://developer.mozilla.org/en-US/docs/Web/API/Node/cloneNode)
- [Mermaid v11.12.2 LICENSE](https://github.com/mermaid-js/mermaid/blob/mermaid%4011.12.2/LICENSE)
- [実装HTML](../../docs/demos/template-card-clone/index.html) · [共通JavaScript](../../docs/demos/browser-library-labs/daily.js)

HTML template and DOM cloning APIs are web standards and are not external JS library dependencies. Mermaid used for diagrams is MIT-licensed. The demo uses Mermaid from an external CDN when displaying diagrams.

## 検証状況

実施: Node.js構文検査、Python HTMLParserで実際のHTMLの `#live`、`#input`、`#run` を確認。コード例・操作名・入力値・空欄除外ロジック・固定ライブURLを静的照合しました。

未確認: GitHub Pages上でのブラウザー表示・実操作、複数ブラウザー間の表示、支援技術による操作、Mermaidの描画。HTML DOMの実ブラウザー動作試験は実行していません。
