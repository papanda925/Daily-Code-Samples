Option Explicit

Public Sub ChooseCsvFiles()
    Dim picker As Office.FileDialog
    Dim selectedPath As Variant

    On Error GoTo Failed

    ' msoFileDialogFilePickerはファイル選択ダイアログの種類。
    ' 単に選択した名前を確認するだけで、ファイルは読み込まない。
    Set picker = Application.FileDialog(msoFileDialogFilePicker)
    With picker
        .Title = "練習用CSVファイルを選択"
        .AllowMultiSelect = True

        ' フィルターはUI上の表示補助。CSV内容の検証には使えない。
        .Filters.Clear
        .Filters.Add "CSVファイル", "*.csv"

        ' -1は選択の確定、0はキャンセル。キャンセルは正常に終了する。
        If .Show <> -1 Then
            Debug.Print "キャンセルしました（処理なし）"
            Exit Sub
        End If

        ' Variantで受けるとSelectedItemsの各パスを列挙できる。
        ' 選択順は業務上の処理順を保証するものとして使わない。
        For Each selectedPath In .SelectedItems
            Debug.Print "選択: " & CStr(selectedPath)
        Next selectedPath
    End With
    Exit Sub

Failed:
    ' ファイル選択に失敗しても前回の選択パスへフォールバックしない。
    Debug.Print "選択に失敗: " & Err.Number & " " & Err.Description
End Sub
