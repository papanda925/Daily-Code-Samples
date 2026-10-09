# PythonでCSVを途中失敗に強い方法で置き換える

**Python 3.10以降 / 標準ライブラリのみ。** 毎回ランダム名の一時ディレクトリでデモします。既存の業務CSVにはアクセスしません。

## 実行とテスト

```bash
python3 atomic_csv.py
python3 -m unittest -v test_atomic_csv.py
```

デモの実行結果（ローカルテストで確認）:

```text
[RESULT] rows=2 ids=['A-001', 'A-002']
```

単体テストは、次の3件を実行します。

1. CSVの初回作成・既存CSVの置換
2. 書込み途中に検証エラーが起きた場合、元CSVを保持し、一時ファイルを削除
3. 改行を含むCSVフィールドの適切な引用と読込

## 処理のポイント

- 対象のCSVと**同じディレクトリ**に `NamedTemporaryFile(delete=False)` で一時ファイルを作ります。
- `newline=""` はCSVモジュールが改行を管理するために必要です。
- `DictWriter` で決まった列だけを出力します。フィールド不一致を検出して書込みを中断します。
- ファイルの内容を `flush` と `fsync` で書き出してから一時ファイルを閉じます。
- 書込みが終わってから `os.replace(temporary, target)` で既存ファイルを置き換えます。
- 失敗時は `finally` が作成した一時ファイルを削除します。

## 制約

- `os.replace` の名前の置換はPOSIXでアトミックですが、**突然の電源喪失後のファイルシステム永続性までは保証しません**。必要なら親ディレクトリのfsyncやストレージ構成の検討が必要です。
- 同時書込みを制御するロックはありません。**単一プロセスの書込み**を前提とします。
- Windowsではファイルが他プロセスで開かれていると置換が失敗する場合があります。エラーは隠さず伝えます。
- 書込み先ディレクトリが存在し、書込み権限があることが前提です。
- 既存の業務CSVへ適用する前にバックアップとテストを行ってください。

## 一次情報

- [Python: os.replace](https://docs.python.org/3/library/os.html#os.replace)
- [Python: tempfile.NamedTemporaryFile](https://docs.python.org/3/library/tempfile.html#tempfile.NamedTemporaryFile)
- [Python: csv.DictWriter](https://docs.python.org/3/library/csv.html#csv.DictWriter)
