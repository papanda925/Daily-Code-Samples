Option Explicit

Public Sub AuditReferences()
    Dim refs As Object
    Dim ref As Object
    Dim pathText As String

    On Error GoTo AccessDenied
    Set refs = ThisWorkbook.VBProject.References

    Debug.Print "Status", "Name", "Version", "Path / GUID"
    Debug.Print String(100, "-")

    For Each ref In refs
        If ref.IsBroken Then
            pathText = SafeGuid(ref)
            Debug.Print "BROKEN", "(broken)", "-", pathText
        Else
            Debug.Print "OK", ref.Name, ref.Major & "." & ref.Minor, ref.FullPath
        End If
    Next ref

    Exit Sub

AccessDenied:
    MsgBox "VBAプロジェクトの参照設定を取得できませんでした。" & vbCrLf & _
           "Officeの信頼設定とブックのマクロ有効状態を確認してください。" & vbCrLf & _
           "Error " & Err.Number & ": " & Err.Description, vbExclamation
End Sub

Private Function SafeGuid(ByVal ref As Object) As String
    On Error Resume Next
    SafeGuid = ref.GUID
    If Err.Number <> 0 Then
        SafeGuid = "(GUIDも取得できません)"
        Err.Clear
    End If
    On Error GoTo 0
End Function
