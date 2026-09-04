# Daily-Code-Samples

**「プログラミングを勉強する」より先に、「毎日の仕事をちょっと楽にする」ためのサンプル集です。**

Excel、Word、PowerPoint、Windows、Power Query、Power Automate など、オフィスワーカーが普段使う道具を中心に扱います。

難しいコードから始めません。

- まずは画面操作だけでできる方法
- 次に、コピー＆ペーストで試せる方法
- さらに便利にしたい人向けに、PowerShell や VBA での確認・自動化

という順番を基本にします。

> 「こんなことまでPCにやらせられるの？」を1日1つ増やしていくことが目標です。

---

## こんな人向け

- ExcelやWordを毎日使っている事務職・オフィスワーカー
- PCは使えるけれど、プログラミングはやったことがない方
- 同じ作業を何度も繰り返している方
- Windowsの便利な機能をもっと知りたい方
- VBA、PowerShell、Power Query、Power Automateを少しだけ試してみたい方

**エンジニア向けのコード集ではありません。**

---

# 何をしたいですか？

## 🖥 PC・Windowsを便利に使いたい

画面、音、ファイル、フォルダ、クリップボード、検索、バックアップ、設定確認など。

| No. | やりたいこと | 方法 | 目安 |
|---:|---|---|:---:|
| [001](./samples/001-powershell-sha256/) | 2つのファイルが本当に同じ内容か確認したい | Windows + PowerShell | 🟢 |

## 📊 Excelの作業を楽にしたい

今後、次のようなテーマを追加します。

- FILTER / XLOOKUP / LET などのモダンExcel
- 複数ファイルの集計
- 表の整形
- 条件付き書式
- 日付・営業日処理
- Power Query
- VBAによる繰り返し作業の自動化

## 📝 Wordの作業を楽にしたい

- 書式を揃える
- 定型文書を作る
- 差し込み
- 複数ファイルの処理
- VBAやPowerShellからWordを操作する

## 📽 PowerPointの作業を楽にしたい

- 画像サイズを揃える
- スライドの書式を揃える
- 定型資料を作る
- PowerPoint VBAによる自動処理

## 🔁 繰り返し作業を自動化したい

- Power Automate
- Power Automate Desktop
- VBA
- PowerShell
- Power Query
- Microsoft 365

## 🔍 設定や状態を確認したい

GUIで一つずつ確認するだけでなく、PowerShellなどを使って

- Windowsの設定を確認
- ネットワーク状態を確認
- ファイルを確認
- PC情報を確認
- Office環境を確認

といった「確認の自動化」も扱います。

---

# 探し方

サンプルは、**技術名ではなく利用者の目的から探せる**ように分類します。

## 目的別

- 🖥 PC・Windows
- 📁 ファイル・フォルダ
- 📊 Excel
- 📝 Word
- 📽 PowerPoint
- ✉ Outlook・メール
- 💬 Teams
- ☁ OneDrive・SharePoint
- 🔁 定型作業の自動化
- 🔍 設定・状態確認
- 🛠 困ったとき・トラブル確認
- 🔐 安全確認・セキュリティ基礎

## アプリ・機能別

- Windows
- Excel
- Word
- PowerPoint
- Outlook
- Teams
- Power Query
- Power Automate
- Power Automate Desktop
- Power Apps
- Power BI
- VBA
- PowerShell

## やり方別

| 表示 | 意味 |
|---|---|
| 🖱 GUI | 画面操作だけで試せる |
| 📋 コピペ | コマンドや数式をコピーして試せる |
| ⚙ 自動化 | VBA / PowerShell / Power Automate等で繰り返し作業を減らす |
| 🧪 試して理解 | 自分で結果の違いを確認できる |

## 難しさ

| レベル | 目安 |
|---|---|
| 🟢 はじめて | PCの基本操作ができればOK |
| 🟡 ちょっと応用 | 数式やコマンドをコピーして試す |
| 🔵 一歩進む | コードや設定を少し変更して使う |

---

# サンプル一覧

| No. | 公開日 | 分類 | やりたいこと | アプリ・機能 | 方法 | 難しさ | ブログ |
|---:|:---:|---|---|---|---|:---:|---|
| [001](./samples/001-powershell-sha256/) | 2026-09-04 | ファイル・安全確認 | 2つのファイルが本当に同じ内容か確認したい | Windows / PowerShell | 📋 🧪 | 🟢 | 準備中 |

機械的な分類情報は [catalog/samples.csv](./catalog/samples.csv) と各サンプルの `sample.json` にも保存します。将来、GitHub Pagesなどで絞り込み・並べ替えできる一覧へ発展させられる構造です。

---

# 001から試す

最初のサンプルは、難しい「SHA-256の勉強」ではありません。

**「同じ名前のファイルが2つあるけど、本当に中身も同じ？」**

をWindows標準のPowerShellで確かめます。

[▶ 001: 2つのファイルが本当に同じ内容か確認する](./samples/001-powershell-sha256/)

---

# サンプルの基本構成

各テーマはできるだけ次の順番で説明します。

1. こんなときに使える
2. まず画面操作でできること
3. もっと確実・便利にする方法
4. コピーして試す
5. 実際に自分でテストする
6. 結果を見る
7. うまくいかないとき
8. 少しだけ応用する
9. 仕組みを知りたい人向けの解説

**「仕組みの説明」より「まず使える」を先にします。**

---

# GitHub → WordPress 自動連携サンプル

このリポジトリには、GitHubに追加したサンプルをUbuntuで検出し、WordPressの記事へ変換して、記事URLをGitHubへ書き戻す自動連携の**汎用サンプル**も含めています。

```text
GitHubにサンプル追加
  ↓
Ubuntuでgit pull
  ↓
未記事化サンプルを検出
  ↓
README + 必要なファイルからブログ記事を生成
  ↓
WordPress向けGutenberg形式へ変換
  ↓
WordPressへ投稿
  ↓
記事URLをGitHubへ書き戻す
```

公開リポジトリには、本番サーバーのIPアドレス、Linuxユーザー名、実ディレクトリ、実際のsystemd service名、パスワード、token、秘密鍵などを保存しません。

公開サンプルの既定はWordPressの **draft（下書き）** です。完全自動公開にする場合は、本番Ubuntu側だけに置く非公開設定で `publish` へ切り替えます。

詳しくは [automation/ubuntu/README.md](./automation/ubuntu/README.md) と [SECURITY.md](./SECURITY.md) を参照してください。

---

## ライセンス

MIT License。詳しくは [LICENSE](./LICENSE) を参照してください。

## 関連リンク

- GitHub Pages: https://papanda925.github.io/
- Blog: https://papanda925.com/
