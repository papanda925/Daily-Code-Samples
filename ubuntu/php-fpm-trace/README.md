# NginxからPHP-FPMまでを読み取り専用でたどる

PHPが動かないときに、サービス、listen socket、Nginxの fastcgi_pass、ログという層を混ぜずに確認する教材です。

## まず試す

Ubuntu等の対象サーバーで、内容を確認してから実行します。

~~~bash
./check-php-fpm-path.sh
~~~

このスクリプトはサービス再起動・設定変更・reloadをしません。

## ここを見る

- PHP-FPM service候補が存在するか
- pool設定の listen = ... がどこを指すか
- Unix socketが実際に待ち受けているか
- Nginxの fastcgi_pass が同じport/socketを指すか

## 1か所変える

まず読み取り専用確認だけで経路をそろえます。修正が必要になっても、service再起動やNginx reloadは別工程に分けてください。

## 注意

nginx -T は有効設定を広く出力します。スクリプトではFastCGI関連行だけに絞りますが、共有前にはドメイン、パス、upstream名等を再確認してください。権限不足で一部を読めない場合は、その事実を「サービス停止」と解釈しないでください。

## 検証状態

PHP-FPMとNginx FastCGIの公式資料に合わせた読み取り専用教材です。対象Ubuntu環境での実行確認は未実施です。

## 公式情報

- [PHP Manual — FastCGI Process Manager (FPM)](https://www.php.net/manual/en/install.fpm.php)
- [PHP Manual — FPM configuration](https://www.php.net/manual/en/install.fpm.configuration.php)
- [nginx — ngx_http_fastcgi_module](https://nginx.org/en/docs/http/ngx_http_fastcgi_module.html)
