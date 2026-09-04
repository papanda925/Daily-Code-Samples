# Daily Code Samples

**仕事の「ちょっと困った」を、PC・Officeの小さな工夫で解決する実用サンプル集です。**

Windows、Excel、Word、PowerPoint、PowerShell、VBA、Power Query などを使い、
**技術名ではなく「何をしたいか」から探せる**ことを大切にしています。

### まずはこちら

| 入口 | できること |
|---|---|
| **[🔎 Daily Code を検索](https://papanda925.github.io/Daily-Code-Samples/)** | 「CSV」「未処理」「音が出ない」など、困りごとからサンプルを検索 |
| **[📝 papanda925.com](https://papanda925.com/)** | 実際に調べたこと・試したことを詳しい記事で読む |
| **[🏠 papanda925 Portfolio](https://papanda925.github.io/)** | 公開プロジェクト全体の入口 |
| **[💻 GitHub @papanda925](https://github.com/papanda925)** | VBA / PowerShell / AI / API など他のコードを見る |

> **プログラミングを勉強すること自体が目的ではありません。**  
> 「こんなことまでPCにやらせられるの？」を1日1つ増やしていくことを目指しています。

### 今あるサンプル

**11本公開中** — Windows / Excel / Word / PowerPoint / PowerShell / VBA / Power Query

**[検索ページを開く →](https://papanda925.github.io/Daily-Code-Samples/)**

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

| No. | やりたいこと | 方法 | 目安 |
|---:|---|---|:---:|
| [001](./samples/001-powershell-sha256/) | 2つのファイルが本当に同じ内容か確認したい | PowerShell | 🟢 |
| [002](./samples/002-windows-clipboard-history/) | コピーした文字をあとから呼び出したい | GUI | 🟢 |
| [003](./samples/003-windows-sound-output/) | 音が出ないときに出力先を確認したい | GUI | 🟢 |
| [004](./samples/004-windows-display-scale/) | 文字が小さいときに画面を見やすくしたい | GUI | 🟢 |
| [010](./samples/010-powershell-file-list-csv/) | フォルダー内のファイル一覧をExcelで見たい | PowerShell | 🟡 |

## 📊 Excelの作業を楽にしたい

| No. | やりたいこと | 方法 | 目安 |
|---:|---|---|:---:|
| [005](./samples/005-excel-filter-pending/) | 未処理の行だけ別の場所に表示したい | FILTER | 🟢 |
| [006](./samples/006-excel-xlookup-master/) | コードから名前や部署を自動表示したい | XLOOKUP | 🟢 |
| [007](./samples/007-powerquery-combine-csv/) | 同じ形式のCSVをまとめて1つの表にしたい | Power Query | 🟡 |
| [010](./samples/010-powershell-file-list-csv/) | フォルダー内のファイル一覧をExcelで見たい | PowerShell | 🟡 |
| [011](./samples/011-excel-vba-autofit-selection/) | 選択範囲だけ列幅を自動で見やすくしたい | VBA | 🟡 |

## 📝 Wordの作業を楽にしたい

| No. | やりたいこと | 方法 | 目安 |
|---:|---|---|:---:|
| [008](./samples/008-word-navigation-pane/) | 長い文書で目的の場所へすぐ移動したい | GUI | 🟢 |

## 📽 PowerPointの作業を楽にしたい

| No. | やりたいこと | 方法 | 目安 |
|---:|---|---|:---:|
| [009](./samples/009-powerpoint-align-objects/) | 図や画像をきれいに揃えたい | GUI | 🟢 |

## 🔁 繰り返し作業を自動化したい

#005〜#011では、Excel関数、Power Query、PowerShell、VBAなどへ少しずつ広げています。最初はGUIや1行の式から入り、「10件、100件なら自動化すると楽」という流れを重視します。

## 🔍 設定や状態を確認したい

#001、#003、#004のように、まずGUIや簡単な確認方法で現在状態を知るテーマも扱います。今後はネットワーク、PC情報、Office環境などへ広げます。

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
| [002](./samples/002-windows-clipboard-history/) | 2026-09-04 | PC・Windows | コピーした文字をあとから呼び出したい | Windows | 🖱 🧪 | 🟢 | 準備中 |
| [003](./samples/003-windows-sound-output/) | 2026-09-04 | PC・トラブル確認 | 音が出ないときに出力先を確認したい | Windows | 🖱 🧪 | 🟢 | 準備中 |
| [004](./samples/004-windows-display-scale/) | 2026-09-04 | PC・設定確認 | 文字が小さいときに画面を見やすくしたい | Windows | 🖱 🧪 | 🟢 | 準備中 |
| [005](./samples/005-excel-filter-pending/) | 2026-09-04 | Excel・抽出 | 未処理の行だけ別の場所に表示したい | Excel | 📋 🧪 | 🟢 | 準備中 |
| [006](./samples/006-excel-xlookup-master/) | 2026-09-04 | Excel・検索 | コードから名前や部署を自動表示したい | Excel | 📋 🧪 | 🟢 | 準備中 |
| [007](./samples/007-powerquery-combine-csv/) | 2026-09-04 | Excel・自動化 | 同じ形式のCSVをまとめて1つの表にしたい | Excel / Power Query | 🖱 📋 ⚙ | 🟡 | 準備中 |
| [008](./samples/008-word-navigation-pane/) | 2026-09-04 | Word・文書整理 | 長いWord文書で目的の場所へすぐ移動したい | Word | 🖱 🧪 | 🟢 | 準備中 |
| [009](./samples/009-powerpoint-align-objects/) | 2026-09-04 | PowerPoint・書式整理 | PowerPointの図や画像をきれいに揃えたい | PowerPoint | 🖱 🧪 | 🟢 | 準備中 |
| [010](./samples/010-powershell-file-list-csv/) | 2026-09-04 | ファイル・自動化 | フォルダー内のファイル一覧をExcelで見たい | Windows / PowerShell / Excel | 📋 ⚙ 🧪 | 🟡 | 準備中 |
| [011](./samples/011-excel-vba-autofit-selection/) | 2026-09-04 | Excel・自動化 | Excelの選択範囲だけ列幅を自動で見やすくしたい | Excel / VBA | 🖱 📋 ⚙ | 🟡 | 準備中 |

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
