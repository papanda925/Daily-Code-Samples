# HTTP status triage with curl

HTTP 404 / 502 / 504 などが出たとき、まず実際のHTTPレスポンスを短く確認するためのサンプルです。

## すぐ試す: localhostで404を作る

ターミナル1:

```bash
python3 -m http.server 8000 --bind 127.0.0.1
```

ターミナル2:

```bash
chmod +x check-http-status.sh
./check-http-status.sh http://127.0.0.1:8000/not-found
```

存在しないpathなので、Pythonの簡易HTTPサーバーから404が返ります。

この実験は `127.0.0.1` だけを使うため、外部Webサイトを実験台にしません。

## 実サイトを確認する場合

```bash
./check-http-status.sh https://example.com/
```

確認対象URLは自分で指定してください。

このスクリプトはレスポンス本文を保存せず、主に次を表示します。

- response header
- HTTP status
- remote IP
- total time

## 502 / 504について

このサンプルは、汎用環境で502や504を意図的に発生させるためにNginx設定を変更しません。

502 / 504 を見つけたら、その後で次を確認します。

- Nginxの `proxy_pass` / `fastcgi_pass`
- upstream process / port / Unix socket
- Nginx error log
- upstreamの処理時間
- timeout設定

「安全にstatusを観察する」と「障害を故意に作る」を分けています。

## 検証

2026-09-07 に以下でローカル確認しました。

- Bash 5.2.37
- curl 8.10.1
- Python 3.13.5 の `http.server`
- `bash -n` 成功
- localhostの存在しないpathで HTTP 404 を取得
- `REMOTE_IP=127.0.0.1` を確認

502 / 504 の故意の再現は実施していません。
