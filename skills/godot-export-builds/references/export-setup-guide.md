# Export Setup Guide (load on demand)

> Editor Export UI walkthrough lives in Official Documentation. Load this for preset INI examples, CLI flags, and platform checklists — automation scripts are in `scripts/`.

## Install templates

Editor → Manage Export Templates → Download (match project Godot version, e.g. 4.7).

## export_presets.cfg sketch

```ini
[preset.0]
name="Windows Desktop"
platform="Windows Desktop"
runnable=true
export_path="builds/windows/game.exe"

[preset.0.options]
binary_format/64_bits=true
application/icon="res://icon.ico"
```

## Command-line export

```powershell
godot --headless --export-release "Windows Desktop" builds/game.exe
godot --headless --export-debug "Windows Desktop" builds/game_debug.exe
godot --headless --export-pack "Windows Desktop" builds/game.pck
```

CI: [export_ci_github_actions.yml](../scripts/export_ci_github_actions.yml) — pin **4.7**, not legacy 4.2 images.

## Platform checklists

### Android

- Android SDK + OpenJDK 17
- Keystore via env: [export_android_signing_env.ps1](../scripts/export_android_signing_env.ps1)
- **NEVER** commit keystore passwords

### iOS / macOS

- Xcode + provisioning (iOS)
- macOS: Developer ID + notarization — [export_macos_notarize_cmd.ps1](../scripts/export_macos_notarize_cmd.ps1)

### Web

- Thread support / SharedArrayBuffer requirements
- VRAM compression (ETC2/ASTC)

## Feature flags at runtime

```gdscript
if OS.has_feature("web"):
	pass
if OS.has_feature("mobile"):
	pass
if OS.has_feature("release"):
	# strip debug consoles
	pass
```

Manager: [export_feature_flag_manager.gd](../scripts/export_feature_flag_manager.gd)

## Build size optimization

- Export filters: exclude `*.md`, `docs/*`, `.psd`
- `.gdignore` in dev-only folders
- Release template + debug off
- Custom strip: [export_custom_build_stripper.py](../scripts/export_custom_build_stripper.py)

## Version string sync

[export_version_sync.gd](../scripts/export_version_sync.gd), [version_manager.gd](../scripts/version_manager.gd) — sync git tag → `application/config/version`.

## PCK patching

```gdscript
func _load_patch(patch_path: String) -> bool:
	if FileAccess.file_exists(patch_path):
		return ProjectSettings.load_resource_pack(patch_path, true)
	return false
```

Full loader: [export_pck_patch_loader.gd](../scripts/export_pck_patch_loader.gd)

## VRAM compression audit

| Platform | Format |
|----------|--------|
| Desktop Forward+ | S3TC / BPTC |
| Mobile | ETC2 / ASTC |
| Pixel art | compression off |

## SteamPipe

[export_steam_upload.ps1](../scripts/export_steam_upload.ps1) + `app_build.vdf` — credentials via env vars only.

## Universal export loop

[export_universal_manager.gd](../scripts/export_universal_manager.gd) — iterate `export_presets.cfg` presets headlessly.
