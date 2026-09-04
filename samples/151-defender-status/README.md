# 151: Microsoft Defenderの基本状態を読み取り専用で確認する

> **実験サンプル / はじめて / 約10〜25分**

## このサンプルで体験すること
短い実験で「Microsoft Defenderの基本状態を読み取り専用で確認する」を体験し、操作前後の状態やログの差を確認する。

完成品ライブラリではなく、**仕組みを短いコードで再現し、状態・ログ・差分を見る教材**です。

## 実行
1. `demo.ps1` を読む。
2. 自分のテストデータだけで実行する。
3. 入力を1か所変え、出力・Hash・状態・ログ等の差を比較する。

## 最小コード
```powershell
if(Get-Command Get-MpComputerStatus -EA 0){Get-MpComputerStatus|Select AntivirusEnabled,RealTimeProtectionEnabled,AntispywareEnabled,QuickScanAge}else{"Defender cmdlet unavailable"}
```

## 見るポイント
- 同じ入力と違う入力で何が変わるか。
- 状態遷移や設計パターンで、責務をどこへ分けているか。
- セキュリティでは暗号化・Hash・署名・権限など目的の違い。
- VBAではクラス・イベント・COMで言語機能をどう補うか。

## 技術の層
```text
PowerShell → .NET Cryptography / Windows Security → OS
```

## 安全性
攻撃・侵入・認証回避の教材ではありません。自分の文字列、一時ファイル、localhost、自分のWindows設定の観察に限定します。

## 発展
PowerShell版とVBA版を作り比べ、標準機能だけで同じ概念をどこまで再現できるか試してください。
