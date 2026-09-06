Option Explicit

Public Sub CountDuplicates()
    Dim ws As Worksheet
    Dim dict As Object
    Dim lastRow As Long
    Dim row As Long
    Dim key As String
    Dim outRow As Long
    Dim item As Variant

    Set ws = ActiveSheet
    Set dict = CreateObject("Scripting.Dictionary")
    dict.CompareMode = vbTextCompare

    lastRow = ws.Cells(ws.Rows.Count, "A").End(xlUp).Row

    For row = 2 To lastRow
        key = Trim$(CStr(ws.Cells(row, "A").Value2))

        If Len(key) > 0 Then
            If dict.Exists(key) Then
                dict(key) = CLng(dict(key)) + 1
            Else
                dict.Add key, 1
            End If
        End If
    Next row

    ws.Range("C:D").ClearContents
    ws.Range("C1").Value = "値"
    ws.Range("D1").Value = "件数"

    outRow = 2
    For Each item In dict.Keys
        ws.Cells(outRow, "C").Value = item
        ws.Cells(outRow, "D").Value = dict(item)
        outRow = outRow + 1
    Next item

    MsgBox dict.Count & " 種類を集計しました。", vbInformation
End Sub
