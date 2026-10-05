Option Explicit

Public Sub DemoBitFlags()
    Const FlagRead As Long = 1
    Const FlagWrite As Long = 2
    Const FlagDelete As Long = 4

    Dim flags As Long
    flags = FlagRead Or FlagWrite

    Debug.Print "flags      = "; flags
    Debug.Print "has Read   = "; ((flags And FlagRead) <> 0)
    Debug.Print "has Write  = "; ((flags And FlagWrite) <> 0)
    Debug.Print "has Delete = "; ((flags And FlagDelete) <> 0)

    If flags = 3 _
       And (flags And FlagRead) <> 0 _
       And (flags And FlagWrite) <> 0 _
       And (flags And FlagDelete) = 0 Then
        Debug.Print "[SUCCESS] bit flags behaved as expected"
    Else
        Debug.Print "[FAILED] unexpected bit flag result"
    End If
End Sub
