$ErrorActionPreference = 'Stop'

$binary = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot 'bin\xiaohongshu-mcp.exe')).Path
$pidFile = Join-Path $PSScriptRoot 'data\xiaohongshu-mcp.pid'

if (-not (Test-Path -LiteralPath $pidFile)) {
    Write-Host 'xiaohongshu-mcp is not running (PID file not found).'
    exit 0
}

$serverPid = [int](Get-Content -LiteralPath $pidFile -Raw)
$process = Get-Process -Id $serverPid -ErrorAction SilentlyContinue

if (-not $process) {
    Remove-Item -LiteralPath $pidFile -Force
    Write-Host 'xiaohongshu-mcp is not running (stale PID file removed).'
    exit 0
}

if ($process.Path -ne $binary) {
    throw "PID $serverPid does not belong to this deployment; refusing to stop it."
}

Stop-Process -Id $serverPid
Remove-Item -LiteralPath $pidFile -Force
Write-Host "xiaohongshu-mcp stopped (PID $serverPid)."

