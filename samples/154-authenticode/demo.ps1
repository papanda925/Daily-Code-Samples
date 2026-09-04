$p=(Get-Command powershell.exe).Source;Get-AuthenticodeSignature $p|Select Path,Status,StatusMessage,SignerCertificate
