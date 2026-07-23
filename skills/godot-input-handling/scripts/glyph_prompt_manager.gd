# glyph_prompt_manager.gd
# Dynamic UI prompt switching (Keyboard vs Gamepad) [25]
extends Node

signal device_changed(type: String)

enum Device { KEYBOARD_MOUSE, GAMEPAD }
var last_device: Device = Device.KEYBOARD_MOUSE

func _input(event: InputEvent) -> void:
	var current: Device = last_device
	
	if event is InputEventKey or event is InputEventMouseButton:
		current = Device.KEYBOARD_MOUSE
	elif event is InputEventJoypadButton or event is InputEventJoypadMotion:
		current = Device.GAMEPAD
		
	if current != last_device:
		last_device = current
		device_changed.emit("GamePad" if current == Device.GAMEPAD else "KBM")
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/inputs/controllers_gamepads_joysticks.html
# - https://docs.godotengine.org/en/stable/classes/class_inputevent.html
# - https://docs.godotengine.org/en/stable/tutorials/inputs/inputevent.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md — swap prompt textures on device_changed
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — broadcast last-active device
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-autoload-architecture/SKILL.md — singleton glyph router
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-input-handling/SKILL.md
# =============================================================================
