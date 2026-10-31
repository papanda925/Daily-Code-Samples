# curl --resolveを外部通信なしで試す

標準ライブラリのPython HTTPサーバーを`127.0.0.1:39123`に起動します。外部IPに公開しません。

端末A：

```bash
python3 local_http.py
```

端末B：

```bash
curl --noproxy '*' --resolve demo.invalid:39123:127.0.0.1 \
  http://demo.invalid:39123/
```

期待表示（実機未実行）：

```text
Path: /
Host: demo.invalid:39123
```

`demo.invalid`という名前のままHTTP要求しつつ、このcurl実行の接続先IPだけをlocalhostに指定します。システムのDNSやhostsは変更しません。`--noproxy '*'`を入れ、プロキシ環境変数経由の通信を避けます。

`--resolve`はホスト名とポートの組に対するIP指定であり、URLのホスト名を変更しません。HTTPSの場合もURL名がTLS SNIや証明書のホスト名照合に使われます。**HTTPSの検証を省く`-k`/`--insecure`を常用しないでください**。この教材はHTTPのみで、TLS証明書を用いた実機比較はしません。

- https://curl.se/docs/manpage.html#--resolve
- https://curl.se/docs/manpage.html#--connect-to
- https://curl.se/docs/sslcerts.html

**検証状態：curl公式資料確認済み／Pythonとcurlの実機試験未実施。**

## 何を確かめるか

`--resolve` はURLのホスト名に対し、一時的に接続先IPを指定するcurlオプションです。DNSの恒久的な設定は変更せず、ローカルHTTPサーバーで`Host`ヘッダーを観察します。

## 期待結果と失敗時の確認

[local_http.py](local_http.py) は `127.0.0.1:39123` のみで待ち受け、受け取ったPathとHostを返します。サーバーを起動してからREADMEのcurlコマンドを実行すると、指定したHost名が本文へ表示される想定です。ポート使用中・接続拒否なら、Pythonサーバーの起動状態とポート番号を確認してください。終了はCtrl+Cです。

## 検証

2026-10-31：Pythonの待受先と返却内容をソースで確認。ネットワーク実行・ブラウザ動作は未検証。実際の公開DNSや本番サービスには使いません。
