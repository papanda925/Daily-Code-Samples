Option Explicit
Public Sub ParseZenginLike():Dim s As String:s="1"&"1234"&"001"&"PAPANDA             "&"0000010000":Debug.Print "種別="&Mid$(s,1,1),"銀行="&Mid$(s,2,4),"支店="&Mid$(s,6,3),"金額="&Mid$(s,29,10):End Sub
' 教育用の全銀風ダミー
