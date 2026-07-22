---
name: godot-export-builds
description: "Expert patterns for multi-platform exports including export templates (Windows/Linux/macOS/Android/iOS/Web), command-line exports (headless mode), platform-specific settings (codesign, notarization, Android SDK), feature flags (OS.has_feature), CI/CD pipelines (GitHub Actions), and build optimization (size reduction, debug stripping). Use for release preparation or automated deployment. Trigger keywords: export_preset, export_template, headless_export, platform_specific, feature_flag, CI_CD, build_optimization, codesign, Android_SDK."
---

# Export & Builds

Expert guidance for building and distributing Godot games across platforms.

## NEVER Do (Expert Export Rules)

### Platform & Validation
- **NEVER export to production without a 'Smoke Test'** — "It runs in editor" is NOT enough. Web, Mobile, and Console have unique memory/shader constraints.
- **NEVER skip macOS Notarization** — Apple's Gatekeeper will block unsigned apps. Use `notarytool` OR distribute exclusively via Steam/App Store.
- **NEVER use ad-hoc file paths** — `res://` is read-only in builds. Use `user://` for saves and logs, or paths will fail on locked file systems.

### Performance & Size
- **NEVER use 'Debug' templates for release** — Debug binaries are bloated and slow. Always use `--export-release` to strip profiling overhead.
- **NEVER include raw resources in builds** — Check your export filters. If you include `.md`, `.txt`, or `.psd` files, you're wasting player bandwidth and disk space.
- **NEVER ignore VRAM compression** — Large textures in Web/Mobile builds will crash the GPU driver. Enable ASTC/ETC2 compression in Import settings.

### Security
- **NEVER commit keystores or raw passwords to Git** — Use Environment Variables and CI Secrets (`export_android_signing_env.ps1`).
- **NEVER allow debug commands in Production** — Use `OS.has_feature("release")` to purge console/cheats from the final build.
- **NEVER bake shaders on export for Dedicated Servers** — The Shader Baker (Godot 4.5+) is for visual clients. Enabling it for headless servers is wasted build time.
---

## Godot 4.7: Import & Export

- `EditorSceneFormatImporter` constants moved to **ImportFlags** enum — update importer scripts.
- **Asset Store** replaces Asset Library in editor — document addon acquisition via new store UI.
- **HDR export**: verify viewport HDR settings per platform in export presets.

## Available Scripts

> **MANDATORY**: Read the appropriate script before implementing the corresponding pattern.

### [export_headless_pipeline.ps1](../scripts/export_builds_export_headless_pipeline.ps1)
Expert PowerShell script for automated multi-platform headless exports.

### [export_version_sync.gd](../scripts/export_builds_export_version_sync.gd)
Editor script to sync Git tags/hashes with 'application/config/version'.

### [export_post_process_hook.gd](../scripts/export_builds_export_post_process_hook.gd)
`EditorExportPlugin` for automating post-build tasks (Zipping, Manifests).

### [export_feature_flag_manager.gd](../scripts/export_builds_export_feature_flag_manager.gd)
Expert manager for runtime behavior swapping via build feature flags.

### [export_pck_patch_loader.gd](../scripts/export_builds_export_pck_patch_loader.gd)
Runtime patching logic for mounting external PCK archives and DLC.

### [export_android_signing_env.ps1](../scripts/export_builds_export_android_signing_env.ps1)
Secure environment variable setup for Android release keystores.

### [export_custom_build_stripper.py](../scripts/export_builds_export_custom_build_stripper.py)
SCons configuration for stripping unused Godot modules to reduce binary size.

### [export_macos_notarize_cmd.ps1](../scripts/export_builds_export_macos_notarize_cmd.ps1)
CLI procedure for macOS code signing and notarization outside the App Store.

### [export_build_size_report.gd](../scripts/export_builds_export_build_size_report.gd)
Editor tool for auditing resource sizes to optimize build footprints.

### [export_ci_github_actions.yml](../scripts/export_builds_export_ci_github_actions.yml)
Professional CI/CD workflow for automated multi-platform Godot releases.

### [export_steam_upload.ps1](scripts/export_steam_upload.ps1)
Expert script for automating SteamPipe uploads using `steamcmd` and VDF manifests.

### [export_universal_manager.gd](../scripts/export_builds_export_universal_manager.gd)
Editor tool to programmatically iterate and export all defined presets in one click.

---

## Export Templates

**Install via Editor:**
Editor → Manage Export Templates → Download

## Basic Export Setup

### Create Export Preset

1. Project → Export
2. Add preset (Windows, Linux, etc.)
3. Configure settings
4. Export Project

### Windows Export

```ini
# Export settings
# Format: .exe (single file) or .pck + .exe
# Icon: .ico file
# Include: *.import, *.tres, *.tscn
```

### Web Export

```ini
# Settings:
# Export Type: Regular or GDExtension
# Thread Support: For SharedArrayBuffer
# VRAM Compression: Optimized for size
```

## Export Presets File

```ini
# export_presets.cfg

[preset.0]
name="Windows Desktop"
platform="Windows Desktop"
runnable=true
export_path="builds/windows/game.exe"

[preset.0.options]
binary_format/64_bits=true
application/icon="res://icon.ico"
```

## Command-Line Export

