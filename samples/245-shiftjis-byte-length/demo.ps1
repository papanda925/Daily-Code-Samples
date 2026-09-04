$s='ABCあいう';$sj=[Text.Encoding]::GetEncoding(932);$u=[Text.Encoding]::UTF8;[pscustomobject]@{Text=$s;Characters=$s.Length;ShiftJisBytes=$sj.GetByteCount($s);Utf8Bytes=$u.GetByteCount($s)}
