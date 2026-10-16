Option Explicit

' 商品表のA2:A100を検索する教材。
' ThisWorkbookを指定して、誤って別ブックを参照しない。
Public Sub FindProductCodeDemo()
    FindOneCode "P102"
    FindOneCode "P999"
End Sub

Private Sub FindOneCode(ByVal productCode As String)
    Dim ws As Worksheet
    Dim searchRange As Range
    Dim foundPosition As Variant
    Dim duplicateCount As Double

    On Error GoTo Failed
    Set ws = ThisWorkbook.Worksheets("商品表")
    Set searchRange = ws.Range("A2:A100")

    If Len(Trim$(productCode)) = 0 Then
        Debug.Print "入力が空白です"
        Exit Sub
    End If

    ' Application.Matchは該当なしをエラー値で返す場合がある。
    ' Variantで受けた後、IsErrorで検査してから数値に変換する。
    foundPosition = Application.Match(productCode, searchRange, 0)
    If IsError(foundPosition) Then
        Debug.Print productCode & ": 見つかりません"
        Exit Sub
    End If

    ' Matchの位置は範囲内の1始まり。シートの行番号と混同しない。
    Debug.Print productCode & ": " & CLng(foundPosition) & "番目"
    Debug.Print "セル: " & searchRange.Cells(CLng(foundPosition), 1).Address(False, False)

    ' 同じコードが複数ある場合は黙って正解を一つに決めない。
    duplicateCount = Application.CountIf(searchRange, productCode)
    If duplicateCount > 1 Then
        Debug.Print "注意: 一致候補が " & duplicateCount & " 件あります"
    End If
    Exit Sub

Failed:
    Debug.Print productCode & ": 実行に失敗しました " & _
                Err.Number & " " & Err.Description
End Sub
