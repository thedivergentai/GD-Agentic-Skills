class_name ControllerPromptMapper
extends RefCounted

## Expert GUID-based Icon Routing for Console UI.
## Detects hardware type to display correct button prompts (PS/Xbox/Switch).

static func get_prompt_path(device_id: int) -> String:
	var guid = Input.get_joy_guid(device_id)
	var name = Input.get_joy_name(device_id).to_lower()
	
	# Detect platform from standardized SDL2 identifiers
	if "nintendo" in name or "switch" in name:
		return "res://ui/prompts/nintendo_set.tres"
	elif "ps4" in name or "ps5" in name or "dual" in name:
		return "res://ui/prompts/playstation_set.tres"
	else:
		# Fallback to Xbox/XInput standard
		return "res://ui/prompts/xbox_set.tres"

## Rule: Always display SVG-based prompts for high-DPI console displays.

# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/inputs/controllers_gamepads_joysticks.html
# - https://docs.godotengine.org/en/stable/classes/class_input.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-input-handling/SKILL.md — GUID/name based device identity
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md — swapping prompt icons in menus
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-platform-console/SKILL.md
# =============================================================================
