class_name VRInputActionMapper
extends Node

## Expert OpenXR Action Map abstraction boilerplate.
## Decouples gameplay logic from specific controller button strings.

func _on_left_controller_input_event(name: String, _input_value: Variant) -> void:
	# Standard OpenXR action names from project settings
	match name:
		"grab":
			_on_grab()
		"teleport":
			_on_teleport_requested()

func _on_grab() -> void:
	pass

func _on_teleport_requested() -> void:
	pass

## Rule: Never hardcode controller strings; use the Action Map system.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/xr/xr_action_map.html
# - https://docs.godotengine.org/en/stable/classes/class_openxractionmap.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-input-handling/SKILL.md — map OpenXR actions into gameplay verbs
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md — match on action names, not device paths
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-platform-vr/SKILL.md
# =============================================================================
