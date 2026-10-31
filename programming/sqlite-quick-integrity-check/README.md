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

## まず試す

[check-db.py](check-db.py) はSQLiteの**メモリ内データベース**だけを使い、通常の構造検査と外部キー検査が別物であることを示します。

```bash
python3 check-db.py
```

**期待結果（未実行）**：`quick_check` と `integrity_check` は`ok`、`foreign_key_check` は親ID 99に対応する行が無いため問題行を返す想定です。

## 仕組み・トラブル・検証

コードは外部キー制約を一時的に無効にして孤児行を作り、その後有効化して検査します。これは**永続DBの整合性検査ではありません**。実運用DBの設定を変更するための手順として使わないでください。Python標準の `sqlite3` が必要です。2026-10-31：ソース読取りにより条件を確認。Pythonでの実行試験は未実施。公式：[SQLite PRAGMA](https://www.sqlite.org/pragma.html)。
