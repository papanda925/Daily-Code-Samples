# クリップボードの本文は読みません。変更を示すsequence numberだけ取得します。
Add-Type @'
using System.Runtime.InteropServices;
public static class ClipboardNative {
  [DllImport("user32.dll")]
  public static extern uint GetClipboardSequenceNumber();
}
'@

$before = [ClipboardNative]::GetClipboardSequenceNumber()
Write-Host "[START] Sequence=$before"
Read-Host '何かをコピーしてから Enter'
$after = [ClipboardNative]::GetClipboardSequenceNumber()

if ($after -ne $before) {
    Write-Host "[SUCCESS] Clipboard changed: $before -> $after"
} else {
    Write-Host '[RESULT] 変更を検出できませんでした'
}
