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

## 検証状態

nginx公式のcommand-line parametersで `-t` と `-T` の仕様を確認して実装。対象Ubuntu/Nginx環境での実行確認は未実施です。

## 公式情報

- [nginx — Command-line parameters](https://nginx.org/en/docs/switches.html)
