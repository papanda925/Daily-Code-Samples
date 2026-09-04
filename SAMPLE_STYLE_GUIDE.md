# Daily Code 作成ガイド

Daily Code Samples は、**「まず使える」から入り、興味があればOS・Windows・ネットワーク・セキュリティ・アーキテクチャまで深掘りできる短い教材集**です。

読者は、事務職・PC初心者だけでなく、学生・初学者・「仕組みまで知りたい」エンジニア学習者も想定します。

## 2つの入口

### Daily Practical

仕事の「ちょっと困った」を解決するサンプルです。

- Excel / Word / PowerPoint / Outlook / Teams
- Windowsの設定確認
- PowerShell / VBAによる小さな自動化
- GUIでできることは、まずGUIから紹介

### Engineering Lab

OSやPCの仕組みを、**目で見て・操作して・差をトレースして理解する**サンプルです。

- Process / Thread / HWND / Event Loop
- USB / Bluetooth / Display / Battery
- Wi-Fi / DNS / TCP / UDP
- Hash / 暗号 / 電子署名 / TLS
- WinRT / .NET / Win32 / COM
- Blockchain / Queue / State Machine / DI
- 固定長 / 全銀風ダミー / Hex / Encoding
- VBAとPowerShellの文法比較

## 最重要ルール

### 1. 1サンプル = 1概念

1本を大きくしすぎません。目安は **5〜30分で試せる大きさ**です。

### 2. Trace First

Engineering Labでは、できる限り次の順序にします。

```text
今の状態を見る
      ↓
1つだけ操作する
      ↓
もう一度状態を見る
      ↓
差分・ログを見る
      ↓
裏で使われた技術の層を知る
```

### 3. コメントは「何を」だけでなく「なぜ」を書く

悪い例：

```powershell
# ファイルを読む
$bytes = [IO.File]::ReadAllBytes($Path)
```

良い例：

```powershell
# Hex表示では文字列として読むと文字コード変換が入ってしまいます。
# 元のバイト値をそのまま観察したいので、ReadAllBytes を使います。
$bytes = [IO.File]::ReadAllBytes($Path)
```

短いコードでも、**処理の目的・理由・注意点がコードだけを読んでも分かる**ようにします。

### 4. 解説をコードの外にも置く

READMEには、最低限次を含めます。

1. このサンプルで体験すること / こんなときに使える
2. なぜこの方法を使うのか
3. 実行前に確認すること
4. 実行手順
5. 最小コード
6. コードの流れ
7. 結果の見方
8. テスト1
9. テスト2
10. うまくいかないとき
11. 安全性・PCへの変更
12. 今回触った技術の層
13. 発展

### 5. 「動いた」で終わらせない

最低2つ、自分で試せるテストを入れます。

例：

- 値を1つ変えて結果が変わるか
- 操作前後でIDや状態が変わるか
- 失敗条件をわざと作り、想定したエラーになるか

## 新規サンプルのコード品質

新しく作るサンプルでは次を基本とします。

- PowerShellは可能なら Windows PowerShell 5.1 / PowerShell 7 のどちらを想定するか明記
- VBAは標準モジュール / クラスモジュールのどちらに置くか明記
- Win32 / COM / WinRT / .NET を使う場合は「なぜその層を使うか」を説明
- 外部サービスを使わずにできる場合は、Windows / Office標準機能を優先
- 管理者権限が必要な操作は避け、必要なら理由と戻し方を明記
- 他人のPC、許可されていないネットワーク、実際の秘密情報を教材に使わない
- 全銀関連は実データではなく教育用の「全銀風」ダミーを使う
- 一時ファイルを作る場合は保存先と削除方法を書く
- 実行結果を読者が自分で判定できるようにする

## maturity

`sample.json` では、学習用の成熟度を記録します。

- `experimental`：仕組みを体験する短い実験。環境差の確認が必要
- `stable`：手順・コード・テストを十分確認した実用サンプル

新規自動生成サンプルは、原則 `experimental` から開始します。

## article_ready

- `false`：GitHub教材として公開するが、ブログ自動記事化はまだ行わない
- `true`：レビュー済みでブログ記事化してよい

新規自動生成では **falseを既定**にし、レビュー後にtrueへ変更します。

## sample.json の最低項目

- id
- title
- summary
- status
- maturity
- article_ready
- track
- audience
- apps
- methods
- level
- estimated_minutes
- changes_pc_settings
- requires_admin
- safety_scope
- tags

## READMEのタイトル

Practicalは「やりたいこと」をそのままタイトルにします。

Engineering Labは、専門用語だけでなく **何を観察するのか** が分かるタイトルにします。

良い例：

- ウィンドウには番号がある？ HWNDを実際に見る
- 1文字変えるとSHA-256はどれだけ変わる？
- Wi-FiのSSID・BSSID・Channelを同時に見る
- VBAでDoEventsは非同期処理なのか確認する

## 自動生成時の追加ルール

#301以降を1日1本ずつ追加する処理では、次を必須とします。

- 既存300本と同じテーマを重複させない
- Trackを偏らせずローテーションする
- README + sample.json + 実コードを作る
- TODOや「後で実装」は残さない
- コードには複数の説明コメントを入れる
- テスト1 / テスト2を書く
- `tools/validate_sample.py --strict` を通す
- Public safety checkを通す
- 検証に失敗した場合はmainへpushしない
