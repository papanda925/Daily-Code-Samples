# 001: PowerShellでファイルのSHA-256ハッシュを確認する

## 何ができるサンプルか

指定したファイルの **SHA-256 ハッシュ値** を PowerShell で取得します。

ハッシュ値は、ファイルの内容から計算される固定長の値です。
同じファイルなら基本的に同じ値になり、ファイル内容が変わると値も変わります。

そのため、たとえば次のような用途があります。

- ダウンロードしたファイルが壊れていないか確認する
- 配布元が公開しているハッシュ値と比較する
- 2つのファイルが同じ内容か確認する
- ファイル変更の有無を確認する

## 使用するPowerShellコマンド

このサンプルでは、PowerShell標準の `Get-FileHash` を使用します。

```powershell
Get-FileHash -Path "C:\Temp\sample.zip" -Algorithm SHA256
```

この1行だけでもハッシュ値を取得できますが、サンプルでは初心者向けに
「ファイルが存在するか」「フォルダを指定していないか」も確認するようにしています。

## 実行方法

PowerShellを開き、このフォルダへ移動して実行します。

```powershell
.\Get-FileSha256.ps1 -Path "C:\Temp\sample.zip"
```

相対パスでも実行できます。

```powershell
.\Get-FileSha256.ps1 -Path ".\sample.txt"
```

## 実行結果の例

```text
File      : C:\Temp\sample.zip
Algorithm : SHA256
Hash      : 0123456789ABCDEF...
```

## 処理の流れ

```text
ファイルパスを受け取る
        ↓
パスが存在するか確認
        ↓
ファイルかどうか確認
        ↓
Get-FileHash で SHA-256 を計算
        ↓
ファイル名・方式・ハッシュ値を表示
```

## コードを読むポイント

### 1. param

`param` は、スクリプト実行時に外部から値を受け取るための仕組みです。

```powershell
param(
    [Parameter(Mandatory = $true)]
    [string]$Path
)
```

`Mandatory = $true` にしているため、`-Path` を指定しない場合は
PowerShellが入力を求めます。

### 2. Test-Path

```powershell
Test-Path -LiteralPath $Path
```

指定したパスが実際に存在するか確認します。

### 3. Get-FileHash

```powershell
Get-FileHash -LiteralPath $resolvedPath -Algorithm SHA256
```

ファイル内容からSHA-256ハッシュを計算します。

## 改造してみる

`SHA256` を `SHA512` に変更して、結果がどう変わるか試すこともできます。

```powershell
Get-FileHash -LiteralPath $resolvedPath -Algorithm SHA512
```

## 注意点

ハッシュ値が一致することは「ファイル内容が同じである」ことの確認には役立ちますが、
それだけでファイルの安全性や作成者の信頼性まで保証するものではありません。

## 関連記事

papanda925.com に解説記事を追加予定です。
