# Excel TAKE / DROP / CHOOSECOLS を同じ表で比べる

Excelの動的配列関数 TAKE / DROP / CHOOSECOLS を、同じ3列×4行のダミー表で比較する最小サンプルです。

## ダミーデータ

A1:C4 に次を入力します。

```text
名前,部署,売上
青木,営業,120
伊藤,総務,80
佐藤,営業,150
```

## 試す式

```text
=TAKE(A1:C4,2)
=TAKE(A1:C4,-2)
=DROP(A1:C4,1)
=DROP(A1:C4,-1)
=CHOOSECOLS(A1:C4,1,3)
```

## 観察ポイント

- TAKEの正数は先頭側、負数は末尾側から取得します。
- DROPの正数は先頭側、負数は末尾側を除外します。
- CHOOSECOLSは列番号で必要列だけを新しい配列として返します。
- 元表は変更せず、結果は別セルへスピルします。
- TAKE/DROPで0を指定した場合などのエラーも、元データを壊さず確認できます。

## 検証状態

Microsoft SupportのTAKE / DROP / CHOOSECOLS仕様を確認済みです。Excel実機での動作確認は未実施です。
