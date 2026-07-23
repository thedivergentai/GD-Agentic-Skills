class_name AndroidRuntimePermissions
extends Node

## Expert Android runtime permission handler.
## Correctly requests and checks for hardware permissions to avoid store rejections.

const STORAGE_PERMISSION = "android.permission.WRITE_EXTERNAL_STORAGE"
const CAMERA_PERMISSION = "android.permission.CAMERA"

func request_access_to_camera() -> void:
	if OS.get_name() != "Android": return
	
	if not OS.get_granted_permissions().has(CAMERA_PERMISSION):
		OS.request_permission(CAMERA_PERMISSION)
		_check_permission_status.call_deferred(CAMERA_PERMISSION)

func _check_permission_status(permission: String) -> void:
	if OS.get_granted_permissions().has(permission):
		print("Mobile: Permission granted: ", permission)
	else:
		print("Mobile: Permission denied: ", permission)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_os.html
# - https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_android.html
# - https://docs.godotengine.org/en/stable/tutorials/platform/android/index.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-export-builds/SKILL.md — declare permissions in Android export presets
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-autoload-architecture/SKILL.md — central permission Autoload
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-platform-mobile/SKILL.md
# =============================================================================
