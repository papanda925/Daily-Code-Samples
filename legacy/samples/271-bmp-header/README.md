# 271: BMPヘッダーを読み取り画像サイズを取り出す

> **短い実験サンプル / 約10〜20分**

## このサンプルで体験すること
短い実験で「BMPヘッダーを読み取り画像サイズを取り出す」を体験し、操作前後の状態やログの差を確認する。

## 実行方法
1. `demo.ps1` を読む。
2. 自分のPC・自分のテストデータで実行。
3. 入力や設定を1つだけ変えて再実行し、結果の違いを見る。

## 最小コード
```powershell
param([string]$Path);if(!$Path){throw'自分のBMPを-Path指定'};$b=[IO.File]::ReadAllBytes($Path);[pscustomobject]@{Signature=[Text.Encoding]::ASCII.GetString($b,0,2);Width=[BitConverter]::ToInt32($b,18);Height=[BitConverter]::ToInt32($b,22)}
```

## 見るポイント
- 文字・ファイル・デバイスが、見た目から型・バイト・APIへどう変換されるか。
- VBAとPowerShellで同じ概念を表したときの添字・型・引数・戻り値の違い。
- 古い仕組みが現在のシステムの基礎としてどこに残っているか。

## 技術の層
```text
VBA / PowerShell → byte[] / Encoding → File
```

## 安全性
原則として読み取り・一時ファイル・ダミーデータのみ。実業務の固定長データや認証情報は使いません。全銀関連は教育用の「全銀風」ダミーです。

## 発展
同じ処理を別言語・別APIでも実装し、「便利な上位APIの下で何が行われているか」まで追ってみてください。
