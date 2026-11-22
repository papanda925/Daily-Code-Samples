# Object.groupBy()で品目を分類する
架空の品目をカテゴリごとに集め、件数を数える初心者向けブラウザー教材です。

## ライブデモ
[分類実験を開く](https://papanda925.github.io/Daily-Code-Samples/demos/object-groupby-category-lab/)（GitHub Pagesへの反映・到達は未確認）

## 実行環境と手順
Object.groupBy()対応の新しいブラウザーが必要です。追加ライブラリ、ログイン、通信権限は不要です。
1. 上のライブデモを開くか、`docs/demos/object-groupby-category-lab/index.html`をブラウザーで開く。
2. 「分類する」を押し、結果のcategory/count/namesを見る。
3. 「文具,消しゴム」を追記して再実行する。

## 期待結果
初期値は文具2件（ペン、ノート）、食品2件（パン、お茶）。文具行を追加すると文具3件になります。入力を変えずに押し直すと同じ結果です。

## 仕組みと変更実験
`app.js`の`Object.groupBy(rows, row => row.category)`は各行のcategoryで分類します。返るオブジェクトはnullプロトタイプで、各キーに行オブジェクトの配列が入ります。件数は`items.length`。同じ分類でも入力順が保持されます。分類名を「文具」から「事務用品」に変えると別グループになります。比較は完全一致です。

## 失敗時の切り分け
「非対応」ならブラウザーを更新するか対応環境で試します。「N行目」ならカンマ区切り2項目を確認します。画面が空なら`app.js`が同じディレクトリにあるか、開発者ツールのConsoleを確認します。分類にカンマを含むCSVの完全解析には対応しません。

## 安全・検証・出典
架空データのみ。通信、保存、権限要求なし。100行上限。HTML/JSの静的レビューを実施、実ブラウザー実行・Pages到達は未確認です。GitHub Actionsは使用しません。
- [ECMAScript Object.groupBy仕様](https://tc39.es/ecma262/#sec-object.groupby)
- [MDN Object.groupBy](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/groupBy)

## ブログとの対応
記事ID: `20261123-02`。記事は最小例と注意点、こちらは編集可能な入力と件数表示を提供します。
