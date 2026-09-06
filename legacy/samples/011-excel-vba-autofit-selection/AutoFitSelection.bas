Option Explicit

Public Sub 選択範囲の列幅を自動調整する()

    ' セルが選択されているか確認します。
    ' 図形などを選択している状態では、
    ' Selection.Columns をそのまま使えないため先に判定します。
    If TypeName(Selection) <> "Range" Then
        MsgBox "列幅を調整したいセル範囲を選択してください。", vbInformation
        Exit Sub
    End If

    ' 選択したセルを含む列だけ、
    ' 内容に合わせて列幅を自動調整します。
    Selection.Columns.AutoFit

    MsgBox "選択範囲の列幅を自動調整しました。", vbInformation

End Sub
