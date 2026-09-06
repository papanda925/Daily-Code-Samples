Option Explicit

Private Const adTypeText As Long = 2
Private Const adSaveCreateOverWrite As Long = 2

Public Sub SaveUtf8Bom(ByVal filePath As String, ByVal text As String)
    Dim stream As Object

    Set stream = CreateObject("ADODB.Stream")

    On Error GoTo CleanFail

    stream.Type = adTypeText
    stream.Open
    stream.Position = 0
    stream.Charset = "utf-8"
    stream.WriteText text
    stream.SaveToFile filePath, adSaveCreateOverWrite

CleanExit:
    If Not stream Is Nothing Then
        If stream.State <> 0 Then stream.Close
    End If

    Set stream = Nothing
    Exit Sub

CleanFail:
    Dim message As String
    message = "UTF-8保存に失敗しました。" & vbCrLf & _
              Err.Number & ": " & Err.Description
    Resume CleanExit
End Sub

Public Sub DemoSaveUtf8Bom()
    Dim filePath As String

    filePath = ThisWorkbook.Path & "\sample-utf8.txt"

    SaveUtf8Bom filePath, _
        "日本語とEnglishをUTF-8で保存します。" & vbCrLf & _
        "2行目です。"

    MsgBox "保存先: " & filePath, vbInformation
End Sub
