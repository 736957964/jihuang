# 饥荒工坊8并发研读流水线 Worker 守护计划
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$proc = Get-CimInstance Win32_Process -Filter "Name='python.exe'" | Where-Object { $_.CommandLine -and $_.CommandLine -match 'daemon_8_workers\.py' }
if (-not $proc) {
    Start-Process -FilePath "python.exe" -ArgumentList "$scriptDir\daemon_8_workers.py" -WorkingDirectory $scriptDir -WindowStyle Hidden
}