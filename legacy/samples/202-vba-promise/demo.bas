Option Explicit
Public Enum TaskState:Pending=0:Running=1:Completed=2:Failed=3:Cancelled=4:End Enum
Public Sub PromiseConcept():Dim s As TaskState:s=Pending:Debug.Print s:s=Running:Debug.Print s:s=Completed:Debug.Print s:End Sub
