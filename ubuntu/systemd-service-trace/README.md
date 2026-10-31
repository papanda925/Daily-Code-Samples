# systemctlとjournalctlでsystemdサービスを追う

papanda925.com の記事で使うコード／コマンドを、再利用しやすい形で保存したサンプルです。

- 元記事ID: `20260906-06`
- 分類: `ubuntu`
- 検証状態: 記事制作時の構文・ロジック確認を引き継ぎます。実機確認済みと明記していないものは、自分の環境で確認してください。

## ファイル

- `inspect-service.sh`

## 注意

本番環境へ変更を加える前に、対象・権限・復旧方法を確認してください。秘密情報や実環境固有値は保存しません。

## まず試す

[inspect-service.sh](inspect-service.sh) は、指定したsystemdサービスの状態・ログ・ユニット設定を表示する**読取り専用**のシェルです。Ubuntu等、systemdのある環境が必要です。

```bash
bash inspect-service.sh nginx
```

**期待結果（未実行）**：`status`、`is-active`、`is-enabled`、直近80件のjournal、`systemctl cat`、`Result` と `ExecMainStatus` などの項目が順に表示されます。引数省略時の対象も `nginx` です。

## 結果の見方と注意

`active` はサービスの現在状態、`Result=success` はそのunitの実行結果です。どちらもアプリの機能・成果物の成功まで保証しません。`systemctl status` の失敗はスクリプト内で許容しますが、`journalctl` や `systemctl cat` の権限不足で停止する場合があります。

## 安全・トラブル・検証

ジャーナルやユニット設定には内部パス・認証関連情報が含まれる場合があります。**出力をそのまま公開しない**でください。権限不足や対象unit不明の場合は名前と実行権限を確認します。2026-10-31：GitHub上のシェル内容のみ照合。実機systemdでの試験は未実施。
