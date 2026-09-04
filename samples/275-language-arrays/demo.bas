Option Explicit
Public Sub Demo():Dim a(0 To 2) As String:a(0)="A":a(1)="B":a(2)="C":Debug.Print a(0),UBound(a)-LBound(a)+1:End Sub
