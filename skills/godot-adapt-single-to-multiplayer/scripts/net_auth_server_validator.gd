class_name NetAuthServerValidator
extends Node

## Expert Server-Authoritative Anti-Cheat.
## Validates movement and actions before broadcasting.

const MAX_SPEED = 15.0
const SPEED_BUFFER = 1.1

func validate_move(player: Node3D, new_pos: Vector3, delta: float) -> bool:
	var dist = player.global_position.distance_to(new_pos)
	var max_dist = MAX_SPEED * delta * SPEED_BUFFER
	
	if dist > max_dist:
		printerr("Cheat detected: Player moved too fast!")
		return false
	return true

## Rule: Never trust client-reported health or inventory values. Calculate them on server.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/networking/high_level_multiplayer.html
# - https://docs.godotengine.org/en/stable/classes/class_multiplayerapi.html
# - https://docs.godotengine.org/en/stable/classes/class_node.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-multiplayer-networking/SKILL.md — authoritative server patterns
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md — retune speed caps after validation rejects
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-adapt-single-to-multiplayer/SKILL.md
# =============================================================================
