Option Explicit
Public Sub ByRefDemo(ByRef x As Long):x=99:End Sub
Public Sub Demo():Dim n As Long:n=1:ByRefDemo n:Debug.Print n:End Sub
