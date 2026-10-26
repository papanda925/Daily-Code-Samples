# Pythonの子プロセス：正常・異常終了・タイムアウトを安全に観察する

`subprocess.run()` の戻り値と例外を区別する、追加パッケージ不要の教材です。外部ネットワーク接続、実ファイルの変更、シェルコマンドの実行は行いません。実行するのは同じPythonインタープリターの短いダミープログラムだけです。

## 前提環境

- Python 3.9以降（標準ライブラリのみ）。Linuxでの実行確認：Python 3.13.5。
- Windows/macOSでの実機検証は未実施。`python` と `python3` のコマンド名は環境に合わせてください。
- 通常ユーザー権限で実行。sudoやAPIキーは不要。

## まず試す

```bash
python3 run_demo.py --mode ok
python3 run_demo.py --mode fail
python3 run_demo.py --mode timeout --timeout 5
```

`fail` は終了コード1、`timeout` は124を返すので、シェルの `&&` で3コマンドを連結しないでください。各コマンドを個別に実行します。

### 期待結果（Python 3.13.5 / Linuxで確認）

`ok`:

```text
STATUS=OK
CHILD_RETURN_CODE=0
STDOUT=child: done
STDERR=
```

`fail`:

```text
STATUS=NONZERO
CHILD_RETURN_CODE=7
STDOUT=
STDERR=child: failed
```

`timeout`（5秒で中断）:

```text
STATUS=TIMEOUT
CHILD_RETURN_CODE=N/A
STDOUT=child: waiting
STDERR=
```

タイムアウトの直前に子プロセスが起動していない場合、STDOUTは空になることがあります。出力行は確定したものではなく、観察できた範囲です。

## ここを見る

- `CHILD_RETURN_CODE` は子プロセス自身の終了コード。`fail` は意図的に7で終了します。
- この教材の終了コードは `OK=0`、`NONZERO=1`、`TIMEOUT=124`、`START_FAILED=127`。子プロセスの終了コードとは区別します。
- `STDOUT` と `STDERR` は別々に取得します。失敗理由が必ずstderrに出るとは限りません。
- `TimeoutExpired` の部分出力は `text=True` でもbytesになり得るため、デコードを分けています。

## 1か所変える

`--mode timeout --timeout 5` を `--mode timeout --timeout 40` に変更します。子プログラムは30秒待つため、通常は `TIMEOUT` から `OK` へ変わります。ただし長時間待つので、最初は短い設定を推奨します。

## テスト

```bash
python3 -m unittest discover -p 'test_*.py' -v
python3 -m py_compile run_demo.py test_run_demo.py
```

ローカルPython 3.13.5/Linuxで9件のunittestが成功しました。単体テストのタイムアウト分岐はモックで再現し、別途CLIを実際に `--timeout 5` で起動して終了コード124を確認しました。Codex CLIはこの制作実行では使用していません。

## 失敗時の切り分け

- `python3: command not found`: Python 3の導入とPATHを確認。Windowsでは `py -3` など環境に応じて実行。
- `STATUS=START_FAILED`: 子プロセス起動時のOSエラー。教材では例外型のみ表示し、実パスや秘密値をログへ出しません。
- `STATUS=TIMEOUT` で `STDOUT=` が空: 子プロセスが出力する前に時間切れになった可能性。`--timeout` を増やして比較。
- 文字化け: 出力はUTF-8でデコードします。実務の外部コマンドは出力エンコーディングを別途確認。
- 出力が大量: `capture_output=True` はメモリへ蓄積するため、大量ログにはファイル出力や逐次処理を検討。

## 仕事で使うなら

実運用で外部プログラムを起動する場合は、固定された実行ファイルと検証済み引数だけを渡し、入力からシェルコマンドを組み立てないでください。`shell=False` は権限分離や入力検証の代わりではありません。`timeout` は直接起動した子プロセスの終了を待ちますが、子が起動した孫プロセス群の終了まで保証しません。秘密情報を含む標準出力・標準エラーをそのままログへ保存しないことも重要です。

## 公式資料

- [Python subprocess — run、CompletedProcess、TimeoutExpired](https://docs.python.org/3.13/library/subprocess.html)
- [Python sys.executable](https://docs.python.org/3.13/library/sys.html#sys.executable)
- [Python argparse](https://docs.python.org/3.13/library/argparse.html)
