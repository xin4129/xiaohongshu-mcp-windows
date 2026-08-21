$ErrorActionPreference = 'Stop'

$binary = Join-Path $PSScriptRoot 'bin\xiaohongshu-login.exe'
$dataDir = Join-Path $PSScriptRoot 'data'

if (-not (Test-Path -LiteralPath $binary)) {
    throw "Login binary not found: $binary"
}

New-Item -ItemType Directory -Force -Path $dataDir | Out-Null
$env:COOKIES_PATH = Join-Path $dataDir 'cookies.json'
@('HTTP_PROXY', 'HTTPS_PROXY', 'ALL_PROXY', 'http_proxy', 'https_proxy', 'all_proxy') |
    ForEach-Object { Remove-Item -LiteralPath "Env:$_" -ErrorAction SilentlyContinue }

Write-Host 'A Chrome window will open. Scan the QR code with the Xiaohongshu app.'
& $binary
if ($LASTEXITCODE -ne 0) {
    throw "Login tool exited with code $LASTEXITCODE."
}
