Attribute VB_Name = "OptionExplicitDemo"
Option Explicit

Public Sub Demo()
    Dim total As Long
    total = 10

    ' 次の行のコメントを外すと未宣言変数をコンパイル時に検出できます。
    ' totla = total + 5

    Debug.Print "total=" & total
End Sub
