# ADODB.StreamでUTF-8 BOM付きテキストを保存する

VBAから `ADODB.Stream` をLate Bindingで呼び、文字列をUTF-8でファイル保存します。

## 使い方

`SaveUtf8Bom.bas` を標準モジュールへ貼り付け、`DemoSaveUtf8Bom` を実行します。

## 注意

この方法で保存したUTF-8にはBOMが付くのが一般的です。BOMなしを要求するシステムへ渡す場合は別処理が必要です。

## 検証状態

Microsoft LearnのADO Stream / Charset / SaveToFile仕様を確認して実装。Excel実機確認は未実施です。
