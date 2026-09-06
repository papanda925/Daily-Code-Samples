param([string]$Path);if(!$Path){"自分のxlsx/docx/pptxを-Path指定";return};$b=[IO.File]::ReadAllBytes($Path);($b[0..3]|%{$_.ToString('X2')})-join' '
