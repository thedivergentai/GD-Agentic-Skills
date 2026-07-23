class_name NetAntiDesyncReconciler
extends Node

## Expert Anti-Desync Reconciliation.
## Snap-corrects peers if they deviate too far from their server-side ghost instance.

@export var error_tolerance: float = 0.5 

func validate_peer_state(peer_id: int, reported_pos: Vector3) -> void:
	var shadow_pos = ServerGameState.get_peer_pos(peer_id)
	if reported_pos.distance_to(shadow_pos) > error_tolerance:
		# Force Correction RPC
		force_sync.rpc_id(peer_id, shadow_pos)

@rpc("authority", "reliable")
func force_sync(correct_pos: Vector3) -> void:
	var player = get_tree().get_first_node_in_group("Player")
	player.global_position = correct_pos

## Rule: Snap-correction should be the LAST resort. Use interpolation/prediction first.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/networking/high_level_multiplayer.html
# - https://docs.godotengine.org/en/stable/classes/class_node.html
# - https://docs.godotengine.org/en/stable/classes/class_multiplayerapi.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — detect desync before snap-correcting
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-adapt-single-to-multiplayer/SKILL.md — reconcile after prediction
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-multiplayer-networking/SKILL.md
# =============================================================================
