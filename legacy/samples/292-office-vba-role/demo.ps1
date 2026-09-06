$excel=Get-Command excel.exe -EA 0;[pscustomobject]@{ExcelInstalled=[bool]$excel;Strength='Office Object Model';Weakness='modern async/awaitや継承は限定的'}
