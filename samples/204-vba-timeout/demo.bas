Option Explicit
Public Sub TimeoutLoop():Dim s As Single:s=Timer:Do While Timer-s<5:DoEvents:If Timer-s>2 Then Debug.Print "timeout":Exit Do:Loop:End Sub
