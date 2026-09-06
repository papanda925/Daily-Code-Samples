Option Explicit
Private mRunning As Boolean
Public Sub ReentrancyDemo()
    If mRunning Then Debug.Print "二重実行を検出": Exit Sub
    mRunning = True
    Dim i As Long
    For i = 1 To 500000
        If i Mod 10000 = 0 Then DoEvents
    Next
    mRunning = False
End Sub
