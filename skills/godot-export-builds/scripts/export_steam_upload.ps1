# export_steam_upload.ps1
# Automate SteamPipe uploads via steamcmd + VDF app build manifests.
# Credentials MUST come from environment variables — never commit passwords.

param(
    [Parameter(Mandatory = $true)]
    [string]$AppBuildVdf,

    [string]$SteamCmd = $env:STEAMCMD_PATH,
    [string]$SteamUser = $env:STEAM_USER,
    [string]$SteamPass = $env:STEAM_PASS,
    [string]$SteamGuard = $env:STEAM_GUARD
)

$ErrorActionPreference = "Stop"

if (-not $SteamCmd -or -not (Test-Path $SteamCmd)) {
    throw "Set STEAMCMD_PATH to steamcmd.exe (or pass -SteamCmd)."
}
if (-not (Test-Path $AppBuildVdf)) {
    throw "App build VDF not found: $AppBuildVdf"
}
if (-not $SteamUser -or -not $SteamPass) {
    throw "Set STEAM_USER and STEAM_PASS (and STEAM_GUARD if required)."
}

Write-Host "Running SteamPipe build: $AppBuildVdf"
$loginArgs = @("+login", $SteamUser, $SteamPass)
if ($SteamGuard) {
    $loginArgs += $SteamGuard
}

& $SteamCmd @loginArgs "+run_app_build" (Resolve-Path $AppBuildVdf).Path "+quit"
if ($LASTEXITCODE -ne 0) {
    throw "steamcmd failed with exit code $LASTEXITCODE"
}

Write-Host "SteamPipe upload finished."
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/export/exporting_projects.html
# - https://docs.godotengine.org/en/stable/tutorials/editor/command_line_tutorial.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-export-builds/SKILL.md
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-export-builds/SKILL.md
# =============================================================================
