Option Explicit
Public Sub ScheduleDemo():Application.OnTime Now+TimeSerial(0,0,3),"OnTimeCallback":End Sub
Public Sub OnTimeCallback():Debug.Print "callback " & Now:End Sub
