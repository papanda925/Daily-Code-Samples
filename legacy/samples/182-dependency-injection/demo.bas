Option Explicit
Public Sub RunWithService(ByVal serviceName As String):Debug.Print "Injected service: " & serviceName:If serviceName="Mock" Then Debug.Print "TEST" Else Debug.Print "REAL"
End Sub
