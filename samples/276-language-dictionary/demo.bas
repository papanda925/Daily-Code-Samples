Option Explicit
Public Sub Demo():Dim d As Object:Set d=CreateObject("Scripting.Dictionary"):d("A")=1:d("B")=2:Debug.Print d("A"):End Sub
