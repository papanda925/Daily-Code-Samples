# 外部連携の入力仕様をJSON Schemaで共有する｜Ajv

別のチームから届くJSONに必要な項目がないと、取り込み処理が止まります。必須項目の不足と型違いを区別して返します。

## 最初に知っておく用語

- **JSON Schema**は、JSONの構造や制約を表す仕様です。
- **必須項目**は、入力から省けない項目です。

## 要求図で考える

連携の条件を一つの要求として表します。入力データの id が必須で、整数であることを確認します。

```mermaid
requirementDiagram
    requirement ExternalRecord {
        id: R1
        text: id is present and integer
        risk: medium
        verifymethod: test
    }
    element InputValidator {
        type: Ajv
    }
    InputValidator - satisfies -> ExternalRecord
```

## ライブデモ

[公開用ライブデモ](https://papanda925.github.io/Daily-Code-Samples/demos/ajv-required-fields/#live) ／ [実装HTML](../../docs/demos/ajv-required-fields/index.html) ／ [共通JavaScript](../../docs/demos/browser-library-labs/daily.js)

1. 現行のブラウザーでデモを開く。Mermaidの描画や一部のライブラリーに外部通信を使用する。
2. 「実行」を押す。下記の値や画面内の操作欄を試す。

空のオブジェクトで実行する。id を文字列と整数で試す。

### 結果の見方

必須エラーと型エラーの違いが見える。

スキーマを共有すると、連携先も同じ条件を検証できる。id を追加しても、文字列のままなら型の条件で止まる。

## コードの要点

スキーマを compile し、検証関数と errors を使う。

実装はデモ画面の「実装コード」で確認できます。

## 仕事で使うとき

エラーの位置を通知すると、連携先が修正しやすい。

## 参考資料

- [Ajvの参照資料](https://github.com/ajv-validator/ajv)
- [Mermaidの図の書き方](https://mermaid.js.org/intro/syntax-reference.html)

本文はAIを利用して作成しました。

## 実行環境と検証

JavaScriptの構文とファイル間の対応を確認した。 Pagesでの各機能の実行とMermaidの描画は検証範囲に含まれていない。

図が表示されない場合は、本文の読み方とMermaidソースを参照する。デモ欄に取得エラーが出る場合は通信条件を確認する。検証用の架空データを使う。
