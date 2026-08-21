$ErrorActionPreference = 'Stop'

$binary = Join-Path $PSScriptRoot 'bin\xiaohongshu-mcp.exe'
$dataDir = Join-Path $PSScriptRoot 'data'
$pidFile = Join-Path $dataDir 'xiaohongshu-mcp.pid'
$stdoutLog = Join-Path $dataDir 'xiaohongshu-mcp.stdout.log'
$stderrLog = Join-Path $dataDir 'xiaohongshu-mcp.stderr.log'
$healthUrl = 'http://127.0.0.1:18060/health'

function Open-McpPage {
    Start-Process -FilePath $healthUrl
}

if (-not (Test-Path -LiteralPath $binary)) {
    throw "MCP binary not found: $binary"
}

New-Item -ItemType Directory -Force -Path $dataDir | Out-Null

if (Test-Path -LiteralPath $pidFile) {
    $existingPid = [int](Get-Content -LiteralPath $pidFile -Raw)
    $existing = Get-Process -Id $existingPid -ErrorAction SilentlyContinue
    if ($existing) {
        Write-Host "xiaohongshu-mcp is already running (PID $existingPid)."
        Open-McpPage
        exit 0
    }
    Remove-Item -LiteralPath $pidFile -Force
}

$env:COOKIES_PATH = Join-Path $dataDir 'cookies.json'
@('HTTP_PROXY', 'HTTPS_PROXY', 'ALL_PROXY', 'http_proxy', 'https_proxy', 'all_proxy') |
    ForEach-Object { Remove-Item -LiteralPath "Env:$_" -ErrorAction SilentlyContinue }
$process = Start-Process -FilePath $binary `
    -ArgumentList @('-headless=true', '-port', '127.0.0.1:18060') `
    -WorkingDirectory $PSScriptRoot `
    -RedirectStandardOutput $stdoutLog `
    -RedirectStandardError $stderrLog `
    -WindowStyle Hidden `
    -PassThru

Set-Content -LiteralPath $pidFile -Value $process.Id -NoNewline

for ($attempt = 1; $attempt -le 20; $attempt++) {
    Start-Sleep -Milliseconds 500
    try {
        $response = Invoke-RestMethod -Uri $healthUrl -TimeoutSec 2
        Write-Host "xiaohongshu-mcp is running (PID $($process.Id))."
        Write-Host 'MCP endpoint: http://127.0.0.1:18060/mcp'
        Write-Output $response
        Open-McpPage
        exit 0
    }
    catch {
        if ($process.HasExited) {
            throw "xiaohongshu-mcp exited early. See $stderrLog"
        }
    }
}

throw "xiaohongshu-mcp did not become healthy. See $stderrLog"
