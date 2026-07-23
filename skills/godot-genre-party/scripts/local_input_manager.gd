extends Node

## Expert Local Input Manager (Godot 4.7).
## Gamepad hotplugging and player ID mapping.

var player_map = {} # PlayerID -> DeviceID

func _ready() -> void:
	Input.joy_connection_changed.connect(_on_joy_changed)
	for id in Input.get_connected_joypads():
		_on_joy_changed(id, true)

func _on_joy_changed(device: int, connected: bool) -> void:
	if connected:
		var p_id = player_map.size() + 1
		player_map[p_id] = device
		print("P%d connected to Device %d" % [p_id, device])
	else:
		# Handle disconnection logic (pause game, etc)
		pass

func is_player_action(p_id: int, action: StringName, event: InputEvent) -> bool:
	return event.device == player_map.get(p_id, -1) and event.is_action(action)

## [SKILL NOTICE]: Use 'joy_connection_changed' to handle mid-game 
## controller swaps. Validate 'event.device' in '_unhandled_input'.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_input.html
# - https://docs.godotengine.org/en/stable/tutorials/inputs/controllers_gamepads_joysticks.html
# - https://docs.godotengine.org/en/stable/tutorials/inputs/inputevent.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-input-handling/SKILL.md — joy_connection_changed hotplug
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — notify UI on device remap
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-party/SKILL.md
# =============================================================================
