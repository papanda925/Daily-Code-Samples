Option Explicit
Public Sub Hello(ByVal name As String,Optional ByVal count As Long=1):Dim i As Long:For i=1 To count:Debug.Print "Hello " & name:Next:End Sub
