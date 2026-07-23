# Aurelius Protocol: Export Builds NEVER List

- **NEVER export to production without a 'Smoke Test'** — "It runs in editor" is NOT enough. Web, Mobile, and Console have unique memory/shader constraints.
- **NEVER skip macOS Notarization** — Apple's Gatekeeper will block unsigned apps. Use `notarytool` OR distribute exclusively via Steam/App Store.
- **NEVER use ad-hoc file paths** — `res://` is read-only in builds. Use `user://` for saves and logs, or paths will fail on locked file systems.
- **NEVER use 'Debug' templates for release** — Debug binaries are bloated and slow. Always use `--export-release` to strip profiling overhead.
- **NEVER include raw resources in builds** — Check your export filters. If you include `.md`, `.txt`, or `.psd` files, you're wasting player bandwidth and disk space.
- **NEVER ignore VRAM compression** — Large textures in Web/Mobile builds will crash the GPU driver. Enable ASTC/ETC2 compression in Import settings.
- **NEVER commit keystores or raw passwords to Git** — Use Environment Variables and CI Secrets (`export_android_signing_env.ps1`).
- **NEVER allow debug commands in Production** — Use `OS.has_feature("release")` to purge console/cheats from the final build.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/export/exporting_projects.html
- https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-export-builds/SKILL.md — domain skill owning this never-list sector
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — measure alleged slop before rewrite
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md
-->
