Option Explicit

Private Const adTypeText As Long = 2
Private Const adSaveCreateOverWrite As Long = 2

Public Sub SaveUtf8Bom(ByVal filePath As String, ByVal text As String)
    Dim stream As Object
    Dim errorNumber As Long
    Dim errorDescription As String

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

    If errorNumber <> 0 Then
        Err.Raise errorNumber, "SaveUtf8Bom", errorDescription
    End If

    Exit Sub

CleanFail:
    errorNumber = Err.Number
    errorDescription = Err.Description
    Resume CleanExit
End Sub

Public Sub DemoSaveUtf8Bom()
    Dim filePath As String

    On Error GoTo Failed

    filePath = ThisWorkbook.Path & "\sample-utf8.txt"

    SaveUtf8Bom filePath, _
        "日本語とEnglishをUTF-8で保存します。" & vbCrLf & _
        "2行目です。"

    MsgBox "保存しました: " & filePath, vbInformation
    Exit Sub

Failed:
    MsgBox "UTF-8保存に失敗しました。" & vbCrLf & _
           Err.Number & ": " & Err.Description, vbExclamation
End Sub
