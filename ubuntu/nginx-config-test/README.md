# Nginx設定をreload前に確認する

Nginxの設定変更後に、いきなりreloadせず `nginx -t` で構文と参照ファイルを確認するための安全確認サンプルです。

## 使い方

```bash
chmod +x check-nginx-config.sh
./check-nginx-config.sh
```

有効設定全体も確認したい場合だけ `--dump` を付けます。

```bash
./check-nginx-config.sh --dump
```

## なぜreloadしないのか

このサンプルの目的は「変更前後の確認」です。設定テストに失敗した状態でreloadへ進まないよう、reload自体は自動実行しません。

`nginx -T` は読み込まれる設定全体を標準出力へ表示します。設定内にホスト名、パス、証明書設定、アクセス制御など運用情報が含まれる可能性があるため、出力をそのまま外部へ貼り付けないでください。

## ローカル確認記録

2026-09-07に次の環境でロジック確認を実施しました。

- Debian GNU/Linux 13 (trixie)
- Bash 5.2.37
- nginx 1.26.3
- `bash -n check-nginx-config.sh`: 成功
- `./check-nginx-config.sh`: 成功（`nginx -t` 成功、reload未実行）
- `--dump` 分岐: 未実行

Ubuntu実機での確認ではないため、記事側は「実機確認済み」ではなくロジック確認済みとして扱います。

## 公式情報

- [nginx — Command-line parameters](https://nginx.org/en/docs/switches.html)
