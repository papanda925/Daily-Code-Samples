Option Explicit
Public CancelRequested As Boolean
Public Sub LongTask():Dim i As Long:CancelRequested=False:For i=1 To 1000000:If CancelRequested Then Debug.Print "cancelled":Exit Sub:If i Mod 10000=0 Then DoEvents:Next:End Sub
Public Sub CancelTask():CancelRequested=True:End Sub
