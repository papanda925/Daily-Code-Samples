Option Explicit
Public Function ApplyStrategy(ByVal x As Double,ByVal s As String) As Double:If s="double" Then ApplyStrategy=x*2 ElseIf s="square" Then ApplyStrategy=x*x Else ApplyStrategy=x
End Function
