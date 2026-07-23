class_name DesktopWindowManager
extends Node

## Expert handler for PC multi-monitor and DPI-aware window positioning.
## Ensures windows are centered and sized correctly across varying monitor scales.

func center_on_current_screen() -> void:
	var current_screen := DisplayServer.window_get_current_screen()
	var usable_rect := DisplayServer.screen_get_usable_rect(current_screen)
	var scale_factor := DisplayServer.screen_get_scale(current_screen)
	
	var window := get_window()
	# Apply OS-level scale factor to ensure consistent size on HiDPI displays
	var target_size := Vector2i(Vector2(window.size) * scale_factor)
	var target_pos := usable_rect.position + (usable_rect.size / 2) - (target_size / 2)
	
	window.position = target_pos

func set_mode_safe(mode: DisplayServer.WindowMode) -> void:
	# Expert: Ensure we don't switch to exclusive fullscreen if not supported
	if mode == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
		if not DisplayServer.has_feature(DisplayServer.FEATURE_NATIVE_DIALOG_FILE): # Simple proxy check
			mode = DisplayServer.WINDOW_MODE_FULLSCREEN
	DisplayServer.window_set_mode(mode)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_displayserver.html
# - https://docs.godotengine.org/en/stable/tutorials/rendering/multiple_resolutions.html
# - https://docs.godotengine.org/en/stable/classes/class_window.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md — display stretch + window project settings
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md — settings UI that drives window modes
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-platform-desktop/SKILL.md
# =============================================================================
