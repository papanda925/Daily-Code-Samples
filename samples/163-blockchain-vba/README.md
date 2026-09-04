# 163: Excel VBAでセルが変わると壊れるBlockchainを可視化する

> **実験サンプル / 深掘り / 約10〜25分**

## このサンプルで体験すること
短い実験で「Excel VBAでセルが変わると壊れるBlockchainを可視化する」を体験し、操作前後の状態やログの差を確認する。

完成品ライブラリではなく、**仕組みを短いコードで再現し、状態・ログ・差分を見る教材**です。

## 実行
1. `demo.bas` を読む。
2. 自分のテストデータだけで実行する。
3. 入力を1か所変え、出力・Hash・状態・ログ等の差を比較する。

## 最小コード
```vb
Option Explicit
Private Function SimpleHash(ByVal s As String) As Long
Dim i As Long,h As Long:h=5381:For i=1 To Len(s):h=((h*33) Xor AscW(Mid$(s,i,1))) And &H7FFFFFFF:Next:SimpleHash=h
End Function
Public Sub BuildMiniChain():Dim prev As String,r As Long:prev="GENESIS":For r=2 To 5:Cells(r,1)=r-1:Cells(r,2)=Choose(r-1,"A","B","C","D"):Cells(r,3)=prev:Cells(r,4)=CStr(SimpleHash(prev & "|" & Cells(r,2))):prev=Cells(r,4):Next:End Sub
```

## 見るポイント
- 同じ入力と違う入力で何が変わるか。
- 状態遷移や設計パターンで、責務をどこへ分けているか。
- セキュリティでは暗号化・Hash・署名・権限など目的の違い。
- VBAではクラス・イベント・COMで言語機能をどう補うか。

## 技術の層
```text
VBA / PowerShell → Pattern / Algorithm → Architecture concepts
```

## 安全性
攻撃・侵入・認証回避の教材ではありません。自分の文字列、一時ファイル、localhost、自分のWindows設定の観察に限定します。

## 発展
PowerShell版とVBA版を作り比べ、標準機能だけで同じ概念をどこまで再現できるか試してください。
