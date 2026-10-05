# Python pathlibでパス操作を文字列連結から置き換える

`pathlib.Path` の `/` 演算子、`parent`、`suffix`、`name`、`exists()`、`resolve()` を一度に観察する最小サンプルです。

## 実行

```bash
python3 demo.py
```

サンプルは `TemporaryDirectory` 内だけに `data/report.csv` を作るため、既存ファイルを変更しません。

## 観察ポイント

- `base / "data" / "report.csv"` でOSに合ったパスを組み立てる
- `name` はファイル名
- `suffix` は拡張子
- `parent` は親パス
- `exists()` は実ファイルの存在確認
- `resolve()` は絶対パス化とシンボリックリンク等の解決

## 検証状態

Python環境で正常系を実行確認しています。サンプル自身も期待値を検査し、成功時に `[SUCCESS]` を表示します。

## 一次情報

- Python documentation: pathlib — Object-oriented filesystem paths
