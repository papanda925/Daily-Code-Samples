Option Explicit
Public Sub RebuildBalance():Dim r As Long,balance As Currency:For r=2 To Cells(Rows.Count,1).End(xlUp).Row:balance=balance+CCur(Cells(r,2).Value):Cells(r,3).Value=balance:Next:End Sub
