Option Explicit

Public Sub InspectProducts()
    Dim ws As Worksheet
    Dim products As ListObject
    Dim rowCount As Long
    Dim body As Range

    On Error GoTo Failed
    Set ws = ThisWorkbook.Worksheets("商品表")
    Set products = ws.ListObjects("tblProducts")

    ' ListRowsはヘッダー・集計行を含まないデータ行の集合。
    ' 見出し行があることとデータがあることを混同しない。
    rowCount = products.ListRows.Count
    Debug.Print "データ行数: " & rowCount

    If rowCount = 0 Then
        Debug.Print "データ行なし"
        Exit Sub
    End If

    ' 空テーブルではDataBodyRangeがNothingの場合がある。
    ' .Cellsへアクセスする前にNothingを確認する。
    Set body = products.DataBodyRange
    If body Is Nothing Then
        Debug.Print "データ領域を取得できません"
        Exit Sub
    End If

    Debug.Print "先頭データ行の第1列: " & CStr(body.Cells(1, 1).Value2)

    ' すべての行を表示する場合はListRowsを順に参照できる。
    ' ただし空欄の商品コードや重複はこの例では許容せず警告する。
    Dim oneRow As ListRow
    For Each oneRow In products.ListRows
        If Len(Trim$(CStr(oneRow.Range.Cells(1, 1).Value2))) = 0 Then
            Debug.Print "要確認: 行" & oneRow.Index & "の商品コードが空欄"
        End If
    Next oneRow
    Exit Sub

Failed:
    Debug.Print "実行に失敗: " & Err.Number & " " & Err.Description
End Sub
