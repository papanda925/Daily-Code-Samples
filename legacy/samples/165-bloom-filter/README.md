# 165: Bloom Filterで「たぶんある／絶対ない」を体験する

> **実験サンプル / 深掘り / 約10〜25分**

## このサンプルで体験すること
短い実験で「Bloom Filterで「たぶんある／絶対ない」を体験する」を体験し、操作前後の状態やログの差を確認する。

完成品ライブラリではなく、**仕組みを短いコードで再現し、状態・ログ・差分を見る教材**です。

## 実行
1. `demo.ps1` を読む。
2. 自分のテストデータだけで実行する。
3. 入力を1か所変え、出力・Hash・状態・ログ等の差を比較する。

## 最小コード
```powershell
$bits=New-Object bool[] 32;function I([string]$s,[int]$salt){[math]::Abs(($s.GetHashCode()+$salt)%$bits.Length)};function A($s){1,17|%{$bits[(I $s $_)]=$true}};function M($s){-not(1,17|?{-not$bits[(I $s $_)]})};'apple','orange','grape'|%{A $_};'apple','banana','grape','melon'|%{[pscustomobject]@{Value=$_;MaybePresent=(M $_)}}
```

## 見るポイント
- 同じ入力と違う入力で何が変わるか。
- 状態遷移や設計パターンで、責務をどこへ分けているか。
- セキュリティでは暗号化・Hash・署名・権限など目的の違い。
- VBAではクラス・イベント・COMで言語機能をどう補うか。

## 技術の層
```text
VBA / PowerShell → Pattern / Algorithm → Architecture concepts
```

## 安全性
攻撃・侵入・認証回避の教材ではありません。自分の文字列、一時ファイル、localhost、自分のWindows設定の観察に限定します。

## 発展
PowerShell版とVBA版を作り比べ、標準機能だけで同じ概念をどこまで再現できるか試してください。
