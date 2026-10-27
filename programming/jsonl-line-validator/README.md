# PythonでJSON Linesの壊れた行を見つける（読み取り専用）

JSON Lines（`.jsonl`）のファイルを1行ずつ検査し、**内容を表示せずに行番号とエラー種別だけ**を出力する教材です。標準ライブラリのみ使用し、入力ファイルの書換え・ネットワーク接続は行いません。

## 前提環境

- Python 3.9以降（追加パッケージ不要）。今回の実測はLinux / Python 3.13.5。
- Windows/macOSは未実機確認。通常ユーザー権限で実行可能です。
- 読み取り対象は自分で用意した架空データから始めてください。

## まず試す

サンプルディレクトリで次を実行します。最初にテスト用のJSONLを作るコマンドは**自分で指定した一時的なファイルだけ**を書き込みます。既存の同名ファイルがあると上書きするため、作業用の新規ディレクトリを使ってください。

```bash
python3 -c "from pathlib import Path; Path('demo.jsonl').write_text('{\"id\":1}\n{bad}\n{\"id\":3}\n', encoding='utf-8')"
python3 check_jsonl.py demo.jsonl
```

2行目だけが不正なため、終了コードは`2`で、次の表示になります。

```text
LINE=2 ISSUE=INVALID_JSON
STATUS=INVALID VALID=2 READ=3 ERRORS=1
```

正常な内容を試す場合は、**別名**で `good.jsonl` を作って実行してください。

```bash
python3 -c "from pathlib import Path; Path('good.jsonl').write_text('{\"id\":1}\n{\"id\":2}\n', encoding='utf-8')"
python3 check_jsonl.py good.jsonl
```

期待結果：`STATUS=VALID VALID=2 READ=2 ERRORS=0`、終了コード`0`。

## ここを見る

- `LINE`：問題がある物理行の番号。先頭は1。
- `ISSUE`：`INVALID_JSON` / `INVALID_UTF8` / `BLANK_LINE` / `UTF8_BOM` / `NONFINITE_NUMBER` / `LINE_TOO_LONG` / `EMPTY_FILE`。
- `VALID`：JSONとして読めた行数。**BOMがある行は内容が読めてもファイル全体はINVALID**。
- `READ`：検査で読み取った行数。エラー数上限や行長制限に達すると途中終了します。
- `ERRORS`：検出した問題数。未検査部分がある場合は総エラー数ではありません。

## 1か所変える

`demo.jsonl` の2行目を `null` に変更します。JSON Linesはオブジェクトだけでなく`null`も有効なJSON値なので、結果はVALIDになります。空行は無効です。

## 失敗時の切り分け

| 状況 | 確認点 |
| --- | --- |
| `STATUS=READ_ERROR` / exit 3 | ファイルの存在、アクセス権、ディレクトリを指定していないかを確認。実パスは表示しません。 |
| `INVALID_UTF8` | ファイルがUTF-8かを確認。自動変換はしません。 |
| `UTF8_BOM` | JSON Lines形式はBOMを許容しません。変換するなら元ファイルを保存して別名で実施。 |
| `NONFINITE_NUMBER` | Pythonのjson.loads既定値はNaN/Infinityを受け入れ得るため、この教材は明示的に拒否します。 |
| `LINE_TOO_LONG` | 1行1MiBを超える入力を検出したら安全のためその場で停止。1行制限は教材独自の資源保護方針です。 |
| `EMPTY_FILE` | 教材の運用方針として空ファイルを不合格にします。JSON Linesの形式規則自体が空ファイルを禁止すると断定するものではありません。 |

## テスト

```bash
python3 -m unittest discover -p 'test_*.py' -v
python3 -m py_compile check_jsonl.py test_check_jsonl.py
```

2026-10-27、Linux/Python 3.13.5でunittest **13件PASS**、構文検査PASS。CLIの正常系・不正行・ファイル不存在は単体テスト内で実行しました。Codex CLIは利用できず、実行していません。Windows/macOSでの実行は未確認です。GitHub Actionsは請求上限によるRunner未起動のため使いません。

## 実務で使うなら

このコードはJSONの**構文と文字コード**の検査であり、項目名・型・業務ルール・秘密情報の有無を保証しません。データ本文やファイルパスをログへ出さない設計ですが、行番号とエラー種別の扱いにも注意してください。最大エラー数は `--max-errors 20`（既定値）で変更可能。エラーを全件列挙する機能ではありません。実データの自動修復は行わず、元ファイルを保全して別工程で扱います。

## 公式情報

- [JSON Lines形式の規則](https://jsonlines.org/)
- [Python jsonモジュール](https://docs.python.org/3.13/library/json.html)
- [Python argparse](https://docs.python.org/3.13/library/argparse.html)
