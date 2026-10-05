$mutexName = "Local\PapandaLockDemo"
$mutex = [System.Threading.Mutex]::new($false, $mutexName)
$locked = $false

try {
    try {
        # 0msなので、他プロセスが保持中なら待ち続けません。
        $locked = $mutex.WaitOne(0)
    }
    catch [System.Threading.AbandonedMutexException] {
        # 前所有者が異常終了した場合、次の取得者に通知されます。
        Write-Warning "Abandoned mutex detected. Protected state must be verified."
        $locked = $true
    }

    if (-not $locked) {
        Write-Host "[BLOCKED] another process owns the mutex"
        exit 1
    }

    Write-Host "[SUCCESS] mutex acquired"
    Write-Host "[INFO] holding mutex for 5 seconds"
    Start-Sleep -Seconds 5
}
finally {
    if ($locked) {
        $mutex.ReleaseMutex()
    }
    $mutex.Dispose()
}
