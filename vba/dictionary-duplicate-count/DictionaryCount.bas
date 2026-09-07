Option Explicit

Private Const OUTPUT_SHEET_NAME As String = "重複集計結果"

Public Sub CountDuplicates()
    Dim sourceWs As Worksheet
    Dim outputWs As Worksheet
    Dim dict As Object
    Dim lastRow As Long
    Dim row As Long
    Dim key As String
    Dim outRow As Long
    Dim item As Variant

    Set sourceWs = ActiveSheet

    ' 集計結果シートを入力元にすると、前回結果を再集計してしまうため止めます。
    If sourceWs.Name = OUTPUT_SHEET_NAME Then
        MsgBox "入力データがあるシートを選んでから実行してください。", vbExclamation
        Exit Sub
    End If

    ' Late Bindingなら「Microsoft Scripting Runtime」の参照設定を追加せず使えます。
    Set dict = CreateObject("Scripting.Dictionary")

    ' 大文字小文字を同じキーとして数えます。
    ' CompareModeはキーを追加する前に設定します。
    dict.CompareMode = vbTextCompare

    lastRow = sourceWs.Cells(sourceWs.Rows.Count, "A").End(xlUp).Row

    For row = 2 To lastRow
        key = Trim$(CStr(sourceWs.Cells(row, "A").Value2))

        ' 空白セルは集計対象にしません。
        If Len(key) > 0 Then
            If dict.Exists(key) Then
                dict(key) = CLng(dict(key)) + 1
            Else
                dict.Add key, 1
            End If
        End If
    Next row

    Set outputWs = GetOrCreateOutputSheet(sourceWs.Parent)

    ' 入力シートのC:D列などを消さないよう、結果は専用シートだけに出します。
    outputWs.Cells.ClearContents
    outputWs.Range("A1").Value = "値"
    outputWs.Range("B1").Value = "件数"

    outRow = 2
    For Each item In dict.Keys
        outputWs.Cells(outRow, "A").Value = item
        outputWs.Cells(outRow, "B").Value = dict(item)
        outRow = outRow + 1
    Next item

    outputWs.Columns("A:B").AutoFit
    outputWs.Activate

    MsgBox dict.Count & " 種類を集計しました。", vbInformation
End Sub

Private Function GetOrCreateOutputSheet(ByVal wb As Workbook) As Worksheet
    Dim ws As Worksheet

    ' シートが存在するか確認する間だけエラーを無視し、すぐ通常状態へ戻します。
    On Error Resume Next
    Set ws = wb.Worksheets(OUTPUT_SHEET_NAME)
    On Error GoTo 0

    If ws Is Nothing Then
        Set ws = wb.Worksheets.Add(After:=wb.Worksheets(wb.Worksheets.Count))
        ws.Name = OUTPUT_SHEET_NAME
    End If

    Set GetOrCreateOutputSheet = ws
End Function
