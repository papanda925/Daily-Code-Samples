Option Explicit
Public Sub ParseFixedWidth():Dim s As String:s="01PAPANDA925          0000010000":Debug.Print Mid$(s,1,2),Trim$(Mid$(s,3,20)),CLng(Mid$(s,23,10)):End Sub
