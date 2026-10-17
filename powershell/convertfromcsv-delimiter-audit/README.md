# PowerShellでセミコロン区切りCSVを安全に読む

元記事：[ConvertFrom-Csvで区切り文字を確認](https://github.com/papanda925/Blog-Ideas/blob/main/content/articles/20261017-19/body.md)。

## まず試す

PowerShell 7で `./Inspect-DelimitedCsv.ps1` を実行します。セミコロン区切りのダミー文字列3行をメモリ内で変換するため、外部のCSVを読み書きしません。予想出力は商品コードP001、P002の2行（未実行の期待値）。

## ここを見る

`ConvertFrom-Csv -Delimiter ';'` はヘッダー `Code;Qty;Memo` を3プロパティへ展開します。区切りをコンマのまま読むと1つの列名になるなど、構造が変わります。ヘッダー名を先に検査する理由は、空の列を後続処理で誤解しないためです。

## 1か所変える

`-Delimiter ','` を渡すと、必須のCode列を見つけられずエラー終了する想定です。単に0件と表示して処理を続けないようにします。

## 仕事で使うなら

ファイルから読み込む前には文字コード、BOM、引用符と改行、ファイルの提供元を確認。数量の `2` も変換後は文字列なので、数値範囲と空欄を独立に検査してください。秘密情報や実業務レコードはサンプルに含めません。

## 公式情報・検証

[Microsoft Learn ConvertFrom-Csv](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/convertfrom-csv?view=powershell-7.5)。2026-10-17に公式仕様を照合。PowerShell実行・出力取得は未実施です。
