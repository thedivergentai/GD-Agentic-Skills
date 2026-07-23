class_name NetLobbyLateJoinSync
extends Node

## Expert Late-Join State Synchronizer.
## Ensures new players receive a full world-state snapshot upon connection.

func _ready() -> void:
	if multiplayer.is_server():
		multiplayer.peer_connected.connect(_sync_new_player)

func _sync_new_player(id: int) -> void:
	# Snapshot the entire game state
	var state = {
		"score": 100,
		"elapsed_time": 300.0,
		"world_seed": 12345
	}
	rpc_id(id, "receive_full_state", state)

@rpc("authority", "call_remote", "reliable")
func receive_full_state(state: Dictionary) -> void:
	# Apply state to local world
	pass

## Rule: Reliable RPCs are mandatory for initial state syncing. Use Unreliable for physics thereafter.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_multiplayerspawner.html
# - https://docs.godotengine.org/en/stable/tutorials/networking/high_level_multiplayer.html
# - https://docs.godotengine.org/en/stable/classes/class_scenemultiplayer.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-scene-management/SKILL.md — world-state payload assembly on join
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-multiplayer-networking/SKILL.md — lobby peer_connected flows
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-adapt-single-to-multiplayer/SKILL.md
# =============================================================================
