# 既存の候補を表示しながら新しい値も受け付ける｜datalist

部署の入力欄では、よく使う値を候補に出すと便利です。一覧にない新しい部署を入力できるかも確認します。

## 最初に知っておく用語

- **候補リスト**は、入力の助けになる見本の一覧です。
- **自由入力**は、一覧以外の値も入力できることです。

## 処理のフローチャートで考える

左から右に読みます。「候補リスト」が変わると「確定した値」にどう影響するかを予想します。

```mermaid
flowchart LR
    A["部署の入力"] --> B["候補リスト"] --> C["確定した値"]
```

## ライブデモ

[公開用ライブデモ](https://papanda925.github.io/Daily-Code-Samples/demos/datalist-department-suggestions/#live) ／ [実装HTML](../../docs/demos/datalist-department-suggestions/index.html) ／ [共通JavaScript](../../docs/demos/browser-library-labs/daily.js)

1. 現行のブラウザーでデモを開く。Mermaidの描画や一部のライブラリーに外部通信を使用する。
2. 「実行」を押す。下記の値や画面内の操作欄を試す。

総務を選ぶ。次は候補にない営業と入力して確認する。

### 結果の見方

どちらも入力した値として取得できる。

ブラウザーによって候補を開く操作や表示が異なる。入力欄の値が採用されるので、見た目の候補から保存値を推測しない。

## コードの要点

input の list 属性を datalist のidへ向け、送信時に入力値を表示する。

実装はデモ画面の「実装コード」で確認できます。

## 仕事で使うとき

部署コードなど候補だけを許可する場合は、入力値を別途検証する。

## 参考資料

- [datalistの参照資料](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/datalist)
- [Mermaidの図の書き方](https://mermaid.js.org/intro/syntax-reference.html)

本文はAIを利用して作成しました。

## 実行環境と検証

JavaScriptの構文とファイル間の対応を確認した。 Pagesでの各機能の実行とMermaidの描画は検証範囲に含まれていない。

図が表示されない場合は、本文の読み方とMermaidソースを参照する。デモ欄に取得エラーが出る場合は通信条件を確認する。検証用の架空データを使う。
