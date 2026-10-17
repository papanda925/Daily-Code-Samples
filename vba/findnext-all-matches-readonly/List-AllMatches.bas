Option Explicit
' このコードは「検索練習」シートのA2:A30を読むだけ。
' 検索ダイアログに残った条件の影響を避け、主要引数を明示する。
Public Sub ListMatchingCells()
    Dim ws As Worksheet
    Dim searchRange As Range
    Dim hit As Range
    Dim firstAddress As String
    Dim n As Long

    On Error GoTo Failed
    Set ws = ThisWorkbook.Worksheets("検索練習")
    Set searchRange = ws.Range("A2:A30")
    Set hit = searchRange.Find(What:="P101", _
        After:=searchRange.Cells(searchRange.Cells.Count), _
        LookIn:=xlValues, LookAt:=xlWhole, _
        SearchOrder:=xlByRows, SearchDirection:=xlNext, _
        MatchCase:=False, SearchFormat:=False)

    If hit Is Nothing Then
        Debug.Print "一致するセルはありません"
        Exit Sub
    End If

    firstAddress = hit.Address
    Do
        n = n + 1
        Debug.Print "一致 " & n & ": " & hit.Address(False, False)
        Set hit = searchRange.FindNext(After:=hit)
        If hit Is Nothing Then Exit Do
    Loop While hit.Address <> firstAddress

    Debug.Print "一致件数: " & n
    Exit Sub
Failed:
    Debug.Print "検索に失敗しました: " & Err.Number & " " & Err.Description
End Sub
