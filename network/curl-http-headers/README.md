# curlでHTTPレスポンスヘッダーを確認する

HTTPレスポンスの本文を保存せず、status と headers を読み取り専用で観察する教材です。Nginx の gzip 判定では、通常リクエストと Accept-Encoding: gzip を付けたリクエストを比べます。

## まず試す

~~~bash
./check-http-headers.sh https://example.com/
~~~

対象URLを省略した場合は https://example.com/ を使います。本番サイトの設定変更は行いません。

## ここを見る

- Content-Type: 応答のMIME type
- Content-Encoding: gzip等のcontent coding
- Content-Length: 応答に付く場合の長さ
- Vary: キャッシュが要求ヘッダーを区別する手掛かり

2回目は明示的に Accept-Encoding: gzip を送ります。Nginx側がgzipを許可していても、MIME type、サイズ、設定等によって Content-Encoding: gzip が付かない場合があります。

## 1か所変える

同じURLのまま、Accept-Encoding: gzip の有無だけを変えます。対象ファイルやURLまで同時に変えると、何が差を生んだのか判断しにくくなります。

## 仕事で使うなら

まずheadersを観察し、必要ならNginxの有効設定を別途確認します。nginx -T は設定全体を標準出力へ出すため、公開チャットや記事へ貼る前にドメイン、パス、上流構成等をマスクしてください。

## 検証状態

curl/Nginx/HTTPの公式仕様を確認した教材です。この更新時点では、このリポジトリ上での実機実行結果は追加していません。

## 公式情報

- [nginx — ngx_http_gzip_module](https://nginx.org/en/docs/http/ngx_http_gzip_module.html)
- [RFC 9110 — HTTP Semantics](https://www.rfc-editor.org/rfc/rfc9110.html)
- [curl — man page](https://curl.se/docs/manpage.html)
