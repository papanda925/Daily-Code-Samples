# Excel TEXTSPLITで区切り文字を1か所変えて観察

TEXTSPLITで1セルの文字列を列へ分割し、区切り文字をカンマからセミコロンへ変えたときの結果を観察する教材です。

## 試す式

```text
=TEXTSPLIT(A1,",")
```

A1へ `red,green,blue` を入れて結果を確認します。次にA1を `red;green;blue` へ変え、式側のdelimiterも `";"` へ変更します。

[Microsoft Support — TEXTSPLIT function](https://support.microsoft.com/office/textsplit-function-b1ca414e-4c21-4ca0-b1b7-bdecace8a6e7)

検証状態: Microsoft公式情報確認済み。Excel実機再確認は未実施。

## 実行前に確認すること

`TEXTSPLIT` に対応したExcelが必要です。[formulas.txt](formulas.txt) は入力例であり、自動実行ファイルではありません。

## 観察する結果

`A1=red,green,blue`、`B1=TEXTSPLIT(A1,",")` なら、B1から右方向へ3セルに分割される想定です。入力と区切り文字の両方をセミコロンへ変えると、同じ3セルに分割される見込みです。

## 動かないとき・検証

`#NAME?` なら対応版を確認し、`#SPILL!` なら展開先セルが空か確認します。実在データは使用しないでください。2026-10-31：テキスト例とREADMEを照合。Excel実機での試験は未実施。
