# dfとduの数字が違う理由を観察する

## まず試す

```bash
set -u
TARGET="${1:-$HOME}"
echo "[START] filesystem usage"
df -h "$TARGET"
echo
echo "[START] directory usage"
du -sh "$TARGET" 2>&1 || true
echo "[RESULT] dfはファイルシステム全体、duは辿れたファイルを集計します"
```

## ここを見る

`df` と `du` は測っている対象が違うため、数字が一致しないことがあります。

## 1か所変える

TARGETを自分のホーム配下の小さなディレクトリへ変えます。

## 仕事で使うなら

容量逼迫時は、削除済みでもプロセスが開いたままのファイル、権限で辿れない場所、別マウント等も確認します。いきなり削除せず、まず読み取り専用で原因を切り分けます。

検証状態: コマンド作成済み・Ubuntu実機未確認。
