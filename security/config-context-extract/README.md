# AIへ渡す設定ファイルを「必要箇所だけ」に減らす

設定ファイル全体を渡す前に、`grep -F -B -A` で問題に関係する文字列の前後だけを抽出します。元ファイルは変更しません。

## 実行

```bash
bash extract-config-context.sh ./nginx.conf proxy_pass 3
```

## 成功条件

- 対象文字列の前後だけ表示される
- 元ファイルは変更されない
- `password` / `token` / `api_key` 等らしいキーが抽出結果にあれば `[WARNING]` が出る

## 重要

抽出しただけで安全になったとは限りません。**extract -> mask -> human review -> share** の順にし、最終目視を残します。

## 1か所変えてみる

context-linesを `3` から `1` へ変え、AIへ渡す情報量がどう減るか確認します。

## 検証状態

2026-09-07、Debian GNU/Linux 13 / Bash 5.2.37 / GNU grep 3.11 でダミー設定を使って実行確認済み。元ファイルを変更しないことも確認済みです。

## 公式情報

- GNU grep — Context Line Control: https://www.gnu.org/software/grep/manual/html_node/Context-Line-Control.html
