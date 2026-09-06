Sub DemoDoEvents()

    Const MaxCount As Long = 5000000
    Dim i As Long

    On Error GoTo CleanUp

    For i = 1 To MaxCount
        If i Mod 10000 = 0 Then
            Application.StatusBar = _
                "Processing: " & Format(i / MaxCount, "0%")
            DoEvents
        End If
    Next i

CleanUp:
    Application.StatusBar = False

End Sub

' ===== 次のサンプル =====

Private mRunning As Boolean

Sub LongTask()

    Const MaxCount As Long = 5000000
    Dim i As Long

    If mRunning Then
        MsgBox "すでに実行中です。"
        Exit Sub
    End If

    mRunning = True
    On Error GoTo CleanUp

    For i = 1 To MaxCount
        If i Mod 10000 = 0 Then
            Application.StatusBar = _
                "Processing: " & Format(i / MaxCount, "0%")
            DoEvents
        End If
    Next i

CleanUp:
    Application.StatusBar = False
    mRunning = False

End Sub
