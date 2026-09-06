Option Explicit
Public Function FindNameById(ByVal id As String) As String:Dim f As Range:Set f=Worksheets("Master").Columns(1).Find(id,LookAt:=xlWhole):If Not f Is Nothing Then FindNameById=f.Offset(0,1).Value
End Function
