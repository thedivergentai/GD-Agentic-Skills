class_name NativeDialogHelper
extends Node

## Expert native OS integration for desktop platforms.
## Bypasses internal Godot UI for a native UX feel.

func show_native_alert(message: String, title: String = "Alert") -> void:
	# Blocks main thread - use sparingly
	OS.alert(message, title)

func open_native_file_selector(callback: Callable) -> void:
	if DisplayServer.has_feature(DisplayServer.FEATURE_NATIVE_DIALOG_FILE):
		DisplayServer.file_dialog_show(
			"Select File", 
			OS.get_user_data_dir(), 
			"", 
			false, 
			DisplayServer.FILE_DIALOG_MODE_OPEN_FILE, 
			["*.dat; Data Files"],
			callback
		)
	else:
		print("Desktop: Native dialogs not supported on this host.")
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_displayserver.html
# - https://docs.godotengine.org/en/stable/classes/class_os.html
# - https://docs.godotengine.org/en/stable/classes/class_filedialog.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-composition-apps/SKILL.md — native UX for tool apps
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-save-load-systems/SKILL.md — open/save dialogs for user data
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-platform-desktop/SKILL.md
# =============================================================================
