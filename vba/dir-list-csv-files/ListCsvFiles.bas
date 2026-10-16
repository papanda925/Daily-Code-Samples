Option Explicit

Public Sub ListCsvFiles()
    Dim folder As String
    Dim fileName As String
    Dim n As Long

    On Error GoTo Failed

    ' 保存前のブックではPathが空となることがあるため、
    ' 対象が不明なまま現在の作業フォルダーを検索しない。
    folder = ThisWorkbook.Path
    If Len(folder) = 0 Then
        Debug.Print "最初に練習用ブックを保存してください"
        Exit Sub
    End If

    If Right$(folder, 1) <> Application.PathSeparator Then
        folder = folder & Application.PathSeparator
    End If

    ' *.csvはこのフォルダーの直下だけが対象。
    ' Dirは最初の呼出しでパターンを指定し、その後Dir()で続ける。
    fileName = Dir(folder & "*.csv", vbNormal Or vbReadOnly)
    Do While Len(fileName) > 0
        Debug.Print fileName
        n = n + 1

        ' ループ中に別のDir(path)を実行してはならない。
        fileName = Dir()
    Loop

    Debug.Print "CSVファイル件数: " & n
    Exit Sub

Failed:
    Debug.Print "列挙に失敗: " & Err.Number & " " & Err.Description
End Sub
