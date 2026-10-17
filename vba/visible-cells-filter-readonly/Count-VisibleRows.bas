Option Explicit
' 「抽出練習」シートのA2:A30だけを調べる。
' フィルターの作成・変更はせず、ユーザーが設定した状態を読む。
Public Sub CountVisibleProductRows()
    Dim ws As Worksheet
    Dim dataRange As Range
    Dim visibleRange As Range
    Dim cell As Range
    Dim count As Long

    On Error GoTo Failed
    Set ws = ThisWorkbook.Worksheets("抽出練習")
    Set dataRange = ws.Range("A2:A30")

    ' SpecialCellsは該当セルがない場合にエラーになることがある。
    ' この1行だけ捕捉し、それ以外のエラーは隠さない。
    On Error Resume Next
    Set visibleRange = dataRange.SpecialCells(xlCellTypeVisible)
    Err.Clear
    On Error GoTo Failed

    If visibleRange Is Nothing Then
        Debug.Print "見えるデータ行はありません"
        Exit Sub
    End If
    For Each cell In visibleRange.Cells
        If Len(Trim$(CStr(cell.Value2))) > 0 Then
            count = count + 1
            Debug.Print "表示セル: " & cell.Address(False, False)
        End If
    Next cell
    Debug.Print "値のある表示データ行: " & count
    Exit Sub
Failed:
    Debug.Print "確認に失敗: " & Err.Number & " " & Err.Description
End Sub
