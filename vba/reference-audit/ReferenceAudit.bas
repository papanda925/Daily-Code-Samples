Option Explicit

Public Sub AuditReferences()
    Dim refs As Object
    Dim ref As Object
    Dim pathText As String
    Dim totalCount As Long
    Dim brokenCount As Long

    On Error GoTo AccessDenied

    Debug.Print "[START] VBA参照設定を確認します"
    Set refs = ThisWorkbook.VBProject.References

    Debug.Print "Status", "Name", "Version", "Path / GUID"
    Debug.Print String(100, "-")

    For Each ref In refs
        totalCount = totalCount + 1

        If ref.IsBroken Then
            brokenCount = brokenCount + 1
            ' IsBroken=True の参照で FullPath を読むとエラーになるため、
            ' 壊れた参照では FullPath を触らず GUID の取得だけを試す。
            pathText = SafeGuid(ref)
            Debug.Print "[BROKEN]", "(broken)", "-", pathText
        Else
            Debug.Print "[OK]", ref.Name, ref.Major & "." & ref.Minor, ref.FullPath
        End If
    Next ref

    Debug.Print "[RESULT] Total=" & totalCount & " Broken=" & brokenCount

    If brokenCount = 0 Then
        MsgBox "[SUCCESS] BROKEN参照は見つかりませんでした。" & vbCrLf & _
               "Total: " & totalCount, vbInformation
    Else
        MsgBox "[RESULT] BROKEN参照が " & brokenCount & " 件あります。" & vbCrLf & _
               "イミディエイトウィンドウの [BROKEN] 行を確認してください。", vbExclamation
    End If

    Exit Sub

AccessDenied:
    MsgBox "[FAILED] VBAプロジェクトの参照設定を取得できませんでした。" & vbCrLf & _
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
