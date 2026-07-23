class_name SecretRandomEncounterSpawner
extends Node

## Expert Rare Encounter Spawner.
## Weighted random system for spawning 'Secret Vendors' or rare entities.

@export var rare_entity_scene: PackedScene
@export var spawn_chance: float = 0.01 # 1% chance

func attempt_spawn(spawn_parent: Node, spawn_pos: Vector3) -> void:
	if randf() <= spawn_chance:
		var instance = rare_entity_scene.instantiate()
		spawn_parent.add_child(instance)
		instance.global_position = spawn_pos

## Rule: Rare encounters should have a 'Pity' timer if they are required for achievements.

# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/math/random_number_generation.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html
# - https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md — tune spawn_chance and pity
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-procedural-generation/SKILL.md — weighted encounter tables
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-mechanic-secrets/SKILL.md
# =============================================================================
