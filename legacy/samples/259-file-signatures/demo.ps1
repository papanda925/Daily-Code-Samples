param([string]$Path="$env:WINDIR\System32\notepad.exe");$b=[IO.File]::ReadAllBytes($Path)[0..15];"First16="+(($b|%{$_.ToString('X2')})-join' ')
