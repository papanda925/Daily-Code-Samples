# TEXTBEFORE / TEXTAFTERで文字列を分ける

Excel 365の `TEXTBEFORE` と `TEXTAFTER` を、ダミーのメールアドレスで観察する教材です。

## まず試す

A2 に `user@example.com` を入れます。

```excel
=TEXTBEFORE(A2,"@")
=TEXTAFTER(A2,"@")
```

期待値は `user` と `example.com` です。

## ここを見る

区切り文字そのものは結果に含まれません。元セルは変更しません。

## 1か所変える

A2を `sales@example.co.jp` に変え、ドメイン側の結果だけが変わることを確認します。

## 仕事で使うなら

メール一覧のユーザー部・ドメイン部の確認、コード値の接頭辞/接尾辞の分離などに使えます。

## 注意点

区切り文字がないデータではエラーになり得ます。実データでは `if_not_found` 引数も検討してください。

検証状態: implemented。Excel実機では未確認です。
