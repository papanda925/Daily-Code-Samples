# Papanda Character Sheet v1 — アイキャッチ量産フロー

このサンプルは、`papanda925 Character Sheet v1` を**キャラクターの正本**として固定し、記事テーマごとに背景・小物・ポーズだけを変えるための運用メモです。

## 正本

- Character Sheet: https://papanda925.github.io/Daily-Code-Samples/assets/papanda925-character-sheet-v1.png
- Character Source: ../papanda-manga-viewer/CHARACTER_SOURCE.md

## 固定するもの

- 顔立ち
- 2〜3頭身の体型
- 顔・おなかのクリーム色 `#FFF8F0`
- 耳・目のまわり・手足のダークブラウン `#4A3425`
- 目・鼻 `#222222`
- ほっぺ `#FFD7C2`
- 大きめでツヤのある目
- 小さな口
- やさしいアニメ・ちびキャラ調

## 変えてよいもの

- 記事テーマ
- 背景
- 小物
- 表情
- ポーズ
- 技術カテゴリを表すモチーフ
- 短い見出し文字

## 共通プロンプト

```text
添付の papanda925 Character Sheet v1 をキャラクターの正本として使う。
Papandaの顔立ち、体型、配色、目、ほっぺ、アニメ調は維持する。
今回の記事テーマは「{ARTICLE_THEME}」。
背景、小物、ポーズ、表情だけをテーマに合わせて変える。
ブログのアイキャッチとして、縮小しても主題が分かる構図にする。
文字を入れる場合は短くし、記事タイトル全文を画像へ詰め込まない。
```

## 3テーマの差分例

### PowerShell

```text
ARTICLE_THEME = PowerShellでWindowsを操作する
背景はデスクトップPCとターミナル。
PapandaはノートPCを操作し、画面には短いPowerShellコードを表示する。
青系のアクセントを使う。
```

### Excel

```text
ARTICLE_THEME = Excelでデータを整理する
背景は表計算シートと簡単なグラフ。
Papandaは表を指し示すポーズ。
緑系の表計算モチーフを小物として使う。
```

### GitHub / AI

```text
ARTICLE_THEME = GitHubと生成AIで記事制作を自動化する
背景はコード、Gitの分岐、AIを連想する抽象的なUI。
Papandaは説明する・うれしい表情。
青〜水色のアクセントを使う。
```

## ファイル名

```text
assets/eyecatch/YYYYMMDD-<slug>-eyecatch.png
```

例:

```text
assets/eyecatch/20260913-powershell-console-eyecatch.png
assets/eyecatch/20260913-excel-data-eyecatch.png
assets/eyecatch/20260913-github-ai-eyecatch.png
```

## 生成後チェック

1. 顔の輪郭が別キャラ化していないか
2. 耳・目のまわり・手足がダークブラウン基調か
3. 目の形・ツヤ・ほっぺが正本と大きくズレていないか
4. 2〜3頭身の体型が維持されているか
5. テーマを表す小物が1〜2個に絞られているか
6. 縮小してもPapandaと記事テーマが判別できるか
7. 文字を詰め込みすぎていないか
8. 直近のアイキャッチと背景・ポーズが似すぎていないか

## 似た画像ばかりにしないための可変軸

毎回すべてを変えるのではなく、次のうち2〜3軸だけを変えます。

- カメラ: 正面 / 斜め / 少し引き
- ポーズ: PC操作 / 指し示す / 考える / 驚く
- 背景: デスク / UI / 抽象図 / 書類
- 小物: PC / スマホ / 表 / コード / Git
- 構図: 左にPapanda / 右にPapanda / 中央

キャラクター自体を変化させるのではなく、**シーン側でバリエーションを作る**のが基本です。

## 検証状態

このREADMEでは正本・固定/可変ルール・プロンプト・命名規則を整理しています。PowerShell / Excel / GitHub・AI の3テーマについて、同一条件でAI画像を3枚生成した実画像比較はこのファイル作成時点では未実施です。生成していない画像を生成済みとして扱いません。
