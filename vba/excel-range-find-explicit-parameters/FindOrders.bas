Attribute VB_Name = "FindOrders"
Option Explicit

' このサンプル専用シート名。既存シートを黙って上書きしない。
Private Const SAMPLE_SHEET As String = "FindSample"

' 架空データを新しいシートへ作る。同名シートがある場合は停止する。
Public Sub CreateFictionalFindSample()
    Dim ws As Worksheet

    If WorksheetExists(ThisWorkbook, SAMPLE_SHEET) Then
        MsgBox SAMPLE_SHEET & " は既にあります。既存シートを削除せず処理を停止しました。", vbExclamation
        Exit Sub
    End If

    Set ws = ThisWorkbook.Worksheets.Add( _
        After:=ThisWorkbook.Worksheets(ThisWorkbook.Worksheets.Count))
    ws.Name = SAMPLE_SHEET

    ws.Range("A1").Value = "注文番号"
    ws.Range("A2").Value = "A-101"
    ws.Range("A3").Value = "A-102"
    ws.Range("A4").Value = "XA-102"
    ws.Range("A5").Value = "A-103"

    MsgBox "架空データを " & SAMPLE_SHEET & "!A1:A5 に作成しました。", vbInformation
End Sub

' 完全一致で1件を探す。見つからない場合はNothingを返す。
Public Function FindOrderWhole( _
    ByVal targetSheet As Worksheet, _
    ByVal orderId As String _
) As Range
    Dim area As Range

    If Len(orderId) = 0 Then Exit Function

    Set area = targetSheet.Range("A2:A5")
    Set FindOrderWhole = area.Find( _
        What:=orderId, _
        After:=area.Cells(area.Cells.Count), _
        LookIn:=xlValues, _
        LookAt:=xlWhole, _
        SearchOrder:=xlByRows, _
        SearchDirection:=xlNext, _
        MatchCase:=False, _
        MatchByte:=False, _
        SearchFormat:=False)
End Function

' 部分一致するセルのアドレスをすべて返す。
' FindNextは末尾から先頭へ周回するため、最初のアドレスへ戻ったら終了する。
Public Function FindOrderFragments( _
    ByVal targetSheet As Worksheet, _
    ByVal fragment As String _
) As Collection
    Dim results As New Collection
    Dim area As Range
    Dim hit As Range
    Dim firstAddress As String

    If Len(fragment) = 0 Then
        Set FindOrderFragments = results
        Exit Function
    End If

    Set area = targetSheet.Range("A2:A5")
    Set hit = area.Find( _
        What:=fragment, _
        After:=area.Cells(area.Cells.Count), _
        LookIn:=xlValues, _
        LookAt:=xlPart, _
        SearchOrder:=xlByRows, _
        SearchDirection:=xlNext, _
        MatchCase:=False, _
        MatchByte:=False, _
        SearchFormat:=False)

    If hit Is Nothing Then
        Set FindOrderFragments = results
        Exit Function
    End If

    firstAddress = hit.Address
    Do
        results.Add hit.Address(False, False)
        Set hit = area.FindNext(After:=hit)
        If hit Is Nothing Then Exit Do
    Loop While hit.Address <> firstAddress

    Set FindOrderFragments = results
End Function

' イミディエイトウィンドウへ期待値と結果を出す手動スモークテスト。
Public Sub RunRangeFindSmokeTest()
    Dim ws As Worksheet
    Dim hit As Range
    Dim fragments As Collection
    Dim missing As Range
    Dim item As Variant

    If Not WorksheetExists(ThisWorkbook, SAMPLE_SHEET) Then
        Debug.Print "FAILED: 先に CreateFictionalFindSample を実行してください。"
        Exit Sub
    End If

    Set ws = ThisWorkbook.Worksheets(SAMPLE_SHEET)

    Set hit = FindOrderWhole(ws, "A-102")
    Debug.Print "完全一致の期待値=A3"
    Debug.Print "完全一致の結果=" & AddressOrNotFound(hit)

    Set fragments = FindOrderFragments(ws, "A-102")
    Debug.Print "部分一致の期待値=A3,A4 / 件数=2"
    For Each item In fragments
        Debug.Print "部分一致の結果=" & CStr(item)
    Next item
    Debug.Print "部分一致の件数=" & fragments.Count

    Set missing = FindOrderWhole(ws, "A-999")
    Debug.Print "0件の期待値=一致なし"
    Debug.Print "0件の結果=" & AddressOrNotFound(missing)
End Sub

Private Function AddressOrNotFound(ByVal hit As Range) As String
    If hit Is Nothing Then
        AddressOrNotFound = "一致なし"
    Else
        AddressOrNotFound = hit.Address(False, False)
    End If
End Function

Private Function WorksheetExists( _
    ByVal workbookValue As Workbook, _
    ByVal sheetName As String _
) As Boolean
    Dim ws As Worksheet

    On Error Resume Next
    Set ws = workbookValue.Worksheets(sheetName)
    On Error GoTo 0

    WorksheetExists = Not ws Is Nothing
End Function
