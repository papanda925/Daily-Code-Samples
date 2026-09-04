Option Explicit
Public Sub Demo():On Error GoTo EH:Err.Raise 5:Exit Sub
EH:Debug.Print "caught " & Err.Number:End Sub