```powershell
# Export from command line
godot --headless --export-release "Windows Desktop" builds/game.exe

# Export debug build
godot --headless --export-debug "Windows Desktop" builds/game_debug.exe

# PCK only (for patching)
godot --headless --export-pack "Windows Desktop" builds/game.pck
```

## Platform-Specific

### Android

```ini
# Requirements:
# - Android SDK
# - OpenJDK 17
# - Debug keystore

# Editor Settings:
# Export → Android → SDK Path
# Export → Android → Keystore
```

### iOS

```ini
# Requirements:
# - macOS with Xcode
# - Apple Developer account
# - Provisioning profile

# Export creates .xcodeproj
# Build in Xcode for App Store
```

### macOS

```ini
# Settings:
# Codesign: Developer ID certificate
# Notarization: Required for distribution
# Architecture: Universal (Intel + ARM)
```

## Feature Flags

```gdscript
# Check platform at runtime
if OS.get_name() == "Windows":
    # Windows-specific code
    pass

if OS.has_feature("web"):
    # Web build
    pass

if OS.has_feature("mobile"):
    # Android or iOS
    pass
```

## Project Settings for Export

```ini
# project.godot

[application]
config/name="My Game"
config/version="1.0.0"
run/main_scene="res://scenes/main.tscn"
config/icon="res://icon.svg"

[rendering]
# Optimize for target platforms
textures/vram_compression/import_etc2_astc=true  # Mobile
```

## Build Optimization

### Reduce Build Size

```gdscript
# Remove unused imports
# Project Settings → Editor → Import Defaults

# Exclude editor-only files
# In export preset: Exclude filters
*.md
*.txt
docs/*
```

### Strip Debug Symbols

```ini
# Export preset options:
# Debugging → Debug: Off
# Binary Format → Architecture: 64-bit only
```

## CI/CD with GitHub Actions

```yaml
# .github/workflows/export.yml
name: Export Godot Game

on:
  push:
    tags: ['v*']

jobs:
  export:
    runs-on: ubuntu-latest
    container:
      image: barichello/godot-ci:4.2.1
    
    steps:
      - uses: actions/checkout@v4
      
      - name: Export Windows
        run: |
          mkdir -p builds/windows
          godot --headless --export-release "Windows Desktop" builds/windows/game.exe
      
      - name: Upload Artifact
        uses: actions/upload-artifact@v3
        with:
          name: windows-build
          path: builds/windows/
```

## Version Management

```gdscript
# version.gd (AutoLoad)
extends Node

const VERSION := "1.0.0"
const BUILD := "2024.02.06"

func get_version_string() -> String:
    return "v" + VERSION + " (" + BUILD + ")"
```

## Best Practices

### 1. Test Export Early

```
Export to all target platforms early
Catch platform-specific issues fast
```

### 2. Use .gdignore

```
# Exclude folders from export
# Create .gdignore in folder
```

### 3. Separate Debug/Release

```
Debug: Keep logs, dev tools
Release: Strip debug, optimize size
```

## Expert Export Patterns

### 1. Platform-Specific-Patching (Delta Updates)
Pattern for mounting external PCK archives to update game content without a full reinstall.
- **Implementation**:
    ```gdscript
    func _load_patch(patch_path: String) -> bool:
        if FileAccess.file_exists(patch_path):
            return ProjectSettings.load_resource_pack(patch_path, true) # true = replace files
        return false
    ```
- **Expert Note**: Patched resources with the same path will override the base PCK. Use this for DLC, localized assets, or hotfixes.

### 2. VRAM-Compression-Audit
Ensuring the correct texture formats for target hardware.
- **S3TC/BPTC**: Mandatory for Desktop (Forward+). BPTC is superior for Normal Maps and HDR.
- **ETC2**: Standard for older Android/iOS devices. Does not support transparency on many Android GPUs [13].
- **ASTC**: Modern mobile standard. High quality/size ratio. Preferred for newer high-end mobile devices.
- **Rule**: ALWAYS disable compression for Pixel Art to maintain crisp edges [13].

### 4. Steam-Upload-Pipeline (SteamPipe)
Automating the distribution process to Steam branches.
- **VDF Manifest**: Create a `app_build.vdf` file defining the app ID, branch (e.g., `beta`), and content folders.
- **Implementation**:
    ```powershell
    # export_steam_upload.ps1
    $SteamCMD = "C:\steamcmd\steamcmd.exe"
    & $SteamCMD +login $env:STEAM_USER $env:STEAM_PASS +run_app_build "res://builds/app_build.vdf" +quit
    ```
- **Expert Note**: Use Environment Variables for credentials to keep the VDF file generic and safe for version control.

### 5. Universal-Build-Manager (One-Click Export)
Iterating through all export presets to generate a full suite of release binaries.
- **Implementation**:
    ```gdscript
    func export_all():
        var config := ConfigFile.new()
        config.load("res://export_presets.cfg")
        for section in config.get_sections():
            if section.begins_with("preset."):
                var preset_name = config.get_value(section, "name")
                var path = config.get_value(section, "export_path")
                OS.execute(OS.get_executable_path(), ["--headless", "--export-release", preset_name, path])
    ```
- **Benefit**: Ensures consistency across platforms by automating the "human error" phase of manual exporting.

## Reference
- [Godot Docs: Exporting](https://docs.godotengine.org/en/stable/tutorials/export/index.html)


### Related
- Master Skill: [godot-master](../SKILL.md)
