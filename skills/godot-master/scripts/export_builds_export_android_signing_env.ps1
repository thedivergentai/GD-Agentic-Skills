# Expert Android Signing Environment Setup (PowerShell)
# Injects keystore credentials via env vars for secure CI builds.

$env:GODOT_ANDROID_KEYSTORE_PATH = "C:/Keys/release.keystore"
$env:GODOT_ANDROID_KEYSTORE_USER = "game_alias"
$env:GODOT_ANDROID_KEYSTORE_PASS = "secure_password" # Use CI Secrets in production

Write-Host "Android Signing Environment Prepared."

# Usage in Godot Export:
# Set 'Release User' and 'Release Password' in export preset to reference these env vars.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_android.html
# - https://docs.godotengine.org/en/stable/tutorials/export/android_gradle_build.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-platform-mobile/SKILL.md — Android store packaging expectations
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-testing-patterns/SKILL.md — signed APK/AAB smoke installs
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-export-builds/SKILL.md
# =============================================================================
