Option Explicit
Public Sub Command_Add(ByVal item As String):Dim r As Long:r=Sheets("Events").Cells(Rows.Count,1).End(xlUp).Row+1:Sheets("Events").Cells(r,1)=Now:Sheets("Events").Cells(r,2)=item:End Sub
Public Function Query_Count() As Long:Query_Count=Application.Max(0,Sheets("Events").Cells(Rows.Count,1).End(xlUp).Row-1):End Function
