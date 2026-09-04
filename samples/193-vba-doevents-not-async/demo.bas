Option Explicit
Public Sub CompareDoEvents():Dim i As Long:For i=1 To 300000:If i Mod 10000=0 Then DoEvents:Debug.Print i:Next:End Sub
