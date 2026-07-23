---
name: godot-export-builds
description: "Expert patterns for multi-platform exports including export templates (Windows/Linux/macOS/Android/iOS/Web), command-line exports (headless mode), platform-specific settings (codesign, notarization, Android SDK), feature flags (OS.has_feature), CI/CD pipelines (GitHub Actions), and build optimization (size reduction, debug stripping). Use for release preparation or automated deployment. Trigger keywords: export_preset, export_template, headless_export, platform_specific, feature_flag, CI_CD, build_optimization, codesign, Android_SDK."
---

# Export & Builds

Headless / CI / platform release plumbing — not Editor → Export click-path tutorials.

## NEVER Do (Expert Export Rules)

### Platform & Validation
- **NEVER export to production without a smoke test** — Editor play ≠ Web/Mobile/Console constraints.
- **NEVER skip macOS notarization** for direct distribution — Gatekeeper blocks unsigned apps (Steam/App Store distribution can substitute).
- **NEVER use ad-hoc writable `res://` paths in builds** — Saves/logs go to `user://`.

### Performance & Size
- **NEVER ship Debug templates as release** — Use `--export-release`.
- **NEVER include raw authoring junk** — Filter `.md` / `.psd` / docs out of presets.
- **NEVER ignore VRAM compression on Web/Mobile** — Enable ASTC/ETC2 (keep pixel art uncompressed).

### Security
- **NEVER commit keystores or passwords** — Env vars + [export_android_signing_env.ps1](../scripts/export_builds_export_android_signing_env.ps1).
- **NEVER leave debug cheats in release** — Gate with `OS.has_feature("release")`.
- **NEVER enable Shader Baker on dedicated server exports** — Wasted build time; baker is for visual clients.

---

## Godot 4.7: Import & Export

- `EditorSceneFormatImporter` constants moved to **ImportFlags** enum — update importer scripts.
- **Asset Store** replaces Asset Library in editor — document addon acquisition via new store UI.
- **HDR export**: verify viewport HDR settings per platform in export presets.

## Platform Decision Tree

| Target | MANDATORY scripts / actions | Do NOT Load |
|--------|----------------------------|-------------|
| Desktop smoke (Win/Linux) | [export_headless_pipeline.ps1](../scripts/export_builds_export_headless_pipeline.ps1) or [headless_build.sh](../scripts/export_builds_headless_build.sh) | Manual Export UI tutorials |
| Web smoke | Headless web preset + size report | Desktop-only compression assumptions |
| Android release | [export_android_signing_env.ps1](../scripts/export_builds_export_android_signing_env.ps1) | Committed keystores |
| macOS direct distribute | [export_macos_notarize_cmd.ps1](../scripts/export_builds_export_macos_notarize_cmd.ps1) | Skipping notarize "because Steam exists" when not on Steam |
| Dedicated server | Headless server preset, baker off | Client shader baker / UI feature packs |
| CI multi-platform | [export_ci_github_actions.yml](../scripts/export_builds_export_ci_github_actions.yml) (**Godot 4.7** images) | Stale 4.2.x container pins |
| Steam depot upload | [export_steam_upload.ps1](../scripts/export_builds_export_steam_upload.ps1) | — if not shipping on Steam |
| PCK / DLC patches | [export_pck_patch_loader.gd](../scripts/export_builds_export_pck_patch_loader.gd) | — if no DLC |
| One-click all presets | [export_universal_manager.gd](../scripts/export_builds_export_universal_manager.gd) | — |
| Version sync | [export_version_sync.gd](../scripts/export_builds_export_version_sync.gd) / [version_manager.gd](../scripts/export_builds_version_manager.gd) | Hardcoded version labels in UI only |
| Feature stripping | [export_feature_flag_manager.gd](../scripts/export_builds_export_feature_flag_manager.gd) | — |
| Size audit | [export_build_size_report.gd](../scripts/export_builds_export_build_size_report.gd) | — |
| Custom engine strip | [export_custom_build_stripper.py](../scripts/export_builds_export_custom_build_stripper.py) | — unless custom builds |
| Post-export zip/manifest | [export_post_process_hook.gd](../scripts/export_builds_export_post_process_hook.gd) | — |

**Editor Export UI / template download prose:** use Official Documentation links in Reference — do not restate "Manage Export Templates → Download" here.

## Available Scripts

> **MANDATORY**: Read the script that matches the platform decision above before implementing.

- [export_headless_pipeline.ps1](../scripts/export_builds_export_headless_pipeline.ps1)
- [headless_build.sh](../scripts/export_builds_headless_build.sh)
- [export_version_sync.gd](../scripts/export_builds_export_version_sync.gd) / [version_manager.gd](../scripts/export_builds_version_manager.gd)
- [export_post_process_hook.gd](../scripts/export_builds_export_post_process_hook.gd)
- [export_feature_flag_manager.gd](../scripts/export_builds_export_feature_flag_manager.gd)
- [export_pck_patch_loader.gd](../scripts/export_builds_export_pck_patch_loader.gd)
- [export_android_signing_env.ps1](../scripts/export_builds_export_android_signing_env.ps1)
- [export_custom_build_stripper.py](../scripts/export_builds_export_custom_build_stripper.py)
- [export_macos_notarize_cmd.ps1](../scripts/export_builds_export_macos_notarize_cmd.ps1)
- [export_build_size_report.gd](../scripts/export_builds_export_build_size_report.gd)
- [export_ci_github_actions.yml](../scripts/export_builds_export_ci_github_actions.yml) — pin **4.7** templates/executable
- [export_steam_upload.ps1](../scripts/export_builds_export_steam_upload.ps1) — SteamPipe via `steamcmd` + VDF
- [export_universal_manager.gd](../scripts/export_builds_export_universal_manager.gd)

