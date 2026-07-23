# Expert Headless Export Pipeline (PowerShell)
# Automates multi-platform Godot exports for CI/CD.

$GODOT_BIN = "godot" # Path to godot headless/editor binary
$BUILD_DIR = "./builds"

# Ensure build directory exists
if (!(Test-Path $BUILD_DIR)) { New-Item -ItemType Directory -Path $BUILD_DIR }

# Platform Targets
$PRESETS = @("Windows Desktop", "Linux/X11", "Web")

foreach ($PRESET in $PRESETS) {
    $OUT_DIR = "$BUILD_DIR/$($PRESET -replace ' ', '_')"
    if (!(Test-Path $OUT_DIR)) { New-Item -ItemType Directory -Path $OUT_DIR }
    
    Write-Host "Exporting: $PRESET..."
    & $GODOT_BIN --headless --export-release $PRESET "$OUT_DIR/game"
    
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Export failed for $PRESET"
        exit $LASTEXITCODE
    }
}

Write-Host "Full Build Pipeline Completed Successfully."
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/editor/command_line_tutorial.html
# - https://docs.godotengine.org/en/stable/tutorials/export/exporting_projects.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-testing-patterns/SKILL.md — CI smoke tests on exported artifacts
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-platform-desktop/SKILL.md — desktop preset naming for headless jobs
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-export-builds/SKILL.md
# =============================================================================
