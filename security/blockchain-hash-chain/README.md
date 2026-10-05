# SHA-256で最小のハッシュチェーンを作る

「前のブロックのハッシュを次のブロックが持つ」という、ブロックチェーンの**チェーン部分だけ**をPowerShellで体験します。

これはBitcoinやEthereumの完全な実装ではありません。分散合意、電子署名、P2Pネットワーク、Proof of Work等は省略しています。

## 実行

```powershell
pwsh ./New-HashChain.ps1
```

Windows PowerShellの場合は、環境に合わせて `powershell.exe` から実行してください。

## 試すこと

1. 3ブロックを作り、正常なチェーンを検証する
2. Block 1のDataだけを変更し、Block 1自身のHash不一致を検出する
3. 改ざん後のBlock 1 Hashだけを再計算する
4. Block 2が古いPreviousHashを持つため、後続リンクの不一致を検出する

2段階に分けることで、「1文字変えればSHA-256が変わる」だけでなく、**前ブロックのdigestを次ブロックが持つ意味**を観察できます。

## 安全性

ダミーの文字列だけをメモリ上で処理します。ファイル、ネットワーク、暗号資産ウォレットには触れません。

## 検証状態

NIST SHA-256仕様とBitcoinのprevious block hashの構造を確認しています。PowerShell実機での実行確認は未実施です。
