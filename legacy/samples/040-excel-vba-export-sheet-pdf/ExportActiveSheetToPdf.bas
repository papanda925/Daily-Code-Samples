Option Explicit

Public Sub 今見ているシートをPDFへ保存する()

    Dim outputPath As String

    ' ブックを一度も保存していない場合は保存先が決められません。
    If ThisWorkbook.Path = "" Then
        MsgBox "先にExcelブックを保存してください。", vbInformation
        Exit Sub
    End If

    ' ブックと同じフォルダーへ「シート名.pdf」で出力します。
    outputPath = ThisWorkbook.Path & Application.PathSeparator _
               & ActiveSheet.Name & ".pdf"

    ActiveSheet.ExportAsFixedFormat _
        Type:=xlTypePDF, _
        Filename:=outputPath, _
        Quality:=xlQualityStandard, _
        IncludeDocProperties:=True, _
        IgnorePrintAreas:=False, _
        OpenAfterPublish:=False

    MsgBox "PDFを保存しました。" & vbCrLf & outputPath, vbInformation

End Sub
