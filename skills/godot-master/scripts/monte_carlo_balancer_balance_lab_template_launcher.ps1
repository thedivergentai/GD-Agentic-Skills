# Self-rebuilding launcher (Windows).
# Install as: tools/balance_lab.ps1  with crate at tools/balance_lab/
# Rebuilds release binary when Cargo.toml or any src/*.rs is newer, then forwards args.

[CmdletBinding()]
param(
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]] $BalanceLabArgs
)

$crate = Join-Path $PSScriptRoot "balance_lab"
$manifest = Join-Path $crate "Cargo.toml"
$binary = Join-Path $crate "target\release\balance-lab.exe"
$sourceRoot = Join-Path $crate "src"
$needsBuild = -not (Test-Path -LiteralPath $binary)

if (-not $needsBuild) {
    $binaryTime = (Get-Item -LiteralPath $binary).LastWriteTimeUtc
    $manifestTime = (Get-Item -LiteralPath $manifest).LastWriteTimeUtc
    $newestSource = Get-ChildItem -LiteralPath $sourceRoot -Filter *.rs -Recurse |
        Sort-Object LastWriteTimeUtc -Descending |
        Select-Object -First 1
    $needsBuild = $manifestTime -gt $binaryTime -or (
        $null -ne $newestSource -and $newestSource.LastWriteTimeUtc -gt $binaryTime
    )
}

if ($needsBuild) {
    cargo build --release --manifest-path $manifest
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
}

& $binary @BalanceLabArgs
exit $LASTEXITCODE
