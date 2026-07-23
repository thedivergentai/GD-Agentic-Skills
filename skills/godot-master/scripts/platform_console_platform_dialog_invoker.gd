class_name PlatformDialogInvoker
extends Node

## Abstract interface for native Console dialogs (Keyboard, Prompts).
## Detects the platform and routes to the appropriate OS handler.

func show_virtual_keyboard(title: String, existing_text: String = "") -> void:
	if OS.has_feature("mobile") or OS.has_feature("console"):
		# Expert: DisplayServer.virtual_keyboard_show handles most platform-native input
		DisplayServer.virtual_keyboard_show(existing_text, Rect2(0,0,0,0))
	else:
		# PC Fallback for dev testing
		pass

func show_system_dialog(title: String, message: String) -> void:
	# Implementation varies by native GDExtension bridge
	pass

# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_displayserver.html
# - https://docs.godotengine.org/en/stable/tutorials/export/feature_tags.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md — falling back when native dialogs unavailable
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-platform-mobile/SKILL.md — virtual_keyboard_show feature parity
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-platform-console/SKILL.md
# =============================================================================
