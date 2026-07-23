class_name PhysicalInputRebinder
extends Node

## Expert rebind system using Physical Keycodes.
## Ensures WASD movement works on AZERTY/Dvorak without manual remapping.

func rebind_action_physical(action: StringName, key_event: InputEventKey) -> void:
	# Convert standard keycode to physical location-based keycode
	if key_event.keycode != KEY_NONE:
		key_event.physical_keycode = key_event.keycode
		key_event.keycode = KEY_NONE
	
	InputMap.action_erase_events(action)
	InputMap.action_add_event(action, key_event)
	_notify_input_updated()

func _notify_input_updated() -> void:
	# Signal other systems (UI prompts) that bindings have changed
	pass

## Rule: Always use 'physical_keycode' for positional gameplay controls (WASD/ESDF).
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_inputeventkey.html
# - https://docs.godotengine.org/en/stable/classes/class_inputmap.html
# - https://docs.godotengine.org/en/stable/tutorials/inputs/inputevent.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-input-handling/SKILL.md — action design before rebind UIs
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md — remapper rows and conflict prompts
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-platform-desktop/SKILL.md
# =============================================================================
