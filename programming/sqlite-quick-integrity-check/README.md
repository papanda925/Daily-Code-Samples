# SQLiteのquick_check/integrity_check/foreign_key_check比較

```bash
python3 check-db.py
```

Python標準のsqlite3、インメモリDBだけを使います。既存DBファイルや機密情報には触れません。

このサンプルでは、FK強制を一時的に無効化して存在しないparent_id=99の行を作成します。

**期待値（実行環境で必ず確認）**
- `PRAGMA quick_check` → [("ok",)]：物理/構造面の簡易チェック
- `PRAGMA integrity_check` → [("ok",)]：詳細な構造・一部制約のチェック
- `PRAGMA foreign_key_check` → 存在しない親への参照を示す行を返す

`integrity_check`も外部キー違反を検出しません。外部キーは別チェックが必要です。

実際のデータベースはバックアップ、アクセス権、WAL/他プロセス同時アクセスを確認し、保守時間帯に実施してください。意図的にファイルを破損させるテストは行わないこと。

公式: https://www.sqlite.org/pragma.html#pragma_integrity_check
https://www.sqlite.org/pragma.html#pragma_quick_check
https://www.sqlite.org/pragma.html#pragma_foreign_key_check

**検証状態：SQLite仕様照合済み・サンプルの実機実行は未実施。**
