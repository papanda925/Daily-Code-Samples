# PowerShellでProcessスコープのPATH探索順を観察する

WindowsのUser/Machine PATHを書き換えず、**現在のPowerShellプロセスだけ**でPATHの先頭を一時変更し、`Get-Command -All` で探索順を観察する教材です。

## まず試す

`Show-PathPrecedence.ps1` を実行します。`$env:TEMP` 配下にテスト用ディレクトリと `papanda-demo.cmd` を2つ作り、PATHの順序だけを切り替えます。

## ここを見る

- `[BEFORE]` と `[AFTER]` の `Get-Command -All` の順序
- 実行結果が `A` / `B` のどちらになるか
- User/Machine PATHは変更されないこと

## 1か所変える

スクリプト内の `$env:Path = "$dirB;$dirA;$oldPath"` を `$env:Path = "$dirA;$dirB;$oldPath"` に変え、同名コマンドの選択が変わることを観察します。

## 仕事で使うなら

CLIの新旧バージョン比較や、PATH競合の切り分けに使えます。恒久PATH変更の前にProcessスコープで試せます。

## 注意点

信頼できないディレクトリをPATH前方へ置くと、意図しない同名コマンドを実行する危険があります。このサンプルは自分で作成した一時ディレクトリだけを使い、終了時にPATHを戻してテストファイルを削除します。

検証状態: implemented。Windows実機では未確認です。
