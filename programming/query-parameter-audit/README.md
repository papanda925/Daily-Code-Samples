# URLクエリの重複キー・空値をローカルで検査する（Python）

`?tag=one&tag=two&empty=` のような**架空のクエリ部分**を検査し、同じキーが繰り返された回数と空の値を数える教材です。値・キー名は表示しません。HTTPリクエスト、ファイル更新、外部API呼び出しはありません。

## 前提環境

- Python 3.10以降（標準ライブラリのみ）。実測：Linux / Python 3.13.5、2026-10-28。
- 管理者権限・追加パッケージ・ネットワーク接続は不要です。
- Windows/macOSは未実測。Windowsでは `py -3`、macOS/Linuxでは `python3` を適宜使用してください。
- **実際のURL、認証トークン、個人情報を `--query` に渡さないでください。** コマンドライン引数はOSのプロセス一覧やシェル履歴に残ることがあります。まず以下のダミー文字列で試してください。

## ファイル

- `audit_query.py`：入力を変更せずに解析するCLI。キー名・値は出力しません。
- `test_audit_query.py`：ダミー入力による18件の単体テスト。

## まず試す

このディレクトリで次を実行します。

```bash
python3 audit_query.py --query 'tag=one&tag=two&empty='
```

**実測出力**（Linux / Python 3.13.5、終了コード0）：

```text
STATUS=VALID FIELDS=3 UNIQUE_KEYS=2 DUPLICATE_KEYS=1 EXTRA_OCCURRENCES=1 BLANK_VALUES=1
```

`DUPLICATE_KEYS`は2回以上現れた**異なるキー名の個数**、`EXTRA_OCCURRENCES`は各キーの2回目以降の**合計出現回数**です。`BLANK_VALUES`は空文字列の値を持つフィールド数です。

## 1か所変える：不正な%エスケープ

```bash
python3 audit_query.py --query 'a=%ZZ'
```

**実測出力**（終了コード2）：

```text
STATUS=INVALID ISSUE=INVALID_PERCENT_ESCAPE
```

## 比較のポイント

- `parse_qsl()`は辞書ではなく**順序付きのキー・値ペア**を返すため、重複キーを消さずに検査できます。
- `keep_blank_values=True` で `empty=` を保持します。既定値では空値が落ちることがあります。
- `strict_parsing=True` と `errors='strict'` で形式・UTF-8の問題を検出します。
- Pythonの `parse_qsl()` は不正な `%ZZ` を必ずしも拒否しないため、教材独自のパーセントエスケープ検査を追加しています。
- 区切り文字は `&` のみです。`;` は区切りとして扱いません。`+` はスペースとして、`%2B` は `+` としてデコードされます。
- 入力上限4096文字・100フィールドは教材独自の資源保護設定です。Web規格上の制限ではありません。

## テスト

```bash
python3 -m unittest discover -p 'test_*.py' -v
python3 -m py_compile audit_query.py test_audit_query.py
```

**2026-10-28 実測：** Linux / Python 3.13.5、18テストPASS、構文検査PASS、CLI正常系exit 0、異常系exit 2。Codex CLIは利用できず実行していません。GitHub Actionsも実行していません。Windows/macOSは未検証です。

## 失敗時の切り分け

| 表示・症状 | 確認すること |
| --- | --- |
| `python3` が見つからない | Python 3.10以降がインストールされているか。Windowsでは `py -3` を試す。 |
| `INVALID_PERCENT_ESCAPE` | `%` の後に16進数2桁があるか。値の中身は表示しません。 |
| `INVALID_UTF8` | `%FF` のようなUTF-8として不正なバイト列がないか。 |
| `INVALID_FIELD` | `a=1&b` や `&&` のように `=` のない項目がないか。 |
| `EMPTY_KEY` | `=value` のようにキー名が空でないか。 |
| `FIELD_LIMIT` / `QUERY_TOO_LONG` | 入力上限100フィールド/4096文字を超えていないか。 |
| 予想と違う重複数 | キー名の大小文字、`%61` と `a` の同一性、`&` 区切りを確認。 |

## 仕事で使う場合の注意

これは**形式・重複数の教材**であり、URLの安全性、認可、署名検証、アプリケーションのパラメータ解釈を保証しません。Webサーバーやフレームワークごとに重複キーの採用規則が異なる場合があります。`--query`はシェル履歴に残るため実データの監査用途へそのまま転用せず、入力経路と記録方針を別途設計してください。

## 公式資料

- [Python 3.13 `urllib.parse.parse_qsl`](https://docs.python.org/3.13/library/urllib.parse.html#urllib.parse.parse_qsl)
- [Python 3.13 `argparse`](https://docs.python.org/3.13/library/argparse.html)
- [Python 3.13 `unittest`](https://docs.python.org/3.13/library/unittest.html)
