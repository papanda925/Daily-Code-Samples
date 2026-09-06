Option Explicit
#If VBA7 Then
Private Declare PtrSafe Function EnumWindows Lib "user32" (ByVal lpEnumFunc As LongPtr,ByVal lParam As LongPtr) As Long
#End If
Public Sub CallbackConcept():Debug.Print "AddressOfは標準モジュールのPublic Functionをcallbackへ渡す":End Sub
