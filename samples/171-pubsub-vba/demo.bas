Option Explicit
Private Subscribers As Collection
Public Sub InitBus():Set Subscribers=New Collection:Subscribers.Add "OnLog":Subscribers.Add "OnUi":End Sub
Public Sub Publish(ByVal message As String):Dim x As Variant:For Each x In Subscribers:Application.Run CStr(x),message:Next:End Sub
Public Sub OnLog(ByVal message As String):Debug.Print "LOG: " & message:End Sub
Public Sub OnUi(ByVal message As String):Debug.Print "UI: " & message:End Sub
Public Sub DemoPubSub():InitBus:Publish "Hello":End Sub
