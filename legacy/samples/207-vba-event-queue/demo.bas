Option Explicit
Private q As Collection
Public Sub QueueInit():Set q=New Collection:End Sub
Public Sub Enqueue(ByVal s As String):q.Add s:End Sub
Public Sub Drain():Do While q.Count>0:Debug.Print q(1):q.Remove 1:Loop:End Sub
