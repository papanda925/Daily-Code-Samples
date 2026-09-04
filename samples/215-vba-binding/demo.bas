Option Explicit
Public Sub LateBindingDemo():Dim d As Object:Set d=CreateObject("Scripting.Dictionary"):d.Add "A",1:Debug.Print d("A"):End Sub
