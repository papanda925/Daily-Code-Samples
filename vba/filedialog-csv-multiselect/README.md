# Excel VBA FileDialogで複数のCSVを選ぶ（キャンセルを安全に扱う）

[元記事：FileDialogで複数ファイルを選ぶ](https://github.com/papanda925/Blog-Ideas/blob/main/publish/items/20261016-10-body.md)。選んだファイルの**パスを表示するだけ**のコードです。CSVを開く・上書き・送信・削除する処理はありません。

## まず試す

1. Windowsデスクトップ版Excelの新しいマクロ有効ブックで標準モジュールを作り、`ChooseCsvFiles.bas`を貼り付ける。
2. 自分で作った練習用フォルダーに`sample-a.csv`、`sample-b.csv`を用意する。中身は架空データでよい。
3. `ChooseCsvFiles`を実行してCSV二つを選ぶ。Ctrl+Gのイミディエイトに二つのパスが表示される想定（実機未実行）。
4. 再び実行してキャンセルすると、選択パスを扱わず「キャンセル」と表示して終了する想定。

## ここを見る

`FileDialog.Show` は確定時に-1、キャンセル時に0を返す。キャンセルを先に判定し、`SelectedItems`を列挙する前に`Exit Sub`で抜ける。`SelectedItems`はユーザーが選んだパスの集合であり、ファイル内容の検証はしない。

## 1か所変える

`.AllowMultiSelect = False` に変更して複数選択できなくなることを確かめる。ダイアログのCSVフィルターは表示候補を絞るだけで、CSV内容の正しさを保証しない。選択後に取り込む機能を作る場合、別途ファイルの存在・列名・文字コード・権限・対象件数を確認する必要がある。

## 仕事で使うなら

共有フォルダーのパスには内部情報が含まれる場合がある。ログの外部共有、スクリーンショット公開に注意する。Excelでマクロ実行が禁止されているなら、ポリシーを無断で解除しない。

## 出典・検証状態

2026-10-16作成。Microsoft Learnの[FileDialog.Show](https://learn.microsoft.com/en-us/office/vba/api/office.filedialog.show)と[SelectedItems](https://learn.microsoft.com/en-us/office/vba/api/office.filedialog.selecteditems)に基づく。**Excel実機コンパイル・実行未確認**。
