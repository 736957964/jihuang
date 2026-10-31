# 饥荒工坊8并发研读流水线 Worker 守护计划
$proc = Get-CimInstance Win32_Process -Filter "Name='python.exe'" | Where-Object { $_.CommandLine -and $_.CommandLine -match 'daemon_8_workers\.py' }
if (-not $proc) {
    Start-Process -FilePath "python.exe" -ArgumentList "C:\Users\Administrator\Desktop\阿鲸工作文件夹\jihuang-main\daemon_8_workers.py" -WorkingDirectory "C:\Users\Administrator\Desktop\阿鲸工作文件夹\jihuang-main" -WindowStyle Hidden
}
