Attribute VB_Name = "LastRowComparison"
Option Explicit

' 対象はマクロを保存したブックにある検証用シートだけ。
' 読み取り専用。選択セルやActiveSheetに依存しない。
Public Sub CompareLastRowMethods()
    Dim ws As Worksheet
    Dim lastColumnA As Long
    Dim foundFormula As Range
    Dim foundValue As Range

    On Error GoTo ErrorHandler
    Set ws = ThisWorkbook.Worksheets("検証用")

    ' xlUpはEndキーを押したときのセル移動に相当する。
    ' A列を走査するのでB列以降の値は考慮しない。
    lastColumnA = ws.Cells(ws.Rows.Count, "A").End(xlUp).Row

    ' Findの引数は検索ダイアログの前回設定に影響されるため、
    ' 省略せず指定する。Nothingは該当セルなしを意味する。
    Set foundFormula = ws.Cells.Find( _
        What:="*", After:=ws.Cells(1, 1), _
        LookIn:=xlFormulas, LookAt:=xlPart, _
        SearchOrder:=xlByRows, SearchDirection:=xlPrevious, _
        MatchCase:=False, MatchByte:=False, SearchFormat:=False)

    Set foundValue = ws.Cells.Find( _
        What:="*", After:=ws.Cells(1, 1), _
        LookIn:=xlValues, LookAt:=xlPart, _
        SearchOrder:=xlByRows, SearchDirection:=xlPrevious, _
        MatchCase:=False, MatchByte:=False, SearchFormat:=False)

    If Application.CountA(ws.Columns("A")) = 0 Then
        Debug.Print "A列: データなし（Endの位置は" & lastColumnA & "）"
    Else
        Debug.Print "A列 End(xlUp): " & lastColumnA
    End If

    If foundFormula Is Nothing Then
        Debug.Print "数式も含む最終行: データなし"
    Else
        Debug.Print "数式も含む最終行: " & foundFormula.Row
    End If

    If foundValue Is Nothing Then
        Debug.Print "表示値を探す最終行: データなし"
    Else
        Debug.Print "表示値を探す最終行: " & foundValue.Row
    End If
    Exit Sub

ErrorHandler:
    ' シート名相違などの失敗を成功として表示しない。
    Debug.Print "失敗 (" & Err.Number & "): " & Err.Description
End Sub
