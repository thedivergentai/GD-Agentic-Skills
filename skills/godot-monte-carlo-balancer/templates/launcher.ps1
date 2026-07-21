# Self-rebuilding launcher (Windows).
# Place next to the balancer crate, e.g. tools/balance_lab.ps1 with the crate in tools/balance_lab/.
# Rebuilds the optimized binary only when Cargo.toml or any src/*.rs is newer, then forwards all args.
# Designers and agents never compile manually, and never run a stale binary.

[CmdletBinding()]
param(
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]] $BalanceLabArgs
)

$manifest = Join-Path $PSScriptRoot "balance_lab\Cargo.toml"
$binary = Join-Path $PSScriptRoot "balance_lab\target\release\balance-lab.exe"
$sourceRoot = Join-Path $PSScriptRoot "balance_lab\src"
$needsBuild = -not (Test-Path -LiteralPath $binary)

if (-not $needsBuild) {
    $binaryTime = (Get-Item -LiteralPath $binary).LastWriteTimeUtc
    $manifestTime = (Get-Item -LiteralPath $manifest).LastWriteTimeUtc
    $newestSource = Get-ChildItem -LiteralPath $sourceRoot -Filter *.rs |
        Sort-Object LastWriteTimeUtc -Descending |
        Select-Object -First 1
    $needsBuild = $manifestTime -gt $binaryTime -or $newestSource.LastWriteTimeUtc -gt $binaryTime
}

if ($needsBuild) {
    cargo build --release --manifest-path $manifest
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
}

& $binary @BalanceLabArgs
exit $LASTEXITCODE
