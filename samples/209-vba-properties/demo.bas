Option Explicit
Private mName As String
Public Property Get Name() As String:Name=mName:End Property
Public Property Let Name(ByVal value As String):If Len(value)=0 Then Err.Raise 5:mName=value:End Property
' クラスモジュールへ配置