## CI Contract (4.7)

Workflows must pull **Godot 4.7** editor + export templates (not 4.2.x). Prefer the checked-in [export_ci_github_actions.yml](../scripts/export_builds_export_ci_github_actions.yml) over pasted legacy YAML. Artifacts upload with `actions/upload-artifact@v4`.

## Expert Export Patterns

### 1. Platform-Specific Patching (Delta Updates)
Mount external PCKs with `ProjectSettings.load_resource_pack(path, true)` — same-path resources override base. See [export_pck_patch_loader.gd](../scripts/export_builds_export_pck_patch_loader.gd).

### 2. VRAM Compression Audit
- Desktop Forward+: S3TC/BPTC
- Mobile: ETC2 / ASTC
- Pixel art: compression off

### 3. SteamPipe Upload
Build locally/CI → [export_steam_upload.ps1](../scripts/export_builds_export_steam_upload.ps1) with `STEAM_USER` / `STEAM_PASS` / `STEAMCMD_PATH` env vars and an `app_build.vdf`.

### 4. Universal Build Manager
Iterate presets from `export_presets.cfg` via [export_universal_manager.gd](../scripts/export_builds_export_universal_manager.gd) for one-click multi-platform consistency.

## Reference

> Progressive disclosure: open Official Documentation links only when researching a specific API; load Related Skills when routing to a peer domain — do not preload the whole lattice.

### Official Documentation
- [Exporting (tutorial index)](https://docs.godotengine.org/en/stable/tutorials/export/index.html) — Entry map for presets, templates, platform guides, feature tags, and PCK workflows before platform deep-dives.
- [Exporting projects](https://docs.godotengine.org/en/stable/tutorials/export/exporting_projects.html) — Export presets, template install, include/exclude filters, and release vs debug template choice.
- [Feature tags](https://docs.godotengine.org/en/stable/tutorials/export/feature_tags.html) — `OS.has_feature` / custom tags that drive runtime stripping of debug tools and platform forks.
- [Command line tutorial](https://docs.godotengine.org/en/stable/tutorials/editor/command_line_tutorial.html) — `--headless`, `--export-release`, `--export-debug`, and `--export-pack` for CI and scripted pipelines.
- [Exporting packs, patches, and mods](https://docs.godotengine.org/en/stable/tutorials/export/exporting_pcks.html) — PCK/DLC mounting with `ProjectSettings.load_resource_pack` for delta updates.
- [Exporting for Android](https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_android.html) — SDK, keystore, and signing env expectations for store and CI Android builds.
- [Exporting for macOS](https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_macos.html) — Codesign, notarization, and universal binary options required for Gatekeeper distribution.
- [Exporting for Web](https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_web.html) — Threading/SharedArrayBuffer, VRAM compression, and HTML5 shell constraints for web smoke tests.
- [Exporting for dedicated servers](https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_dedicated_servers.html) — Headless server templates and why client-only bake steps (e.g. shader baker) waste server builds.
- [EditorExportPlugin](https://docs.godotengine.org/en/stable/classes/class_editorexportplugin.html) — Hook API for post-export zip/manifest steps shared across team export presets.
- [Optimizing for size](https://docs.godotengine.org/en/stable/engine_details/development/compiling/optimizing_for_size.html) — SCons module stripping and size flags when custom templates must beat stock binary weight.
- [Data paths](https://docs.godotengine.org/en/stable/tutorials/io/data_paths.html) — `res://` vs `user://` so exported builds do not write into read-only packed paths.

### Related Skills

#### Prerequisites
- [godot-project-foundations](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md) — Project layout, `project.godot` version/icon settings, and import defaults must be sane before export presets and filters.
- [godot-gdscript-mastery](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md) — `EditorScript` / plugin typing and `OS.execute` patterns used by version sync, universal export, and post-process hooks.

#### Complements
- [godot-platform-desktop](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-platform-desktop/SKILL.md) — Windows/Linux/macOS runtime quirks (icons, windowing, Steam) that export presets must match.
- [godot-platform-mobile](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-platform-mobile/SKILL.md) — Android/iOS permission, orientation, and input assumptions that belong in mobile export options.
- [godot-platform-web](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-platform-web/SKILL.md) — Web host constraints (CORS, threads, memory) that decide Web export type and smoke-test matrix.
- [godot-platform-console](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-platform-console/SKILL.md) — Console certification packaging flows that extend beyond desktop/mobile export templates.
- [godot-adapt-desktop-to-mobile](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-adapt-desktop-to-mobile/SKILL.md) — Touch/UI/safe-area adaptations that must ship in mobile feature-tagged builds, not desktop-only assets.
- [godot-debugging-profiling](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md) — Profile export vs editor differences (shader compile, memory) before blaming preset filters.
- [godot-testing-patterns](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-testing-patterns/SKILL.md) — Automated smoke tests against headless/CI artifacts so “runs in editor” never ships alone.
- [godot-save-load-systems](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-save-load-systems/SKILL.md) — Persist under `user://`; export filters must not strip save schemas players need after install.
- [godot-resource-data-patterns](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md) — Resource packing and `.gdignore` hygiene that directly shrinks export footprint.

#### Downstream / consumers
- [godot-performance-optimization](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md) — Escalate when release builds still fail budgets after filters, VRAM compression, and template choice.
- [godot-server-architecture](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-server-architecture/SKILL.md) — Consumes dedicated-server export presets and headless pipelines for authoritative hosts.
- [godot-multiplayer-networking](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-multiplayer-networking/SKILL.md) — Client/server binary pairs and feature tags for dedicated vs listen-server packaging.

#### Master
- [godot-master](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-master/SKILL.md) — Library router and mirrored module entry; open when discovering which Domain Skill owns a cross-cutting export or platform concern.
