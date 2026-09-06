Option Explicit
Public Function CreateByName(ByVal k As String) As Object:If k="dictionary" Then Set CreateByName=CreateObject("Scripting.Dictionary") Else Err.Raise 5,,"Unknown kind"
End Function
