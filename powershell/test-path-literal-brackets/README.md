# PowerShellのTest-Path：角括弧を含むファイル名を文字どおり判定

元記事：[PathとLiteralPathの違い](https://github.com/papanda925/Blog-Ideas/blob/main/publish/items/20261016-07-body.md)。名前に`[2026]`のような文字を含むファイルを使って、ワイルドカードと文字どおりのパス指定を比較する教材です。

## まず試す

PowerShell 7で `./Show-LiteralPathDifference.ps1` を実行する。自動的にOSの一時フォルダー配下にGUID付きの**専用練習フォルダー**を作り、その中だけに空の`実績[2026].csv`を作る。実行前にコードと保存先を確認する。

期待（**未実行**）：`Test-Path -LiteralPath` はTrue、`Test-Path -Path`はパターンとして角括弧を解釈するため、対象の実ファイルと一致せずFalseになる。異なる名前のファイルが存在するなど、環境によって結果は変わり得る。作成されたフォルダーは自動削除しないので、表示されたパスを確認し、不要なら手動削除する。

## ここを見る

- `-Path`はワイルドカード検索。`[2026]`は一つの文字集合を表す構文。
- `-LiteralPath`は角括弧をそのまま名前の一部として扱う。
- `-PathType Leaf`はファイルなどの末端項目。フォルダーには`Container`を使う。
- ファイルの存在は後続の読取り・書込み権限や内容を保証しない。

## 1か所変える

サンプルコードのファイル名を`実績2026.csv`へ変更したら、PathとLiteralPath両方の判定がTrueへそろう想定。再実行時は別のGUID付き一時フォルダーを使うので、以前の結果と混同しない。

## 仕事で使うなら

ファイル選択画面などで確定した**一つの実在パス**を扱うときはLiteralPathを検討する。一方、拡張子`*.csv`のように意図的に複数項目を探したい場合はPathによるパターン指定が適切なこともある。

## 注意・出典

一時フォルダー以外を触らない。機微情報や実業務のパスを出力しない。2026-10-16作成。Microsoft Learn [Test-Path](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.management/test-path?view=powershell-7.5) / [.NET File.WriteAllText](https://learn.microsoft.com/en-us/dotnet/api/system.io.file.writealltext) を参照。**PowerShell 7実機で未実行**。
