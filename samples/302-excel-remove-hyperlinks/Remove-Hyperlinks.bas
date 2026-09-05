Attribute VB_Name = "RemoveHyperlinks"
Option Explicit

' 選択しているセル範囲だけを対象に、ハイパーリンク情報をまとめて削除します。
' セルの表示文字そのものは消しません。
' 誤操作を減らすため、実行前に件数を確認し、Yes のときだけ処理します。
Public Sub RemoveHyperlinksFromSelection()
    Dim target As Range
    Dim beforeCount As Long
    Dim afterCount As Long
    Dim answer As VbMsgBoxResult

    ' Selection にはセル以外（図形など）が入ることもあります。
    ' このサンプルはセル範囲だけを対象にしたいため、Range 以外なら終了します。
    If TypeName(Selection) <> "Range" Then
        MsgBox "セル範囲を選択してから実行してください。", vbInformation
        Exit Sub
    End If

    Set target = Selection

    ' 変更前に対象件数を数えます。
    ' いきなり削除せず、まず現在状態を見ることで誤操作を減らします。
    beforeCount = target.Hyperlinks.Count

    If beforeCount = 0 Then
        MsgBox "選択範囲にハイパーリンクはありません。変更は行いませんでした。", vbInformation
        Exit Sub
    End If

    answer = MsgBox( _
        "選択範囲に " & beforeCount & " 件のハイパーリンクがあります。" & vbCrLf & _
        "リンク情報だけを削除しますか？", _
        vbQuestion + vbYesNo + vbDefaultButton2, _
        "ハイパーリンクの一括解除")

    If answer <> vbYes Then
        MsgBox "キャンセルしました。変更は行っていません。", vbInformation
        Exit Sub
    End If

    ' Hyperlinks.Delete はリンク情報を削除します。
    ' Range.Clear や Range.Delete ではないため、セルの表示文字を消す処理ではありません。
    target.Hyperlinks.Delete

    ' 処理後にもう一度件数を確認し、利用者自身が結果を判定できるようにします。
    afterCount = target.Hyperlinks.Count

    MsgBox _
        "処理前: " & beforeCount & " 件" & vbCrLf & _
        "処理後: " & afterCount & " 件", _
        vbInformation, _
        "処理結果"
End Sub
