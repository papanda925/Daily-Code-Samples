# chmod 600・644・755を一時ファイルで観察する

`mktemp` で作った一時ファイルだけに `chmod` を実行し、`stat` の `%a`（数値）と `%A`（rwx表示）を並べます。本番ファイルは変更しません。

## 成功条件

600 → 644 → 755 と変更するたびに `numeric=` と `symbolic=` が対応して変化し、最後に `[SUCCESS]` が出ることです。

## 実行

```bash
bash demo-permissions.sh
```

## 1か所変えてみる

`chmod 640` を追加し、owner/group/otherのどこが変わるか予想してから `stat` を見ます。

## 検証状態

2026-09-07、Debian GNU/Linux 13 / Bash 5.2.37 / GNU coreutils 9.7 で実行確認済み。Ubuntu実機では別途未確認です。

## 公式情報

- GNU Coreutils — chmod: https://www.gnu.org/software/coreutils/manual/html_node/chmod-invocation.html
- GNU Coreutils — stat: https://www.gnu.org/software/coreutils/manual/html_node/stat-invocation.html
