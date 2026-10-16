Option Explicit

' このコードはThisWorkbook内の「表示確認」シートを読み取るだけ。
' 実行しても既存セルの値・表示形式・列幅・ブックを変更しない。
Public Sub InspectDisplayAndValue2()
    Dim ws As Worksheet
    Dim addr As Variant
    Dim cell As Range
    Dim raw As Variant
    Dim display As Variant

    On Error GoTo Failed
    Set ws = ThisWorkbook.Worksheets("表示確認")

    For Each addr In Array("A2", "B2", "C2")
        Set cell = ws.Range(CStr(addr))

        ' Value2は表示文字列ではなく格納値のVariant。
        ' 日付/通貨のExcelセルでも、Date/Currency型には変換しない。
        raw = cell.Value2

        ' Textはセルの書式・列幅を反映した画面表示の文字列。
        ' 複数セル範囲へ直接適用するとNullの場合があるので単一セルにする。
        display = cell.Text

        Debug.Print cell.Address(False, False) & " " & _
                    "Value2[" & TypeName(raw) & "]=" & CStr(raw) & _
                    " / Text=" & CStr(display)
    Next addr
    Exit Sub

Failed:
    Debug.Print "セルの参照に失敗: " & Err.Number & " " & Err.Description
End Sub
