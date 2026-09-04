# 255: COBOLのPIC風フィールド定義をExcel表から固定長へ変換する

> **短い実験サンプル / 約10〜20分**

## このサンプルで体験すること
短い実験で「COBOLのPIC風フィールド定義をExcel表から固定長へ変換する」を体験し、操作前後の状態やログの差を確認する。

## 実行方法
1. `demo.ps1` を読む。
2. 自分のPC・自分のテストデータで実行。
3. 入力や設定を1つだけ変えて再実行し、結果の違いを見る。

## 最小コード
```powershell
$def=@([pscustomobject]@{Name='Code';Width=4;Align='Right';Pad='0'},[pscustomobject]@{Name='Name';Width=10;Align='Left';Pad=' '});$v=@{Code='25';Name='ABC'};foreach($f in$def){$x=[string]$v[$f.Name];if($f.Align-eq'Right'){$x=$x.PadLeft($f.Width,$f.Pad)}else{$x=$x.PadRight($f.Width,$f.Pad)};$x}
```

## 見るポイント
- 文字・ファイル・デバイスが、見た目から型・バイト・APIへどう変換されるか。
- VBAとPowerShellで同じ概念を表したときの添字・型・引数・戻り値の違い。
- 古い仕組みが現在のシステムの基礎としてどこに残っているか。

## 技術の層
```text
VBA / PowerShell → Text / Encoding / File Format
```

## 安全性
原則として読み取り・一時ファイル・ダミーデータのみ。実業務の固定長データや認証情報は使いません。全銀関連は教育用の「全銀風」ダミーです。

## 発展
同じ処理を別言語・別APIでも実装し、「便利な上位APIの下で何が行われているか」まで追ってみてください。
