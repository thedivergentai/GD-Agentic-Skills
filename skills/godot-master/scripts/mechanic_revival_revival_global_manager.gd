class_name RevivalGlobalManager
extends Node

## Expert Global Respawn Manager.
## Handles player death, screen transitions, and state restitution.

signal player_died
signal player_respawned

var active_checkpoint_pos: Vector3 = Vector3.ZERO
var respawn_delay: float = 2.0

func trigger_death() -> void:
	player_died.emit()
	await get_tree().create_timer(respawn_delay).timeout
	_perform_respawn()

func _perform_respawn() -> void:
	var player = get_tree().get_first_node_in_group("Player")
	if player:
		player.global_position = active_checkpoint_pos
		# Reset state (health, velocity, etc.)
		if player.has_method("revive"):
			player.revive()
	player_respawned.emit()

## Rule: Singletons should manage 'Player' lifecycle to decouple UI/World from player existence.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html — Autoload owns death→delay→respawn
# - https://docs.godotengine.org/en/stable/tutorials/scripting/groups.html — get_first_node_in_group("Player") for restore
# - https://docs.godotengine.org/en/stable/classes/class_scenetreetimer.html — respawn_delay via create_timer
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — player_died / player_respawned ownership
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-scene-management/SKILL.md — revive existing instance; do not reload whole level
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-mechanic-revival/SKILL.md
# =============================================================================
