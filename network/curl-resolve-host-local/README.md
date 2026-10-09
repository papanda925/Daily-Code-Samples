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
