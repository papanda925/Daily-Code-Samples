# VBAの参照設定を一覧化し壊れた参照を調べる

`ThisWorkbook.VBProject.References` を列挙し、参照名・バージョン・パスと `IsBroken` を確認するサンプルです。

## 重要な注意

このコードはVBAプロジェクトオブジェクトモデルへアクセスします。Officeのセキュリティ設定で「VBA プロジェクト オブジェクト モデルへのアクセスを信頼する」が必要な場合があります。Microsoftは、この設定を必要な期間だけ有効にし、作業後に戻すことを推奨しています。

## 検証状態

Microsoft LearnのVisual Basic Add-in ModelとOfficeセキュリティ注意事項を確認して実装。Excel実機確認は未実施です。
