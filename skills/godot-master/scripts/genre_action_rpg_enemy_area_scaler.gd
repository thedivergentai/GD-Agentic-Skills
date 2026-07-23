extends Node
class_name EnemyAreaScaler

## Scale enemy stats and rewards by area level. Always duplicate stat Resources before mutating instance fields.

@export var base_enemy_scene: PackedScene
@export var area_level: int = 1


func spawn_enemy(position: Vector2, parent: Node) -> Node:
	var enemy: Node = base_enemy_scene.instantiate()
	enemy.global_position = position
	var level_mult := 1.0 + (area_level - 1) * 0.15
	if enemy.has_method(&"scale_stats_for_level"):
		enemy.scale_stats_for_level(level_mult)
	if enemy.has_method(&"set_xp_reward"):
		enemy.set_xp_reward(int(enemy.get("xp_reward") * level_mult))
	parent.add_child(enemy)
	return enemy
# ---
# GDSkills research links (agents)
# Related:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-action-rpg/SKILL.md — exponential progression curve policy
# ---
