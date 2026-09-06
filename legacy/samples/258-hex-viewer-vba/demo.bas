Option Explicit
Public Sub HexView():Dim p As String:p=Environ$("WINDIR") & "\win.ini":Dim n As Integer:n=FreeFile:Open p For Binary As #n:Dim b() As Byte:ReDim b(0 To 63):Get #n,,b:Close #n:Dim i As Long:For i=0 To UBound(b):Debug.Print Right$("0"&Hex$(b(i)),2);" ";:If (i+1) Mod 16=0 Then Debug.Print:Next:End Sub
