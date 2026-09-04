Option Explicit
Private Function SimpleHash(ByVal s As String) As Long
Dim i As Long,h As Long:h=5381:For i=1 To Len(s):h=((h*33) Xor AscW(Mid$(s,i,1))) And &H7FFFFFFF:Next:SimpleHash=h
End Function
Public Sub BuildMiniChain():Dim prev As String,r As Long:prev="GENESIS":For r=2 To 5:Cells(r,1)=r-1:Cells(r,2)=Choose(r-1,"A","B","C","D"):Cells(r,3)=prev:Cells(r,4)=CStr(SimpleHash(prev & "|" & Cells(r,2))):prev=Cells(r,4):Next:End Sub
