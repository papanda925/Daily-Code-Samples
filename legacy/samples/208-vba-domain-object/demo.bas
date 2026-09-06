Option Explicit
Public Sub DomainObjectDemo():Dim items As New Collection,d As Object:Set d=CreateObject("Scripting.Dictionary"):d("Id")=1:d("Name")="A":items.Add d:Debug.Print items(1)("Name"):End Sub
