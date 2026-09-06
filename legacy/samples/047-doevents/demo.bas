Option Explicit
Public Sub DoEventsDemo()
    Dim i As Long
    For i = 1 To 300000
        If i Mod 10000 = 0 Then Debug.Print i: DoEvents
    Next
End Sub
