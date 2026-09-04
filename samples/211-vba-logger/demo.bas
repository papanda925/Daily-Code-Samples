Option Explicit
Public Sub Log(ByVal level As String,ByVal message As String):Debug.Print Format$(Now,"yyyy-mm-dd hh:nn:ss") & " [" & level & "] " & message:End Sub
