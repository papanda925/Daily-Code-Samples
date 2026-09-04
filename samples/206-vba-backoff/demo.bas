Option Explicit
Public Sub BackoffDemo():Dim i As Long,w As Long:For i=1 To 4:w=2^(i-1):Debug.Print "attempt " & i & " wait=" & w:Next:End Sub
