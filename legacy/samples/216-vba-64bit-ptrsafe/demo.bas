Option Explicit
#If VBA7 Then
Private Declare PtrSafe Function GetTickCount64 Lib "kernel32" () As LongLong
#End If
Public Sub BitnessDemo():Debug.Print "VBA7=" & VBA7 & " Win64=" & Win64:End Sub
