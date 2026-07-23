# Expert macOS Notarization CLI Steps
# Required for distribution outside the Mac App Store.

# 1. Sign the APP
# codesign --deep --force --options runtime --sign "Developer ID Application: Company" Game.app

# 2. Package into ZIP/DMG
# /usr/bin/ditto -c -k --keepParent Game.app Game.zip

# 3. Submit for Notarization
# xcrun notarytool submit Game.zip --apple-id "me@company.com" --password "app-specific-pw" --team-id "TEAMID" --wait

# 4. Staple the ticket
# xcrun stapler staple Game.app
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_macos.html
# - https://docs.godotengine.org/en/stable/tutorials/export/running_on_macos.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-platform-desktop/SKILL.md — macOS distribution and Gatekeeper UX
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-testing-patterns/SKILL.md — notarized build install smoke tests
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-export-builds/SKILL.md
# =============================================================================
