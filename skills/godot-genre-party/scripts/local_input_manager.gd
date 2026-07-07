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
