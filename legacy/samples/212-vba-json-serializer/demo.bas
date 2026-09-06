Option Explicit
Public Function JsonPair(ByVal k As String,ByVal v As String) As String:JsonPair=Chr$(34)&k&Chr$(34)&":"&Chr$(34)&v&Chr$(34):End Function
Public Sub JsonDemo():Debug.Print "{" & JsonPair("name","papanda") & "}":End Sub
