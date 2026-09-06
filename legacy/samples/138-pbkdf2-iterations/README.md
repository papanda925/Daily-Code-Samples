# 138: PBKDF2の反復回数を増やすと処理時間がどう変わる？

> **実験サンプル / 深掘り / 約10〜25分**

## このサンプルで体験すること
短い実験で「PBKDF2の反復回数を増やすと処理時間がどう変わる」を体験し、操作前後の状態やログの差を確認する。

完成品ライブラリではなく、**仕組みを短いコードで再現し、状態・ログ・差分を見る教材**です。

## 実行
1. `demo.ps1` を読む。
2. 自分のテストデータだけで実行する。
3. 入力を1か所変え、出力・Hash・状態・ログ等の差を比較する。

## 最小コード
```powershell
foreach($n in 1000,10000,100000){$salt=New-Object byte[] 16;$sw=[Diagnostics.Stopwatch]::StartNew();$k=[Security.Cryptography.Rfc2898DeriveBytes]::new("demo",$salt,$n,[Security.Cryptography.HashAlgorithmName]::SHA256);[void]$k.GetBytes(32);$k.Dispose();$sw.Stop();[pscustomobject]@{Iterations=$n;Milliseconds=$sw.ElapsedMilliseconds}}
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
