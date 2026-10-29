# TOML設定を適用前に読み取り専用で検査する（Python）

`tomllib`でTOMLの構文を読み取り、教材用の`[app]`に必須の3項目があるか、値の**型**が正しいかを確かめるサンプルです。設定値やファイル内容は出力しません。ファイルの修正・外部通信・API呼び出しはしません。

## 前提環境

- Python **3.11以降**（`tomllib`は3.11で追加）。追加パッケージ不要。
- 検証済み: 2026-10-29、隔離Linuxコンテナ / Python **3.13.5**。
- Windows/macOSは未実測。Windowsでは`py -3`、Linux/macOSでは`python3`を使用してください。
- 管理者権限不要。**実運用の秘密を含む設定ファイルではなく、まず付属の`demo.toml`を使ってください。**

## ファイル

- `check_toml.py`：読み取り専用のCLI。`[app]`の`name`（空でない文字列）、`enabled`（真偽値）、`retries`（0〜10の整数）を検査します。
- `demo.toml`：架空の入力例。
- `test_check_toml.py`：ダミー入力による19件のオフラインテスト。

## まず動かす

このディレクトリで実行します。

```bash
python3 check_toml.py demo.toml
```

**実測出力（Linux / Python 3.13.5、終了コード0）**

```text
STATUS=VALID CHECKS=APP_NAME_ENABLED_RETRIES
```

`demo.toml`の内容は次のとおりです。

```toml
[app]
name = "demo"
enabled = true
retries = 2
```

このサンプルの`retries`の上限10は**教材用の独自ルール**であり、TOML仕様の制限ではありません。

## 1か所変えて比較

`demo.toml`を**別名でコピー**し、`retries = 2`を`retries = "2"`へ変更してから実行します。引用符を付けると整数ではなく文字列になるため、構文は正しくても型検査に失敗します。

```bash
python3 check_toml.py demo-copy.toml
```

**期待出力（この変更例そのもののCLI実行は未実測。単体テストでは文字列型の失敗を確認）**

```text
STATUS=INVALID ISSUE=INVALID_RETRIES
```

終了コードは`2`になる想定です。元の`demo.toml`は変更しません。

## 失敗時の切り分け

| 出力 | 主な確認点 |
| --- | --- |
| `INVALID_TOML` | TOMLの文法、重複したキー、閉じ忘れを確認。具体的な設定値は表示しません。 |
| `INVALID_UTF8` | 入力の文字コードを確認。UTF-8以外は受け付けません。 |
| `MISSING_APP_TABLE` / `MISSING_NAME` | `[app]`と`name`の有無を確認。 |
| `INVALID_NAME` / `INVALID_ENABLED` / `INVALID_RETRIES` | 空文字、`"true"`のような文字列、範囲外の整数を確認。 |
| `FILE_TOO_LARGE` | 64KiB超のファイルを拒否します。上限は教材独自の資源保護です。 |
| `SYMLINK_NOT_ALLOWED` | シンボリックリンクは検査対象にしません。 |
| `NOT_REGULAR_FILE` / `READ_FAILED` | ファイルの有無、通常ファイルか、読み取り権限を確認。 |

終了コードは`0`が有効、`2`が内容・入力条件の不適合、`3`がファイル入出力の失敗です。CLI引数の指定誤りも`argparse`により終了コード`2`になります。

## テスト方法と実測

```bash
python3 -m unittest discover -p 'test_*.py' -v
python3 -m py_compile check_toml.py test_check_toml.py
python3 check_toml.py demo.toml
```

2026-10-29に隔離Linuxコンテナ / Python 3.13.5で**19テストPASS**、構文検査PASS、正常CLI exit 0、存在しないファイルのCLI exit 3を確認。Codex CLIは見つからず、使用していません。GitHub Actionsは実行していません。Windows/macOSは未検証です。

## 使うときの注意

`tomllib`はTOMLを**読むためのライブラリ**であり、書き出しには対応していません。TOML構文が正しくても、実際のアプリケーションで設定が正しく機能するとは限りません。この教材の検査は`[app]`の3項目だけで、その他のキーの意味・アクセス権・接続先の安全性は判定しません。

プログラムは設定値を出力しませんが、**実運用ファイルを公開GitHubに置かない**でください。入力のパスがコマンド履歴に残ることや、権限が不適切なファイルを読めてしまう可能性にも注意してください。シンボリックリンクの拒否は簡易チェックであり、競合更新や悪意あるファイル置換に対する完全な防御ではありません。

## 公式資料

- [Python 3.13公式: tomllib](https://docs.python.org/ja/3.13/library/tomllib.html) — TOML 1.0の読み取り、`TOMLDecodeError`、書き込み非対応、入力サイズの注意。
- [Python 3.13公式: argparse](https://docs.python.org/ja/3.13/library/argparse.html) — CLI引数の解析。
- [Python 3.13公式: unittest](https://docs.python.org/ja/3.13/library/unittest.html) — オフラインテスト。
