# 定型の月次サマリーをPowerPointで作る｜PptxGenJS

毎月の報告で変わるのが見出しと件数なら、同じ配置を使い回せます。月名を入れてスライドを一枚生成します。

## 最初に知っておく用語

- **スライド**は、プレゼン資料の1画面です。
- **テキストボックス**は、文字を置く枠です。

## カンバン図で考える

列は月次報告の作業段階です。生成できたら、最後の列の見た目も点検します。

```mermaid
kanban
    column1[入力]
        task1[月名と件数を用意]
    column2[生成]
        task2[見出しと件数を配置]
    column3[確認]
        task3[長い見出しのはみ出しを点検]
```

## ライブデモ

[公開用ライブデモ](https://papanda925.github.io/Daily-Code-Samples/demos/pptx-monthly-summary/#live) ／ [実装HTML](../../docs/demos/pptx-monthly-summary/index.html) ／ [共通JavaScript](../../docs/demos/browser-library-labs/daily.js)

1. 現行のブラウザーでデモを開く。Mermaidの描画や一部のライブラリーに外部通信を使用する。
2. 「実行」を押す。下記の値や画面内の操作欄を試す。

月名を変えて保存する。長い見出しも試す。

### 結果の見方

同じ位置に月名と件数が入る。

タイトルを長くして、読みやすい文字サイズが維持されるか確認する。数値が折り返す場合は、データより先に枠の幅を調べる。

## コードの要点

addSlide で1枚を追加します。addText を使って見出しと件数の位置を指定します。write でファイルにします。

実装はデモ画面の「実装コード」で確認できます。

## 仕事で使うとき

月次報告を自動化するときは桁が増えた値と長い見出しをテストする。

## 参考資料

- [PptxGenJSの参照資料](https://github.com/gitbrent/PptxGenJS)
- [Mermaidの図の書き方](https://mermaid.js.org/intro/syntax-reference.html)

本文はAIを利用して作成しました。

## 実行環境と検証

JavaScriptの構文とファイル間の対応を確認した。 Pagesでの各機能の実行とMermaidの描画は検証範囲に含まれていない。

図が表示されない場合は、本文の読み方とMermaidソースを参照する。デモ欄に取得エラーが出る場合は通信条件を確認する。検証用の架空データを使う。
