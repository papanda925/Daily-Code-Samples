# 155: DPAPIで自分のテスト文字列を暗号化・復号する

> **実験サンプル / 深掘り / 約10〜25分**

## このサンプルで体験すること
短い実験で「DPAPIで自分のテスト文字列を暗号化・復号する」を体験し、操作前後の状態やログの差を確認する。

完成品ライブラリではなく、**仕組みを短いコードで再現し、状態・ログ・差分を見る教材**です。

## 実行
1. `demo.ps1` を読む。
2. 自分のテストデータだけで実行する。
3. 入力を1か所変え、出力・Hash・状態・ログ等の差を比較する。

## 最小コード
```powershell
$d=[Text.Encoding]::UTF8.GetBytes("demo secret");$e=[Security.Cryptography.ProtectedData]::Protect($d,$null,[Security.Cryptography.DataProtectionScope]::CurrentUser);$x=[Security.Cryptography.ProtectedData]::Unprotect($e,$null,[Security.Cryptography.DataProtectionScope]::CurrentUser);"Encrypted="+[Convert]::ToBase64String($e);"Decrypted="+[Text.Encoding]::UTF8.GetString($x)
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
