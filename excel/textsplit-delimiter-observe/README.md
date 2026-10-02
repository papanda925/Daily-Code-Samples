# Excel TEXTSPLITで区切り文字を1か所変えて観察

TEXTSPLITで1セルの文字列を列へ分割し、区切り文字をカンマからセミコロンへ変えたときの結果を観察する教材です。

## 試す式

```text
=TEXTSPLIT(A1,",")
```

A1へ `red,green,blue` を入れて結果を確認します。次にA1を `red;green;blue` へ変え、式側のdelimiterも `";"` へ変更します。

[Microsoft Support — TEXTSPLIT function](https://support.microsoft.com/office/textsplit-function-b1ca414e-4c21-4ca0-b1b7-bdecace8a6e7)

検証状態: Microsoft公式情報確認済み。Excel実機再確認は未実施。
