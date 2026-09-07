# VBAの参照設定を一覧化しBROKENを見つける

`ThisWorkbook.VBProject.References` を列挙し、正常な参照は `[OK]`、壊れた参照は `[BROKEN]` としてイミディエイトウィンドウへ出します。

## 成功条件

- マクロが参照一覧へアクセスできる
- 正常参照が `[OK]` で表示される
- 最後にTotal/Broken件数が出る

BROKENが0件なら `[SUCCESS]`、1件以上なら `[RESULT]` として明確に分けます。

## なぜ壊れた参照でFullPathを読まないのか

Microsoft Learnでは、`Reference.IsBroken = True` のとき `FullPath` を読むとエラーになると説明されています。そのため壊れた参照ではFullPathを触らずGUID取得だけを安全に試します。

## セキュリティ上の注意

VBAプロジェクトオブジェクトモデルへプログラムからアクセスするには、Office側で「VBA プロジェクト オブジェクト モデルへのアクセスを信頼する」が必要な場合があります。必要性を理解した上で設定し、組織ポリシーに従ってください。

## 検証状態

Microsoft LearnのReference仕様とOfficeセキュリティ資料を確認して実装。このセッションではExcel/VBA実機未確認です。

## 公式情報

- Microsoft Learn — Reference.FullPath: https://learn.microsoft.com/ja-jp/office/vba/api/access.reference.fullpath
- Microsoft Support — Change macro security settings: https://support.microsoft.com/office/change-macro-security-settings-in-excel-a97c09d2-c082-46b8-b19f-e8621e8fe373
