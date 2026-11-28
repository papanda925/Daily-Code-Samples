# 注文明細から部署別の合計を抜き出す｜JSONata

担当部署ごとの注文額は、明細の行をそのまま眺めても分かりにくいものです。部署ごとに束ねて、合計だけを抜き出します。

## 最初に知っておく用語

- **式**は、抽出や集計の規則を記した文字列です。
- **グループ化**は、共通の項目ごとにデータを束ねる処理です。

## サンキー図で考える

線の太さは金額です。総務へ合流する2件を足すと2,000になります。

```mermaid
sankey-beta
明細A,総務,800
明細B,経理,1500
明細C,総務,1200
総務,全部署,2000
経理,全部署,1500
```

## ライブデモ

[公開用ライブデモ](https://papanda925.github.io/Daily-Code-Samples/demos/jsonata-department-totals/#live) ／ [実装HTML](../../docs/demos/jsonata-department-totals/index.html) ／ [共通JavaScript](../../docs/demos/browser-library-labs/daily.js)

1. 現行のブラウザーでデモを開く。Mermaidの描画や一部のライブラリーに外部通信を使用する。
2. 「実行」を押す。下記の値や画面内の操作欄を試す。

金額の一つを変える。次はその金額を引用符で囲む。

### 結果の見方

数値なら部署別に合計できる。文字列ではエラーが出る。

明細を一件増やして、どの部署の合計だけが変わるかを予想する。部署名の余分な空白も、グループを分ける原因になる。

## コードの要点

items{department: $sum(amount)} を評価して部署ごとの合計を得る。

実装はデモ画面の「実装コード」で確認できます。

## 仕事で使うとき

型の混在した CSV を取り込む場合は集計の前に金額の型をそろえる。

## 参考資料

- [JSONataの参照資料](https://github.com/jsonata-js/jsonata)
- [Mermaidの図の書き方](https://mermaid.js.org/intro/syntax-reference.html)

本文はAIを利用して作成しました。

## 実行環境と検証

JavaScriptの構文とファイル間の対応を確認した。 Pagesでの各機能の実行とMermaidの描画は検証範囲に含まれていない。

図が表示されない場合は、本文の読み方とMermaidソースを参照する。デモ欄に取得エラーが出る場合は通信条件を確認する。検証用の架空データを使う。
