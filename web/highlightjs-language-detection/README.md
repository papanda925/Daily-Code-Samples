# 言語を明示するとコード表示はどう変わるか｜highlight.js

コードを色分けすると、数値や変数を拾いやすくなります。言語の自動判定と、JavaScriptに固定した場合を同じ入力で比べます。

## 最初に知っておく用語

- **構文強調**は、コードを役割ごとに色分けする表示です。
- **自動判定**は、入力の特徴から言語を推定する処理です。

## 処理のフローチャートで考える

左から右に読みます。「自動判定」が変わると「言語指定」にどう影響するかを予想します。

```mermaid
flowchart LR
    A["短いコード"] --> B["自動判定"] --> C["言語指定"]
```

## ライブデモ

[公開用ライブデモ](https://papanda925.github.io/Daily-Code-Samples/demos/highlightjs-language-detection/#live) ／ [実装HTML](../../docs/demos/highlightjs-language-detection/index.html) ／ [共通JavaScript](../../docs/demos/browser-library-labs/daily.js)

1. 現行のブラウザーでデモを開く。Mermaidの描画や一部のライブラリーに外部通信を使用する。
2. 「実行」を押す。下記の値や画面内の操作欄を試す。

コードを変えて実行する。自動判定と JavaScript 固定を比べる。

### 結果の見方

短い断片では判定が揺れることがある。

言語が同じと判定された場合は、Python風の短文でも比べる。HTMLのコード表示に利用する場合は、ライブラリーの更新も管理する。

## コードの要点

highlightAuto の language を表示し、highlight の言語指定結果と比較する。

実装はデモ画面の「実装コード」で確認できます。

## 仕事で使うとき

ドキュメントの言語が分かる場合は明示する。読者もコピー先を判断しやすい。

## 参考資料

- [highlight.jsの参照資料](https://github.com/highlightjs/highlight.js)
- [Mermaidの図の書き方](https://mermaid.js.org/intro/syntax-reference.html)

本文はAIを利用して作成しました。

## 実行環境と検証

JavaScriptの構文とファイル間の対応を確認した。 Pagesでの各機能の実行とMermaidの描画は検証範囲に含まれていない。

図が表示されない場合は、本文の読み方とMermaidソースを参照する。デモ欄に取得エラーが出る場合は通信条件を確認する。検証用の架空データを使う。
