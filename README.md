# Daily-Code-Samples

小さく試せる実用コードや業務TIPSを、1日1サンプルを目安に追加していく学習用リポジトリです。

VBA、PowerShell、JavaScript、Python に加えて、Power Query、モダンExcel、Word、PowerPoint、Power Automate、Power Automate Desktop、Power Apps、Power BI なども対象にします。初心者・事務処理担当者が「動かして、処理を追って、少し改造できる」ことを重視します。

## このリポジトリの方針

- 1サンプル = 1テーマ
- 日常の事務処理でそのまま試せる内容を優先
- できるだけ短く、単独で試せるコード・式・手順
- 初心者向けに日本語コメントと説明を多めに記載
- README に「何ができるか」「どんな業務に役立つか」「処理の流れ」「実行方法」「注意点」を記載
- 大きく育ったテーマは、必要に応じて独立リポジトリへ発展
- papanda925.com の解説記事と自動連携

## 対象テーマ

- VBA / PowerShell / JavaScript / Python
- Power Query / M言語
- モダンExcel（動的配列、LET、LAMBDA、XLOOKUP、FILTER、TEXTSPLIT など）
- Word / PowerPoint の業務TIPS・自動化
- Power Automate / Power Automate Desktop
- Power Apps / Power BI
- Microsoft 365を使った事務処理の効率化

## サンプル一覧

| No. | 公開日 | 言語 | テーマ | 難易度 | ブログ |
|---:|:---:|---|---|:---:|---|
| 001 | 2026-09-04 | PowerShell | ファイルの SHA-256 ハッシュを確認する | ★☆☆ | 準備中 |

## ディレクトリ構成

```text
Daily-Code-Samples/
├─ README.md
├─ LICENSE
├─ automation/
│  └─ ubuntu/
│     ├─ README.md
│     ├─ install.sh
│     ├─ dispatch_with_daily_code.sh
│     └─ run_daily_code_once.py
└─ samples/
   └─ 001-powershell-sha256/
      ├─ README.md
      └─ Get-FileSha256.ps1
```

## papanda925.com 自動連携

Ubuntu上の既存ブログ生成環境と連携し、14:00の1スロットを Daily Code 専用枠として利用できるようにしています。

処理の流れは次のとおりです。

```text
GitHub更新
  ↓
Ubuntuでgit pull
  ↓
未記事化サンプルを検出
  ↓
README + ソースから記事Markdownを生成
  ↓
new_gemini_postbot の Gutenberg serializer で変換
  ↓
WordPressへ公開
  ↓
記事URLを取得
  ↓
GitHub READMEへ記事URLを書き戻し
  ↓
git commit / push
```

導入手順は [automation/ubuntu/README.md](./automation/ubuntu/README.md) を参照してください。

## 想定する読者

- プログラミングを始めたばかりの方
- ExcelやOfficeを使う事務処理担当者
- VBA や PowerShell を仕事で少し使ってみたい方
- Power QueryやPower Automateで定型作業を減らしたい方
- サンプルを動かしながら仕組みを理解したい方

## ライセンス

MIT License です。詳しくは [LICENSE](./LICENSE) を参照してください。

## 関連リンク

- GitHub Pages: https://papanda925.github.io/
- Blog: https://papanda925.com/
