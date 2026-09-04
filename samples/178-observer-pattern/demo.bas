Option Explicit
Private observers As Collection
Public Sub InitObservers():Set observers=New Collection:observers.Add "ObserverA":observers.Add "ObserverB":End Sub
Public Sub NotifyAll(ByVal s As String):Dim x As Variant:For Each x In observers:Application.Run CStr(x),s:Next:End Sub
Public Sub ObserverA(ByVal s As String):Debug.Print "A:" & s:End Sub
Public Sub ObserverB(ByVal s As String):Debug.Print "B:" & s:End Sub
