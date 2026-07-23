# godot-master/scripts/party_party_input_router.gd
extends Node

## Party Input Router Expert Pattern
## Isolates inputs for 4 local players using device-ID prefixing.
## MANDATORY golden path for lobby join + per-device action routing.

signal player_joined(player_id: int, device_id: int)
signal player_input_received(player_id: int, action: StringName, strength: float)

var _player_assignments: Dictionary = {} # player_id -> device_id
var _base_actions: Array[StringName] = [&"move_left", &"move_right", &"jump", &"interact"]

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventJoypadButton or event is InputEventJoypadMotion:
		var device_id := event.device
		if event.is_action_pressed("ui_accept"):
			_handle_join_request(device_id)
		var player_id := _get_player_from_device(device_id)
		if player_id != -1:
			_route_input(player_id, event)

func _handle_join_request(device_id: int) -> void:
	if device_id in _player_assignments.values():
		return
	var new_player_id := _player_assignments.size() + 1
	if new_player_id > 4:
		return
	_player_assignments[new_player_id] = device_id
	_register_player_actions(new_player_id, device_id)
	player_joined.emit(new_player_id, device_id)

func _register_player_actions(player_id: int, device_id: int) -> void:
	for action in _base_actions:
		var player_action := StringName("p%d_%s" % [player_id, String(action)])
		if not InputMap.has_action(player_action):
			InputMap.add_action(player_action)
		InputMap.action_erase_events(player_action)
		if action == &"jump" or action == &"interact":
			var btn := InputEventJoypadButton.new()
			btn.device = device_id
			btn.button_index = JOY_BUTTON_A if action == &"jump" else JOY_BUTTON_X
			InputMap.action_add_event(player_action, btn)
		else:
			var axis := InputEventJoypadMotion.new()
			axis.device = device_id
			axis.axis = JOY_AXIS_LEFT_X
			axis.axis_value = -1.0 if action == &"move_left" else 1.0
			InputMap.action_add_event(player_action, axis)

func _get_player_from_device(device_id: int) -> int:
	for p_id in _player_assignments:
		if _player_assignments[p_id] == device_id:
			return p_id
	return -1

func _route_input(player_id: int, event: InputEvent) -> void:
	for action in _base_actions:
		var player_action := StringName("p%d_%s" % [player_id, String(action)])
		if not InputMap.event_is_action(event, player_action):
			continue
		var strength := event.get_action_strength(player_action) if event is InputEventJoypadMotion else (1.0 if event.is_pressed() else 0.0)
		player_input_received.emit(player_id, player_action, strength)
		return

## EXPERT NOTE:
## Use InputMap.action_add_event at runtime for "p1_jump", "p2_jump" bound to device IDs.
## NEVER share a single "jump" action across players in local multiplayer.

# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/inputs/controllers_gamepads_joysticks.html
# - https://docs.godotengine.org/en/stable/tutorials/inputs/inputevent.html
# - https://docs.godotengine.org/en/stable/classes/class_inputmap.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-input-handling/SKILL.md — device-bound InputMap actions
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — player_joined / routed actions
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-party/SKILL.md
# =============================================================================
