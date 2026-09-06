Option Explicit

' ADODB.StreamをLate Bindingで使うため、
' ADOライブラリの定数名を直接参照できません。
'
' そのため、このサンプルで必要な値だけ自前のConstとして定義します。
'
' adTypeText = 2
'   Streamを「テキストモード」で扱う指定
'
' adSaveCreateOverWrite = 2
'   同名ファイルがあれば上書きする指定
Private Const adTypeText As Long = 2
Private Const adSaveCreateOverWrite As Long = 2

Public Sub SaveUtf8Bom(ByVal filePath As String, ByVal text As String)
    Dim stream As Object

    ' エラーが起きてもStreamを閉じてから呼び出し元へ返せるよう、
    ' エラー番号と説明を一時保存します。
    Dim errorNumber As Long
    Dim errorDescription As String

    ' ADODB.StreamをLate Bindingで生成します。
    '
    ' 「Microsoft ActiveX Data Objects ... Library」への
    ' 参照設定を追加しなくても使えるのが、この書き方の利点です。
    Set stream = CreateObject("ADODB.Stream")

    ' 以降でエラーが起きた場合はCleanFailへ移動します。
    On Error GoTo CleanFail

    ' Streamをテキストとして扱います。
    stream.Type = adTypeText

    ' Streamを開きます。
    ' Open前にWriteTextやSaveToFileはできません。
    stream.Open

    ' Charsetを変更する場合、
    ' ADO StreamはPosition=0である必要があります。
    '
    ' 新規Streamなので通常0ですが、
    ' 「なぜCharset設定前に0へ戻すのか」が分かるよう明示しています。
    stream.Position = 0

    ' 保存時の文字コードをUTF-8にします。
    '
    ' ADODB.StreamのUTF-8テキスト保存では、
    ' BOM付きUTF-8になるケースが一般的です。
    stream.Charset = "utf-8"

    ' VBAのStringをStreamへ書き込みます。
    stream.WriteText text

    ' Stream内容を実ファイルへ保存します。
    '
    ' 第2引数=2なので、既存ファイルがあれば上書きします。
    ' 誤上書きを避けたい用途では、この設計を変更してください。
    stream.SaveToFile filePath, adSaveCreateOverWrite

CleanExit:
    ' 正常終了でも異常終了でも、
    ' 開いているStreamは必ず閉じます。
    If Not stream Is Nothing Then
        If stream.State <> 0 Then stream.Close
    End If

    ' COMオブジェクトへの参照を解放します。
    Set stream = Nothing

    ' CleanFailを経由していた場合は、
    ' 後始末が終わったあとで元のエラーを呼び出し元へ返します。
    '
    ' 「失敗したのに成功扱い」になるのを防ぐためです。
    If errorNumber <> 0 Then
        Err.Raise errorNumber, "SaveUtf8Bom", errorDescription
    End If

    Exit Sub

CleanFail:
    ' 後始末処理の途中でErr情報が変わらないよう、
    ' まず元のエラーを変数へ退避します。
    errorNumber = Err.Number
    errorDescription = Err.Description

    ' 直接終了せず、必ずCleanExitを通してStreamを閉じます。
    Resume CleanExit
End Sub

Public Sub DemoSaveUtf8Bom()
    Dim filePath As String

    ' SaveUtf8Bom側から戻ってきたエラーは、
    ' このデモ側で利用者向けメッセージにします。
    On Error GoTo Failed

    ' このExcelブックと同じフォルダへ保存します。
    '
    ' ブックが未保存だとThisWorkbook.Pathが空になるため、
    ' 実際に使うときは保存先の前提も確認してください。
    filePath = ThisWorkbook.Path & "\sample-utf8.txt"

    ' 2行の日本語+英語テキストをUTF-8で保存します。
    SaveUtf8Bom filePath, _
        "日本語とEnglishをUTF-8で保存します。" & vbCrLf & _
        "2行目です。"

    MsgBox "保存しました: " & filePath, vbInformation
    Exit Sub

Failed:
    ' エラー番号も表示すると、
    ' 権限・パス・COM生成失敗などの切り分けに使えます。
    MsgBox "UTF-8保存に失敗しました。" & vbCrLf & _
           Err.Number & ": " & Err.Description, vbExclamation
End Sub
