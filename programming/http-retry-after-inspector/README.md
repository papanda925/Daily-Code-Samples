# HTTP Retry-After をネットワーク接続なしで調べる（Python）

HTTP応答ヘッダー `Retry-After` の値から待機秒数とUTCの再開目安を表示する教材です。**待機・再送・HTTPアクセス・ファイル更新は一切行いません。**

## 前提環境

- Python 3.10以降、標準ライブラリのみ。実測はPython 3.13.5 / Linuxコンテナー。
- Windows・macOS・Ubuntu各実機の個別試験は未実施。
- RFC 9110 §10.2.3 の非負整数とHTTP-dateのうちIMF-fixdateのみ対応。旧形式のHTTP-dateは意図的に拒否します。

## まず試す

```bash
python retry_after.py 120 --now 2026-10-24T00:00:00+00:00
python retry_after.py 'Sat, 24 Oct 2026 00:02:00 GMT' --now 2026-10-24T00:00:00+00:00
```

実測：いずれも `wait_seconds` が120。最初は `kind: delay-seconds`、次は `kind: http-date`。

```json
{"kind": "delay-seconds", "wait_seconds": 120, "target_utc": "2026-10-24T00:02:00Z", "action": "inspect_only_no_sleep_no_request"}
```

`--now` を省略すると現在UTCを使います。固定時刻にはオフセット付きISO 8601日時を指定してください。

## ここを見る

- 秒数は受信時からの相対値、HTTP-dateは絶対時刻です。
- 過去日時の待機は0秒、残りが端数秒なら切り上げます。
- `wait_seconds` は観察値であり、再送の許可ではありません。

## 1か所変える

```bash
python retry_after.py 0 --now 2026-10-24T00:00:00+00:00
python retry_after.py 'Fri, 23 Oct 2026 23:59:59 GMT' --now 2026-10-24T00:00:00+00:00
python retry_after.py '-1' --now 2026-10-24T00:00:00+00:00
```

前2件は待機0秒。負数は `INVALID_RETRY_AFTER` と終了コード2です。

## テスト

```bash
python -m unittest discover -v
python -m py_compile retry_after.py test_retry_after.py
```

作成時実測：Python 3.13.5、単体テスト16件成功、構文検査成功、CLIの2形式で120秒を確認。Codex CLI未実行。

## 失敗時の切り分け

| 症状 | 対応 |
|---|---|
| `python`が見つからない | Python 3の導入・PATHを確認。Windowsは `py -3` も検討 |
| `INVALID_RETRY_AFTER` | 負数、小数、曜日不一致、GMT欠落、旧形式日時を確認 |
| 予想外の秒数 | `--now` のタイムゾーンと端数秒を確認 |
| テストが見つからない | 2つのPythonファイルを同じディレクトリへ配置 |

## 仕事で使うなら

障害調査でレスポンスヘッダーの値を安全に再現検証する用途です。実際の再試行にはHTTPステータス、最大試行回数、タイムアウト、冪等性、APIの利用条件、バックオフ方針が別途必要です。

## 公式情報

- [RFC 9110 §10.2.3](https://www.rfc-editor.org/rfc/rfc9110.html#section-10.2.3)
- [RFC 9110 §5.6.7](https://www.rfc-editor.org/rfc/rfc9110.html#section-5.6.7)
- [Python 3.13 email.utils](https://docs.python.org/3.13/library/email.utils.html#email.utils.parsedate_to_datetime)
- [Python unittest](https://docs.python.org/3/library/unittest.html)
