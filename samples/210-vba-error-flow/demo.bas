Option Explicit
Public Sub Caller():On Error GoTo EH:Worker:Exit Sub
EH:Debug.Print Err.Number & " " & Err.Description:End Sub
Private Sub Worker():Err.Raise vbObjectError+100,"Worker","demo error":End Sub
