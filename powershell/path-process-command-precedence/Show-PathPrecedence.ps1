Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$oldPath = $env:Path
$root = Join-Path $env:TEMP ('papanda-path-' + [guid]::NewGuid().ToString('N'))
$dirA = Join-Path $root 'A'
$dirB = Join-Path $root 'B'

try {
    New-Item -ItemType Directory -Path $dirA,$dirB -Force | Out-Null
    '@echo A' | Set-Content -Path (Join-Path $dirA 'papanda-demo.cmd') -Encoding Ascii
    '@echo B' | Set-Content -Path (Join-Path $dirB 'papanda-demo.cmd') -Encoding Ascii

    # 現在のPowerShellだけにテスト用PATHを追加する。User/Machine PATHは変更しない。
    $env:Path = "$dirA;$dirB;$oldPath"
    Write-Host '[BEFORE] A -> B'
    Get-Command papanda-demo.cmd -All | Select-Object Name,Source
    & papanda-demo.cmd

    # 変更するのは順序だけ。どの同名コマンドが選ばれるかを観察する。
    $env:Path = "$dirB;$dirA;$oldPath"
    Write-Host '[AFTER] B -> A'
    Get-Command papanda-demo.cmd -All | Select-Object Name,Source
    & papanda-demo.cmd
    Write-Host '[SUCCESS] Process PATH only'
}
catch {
    Write-Error "[FAILED] $($_.Exception.Message)"
    exit 1
}
finally {
    # 呼び出し元のPATHを必ず元へ戻し、一時ファイルも後始末する。
    $env:Path = $oldPath
    if (Test-Path $root) { Remove-Item $root -Recurse -Force }
}
