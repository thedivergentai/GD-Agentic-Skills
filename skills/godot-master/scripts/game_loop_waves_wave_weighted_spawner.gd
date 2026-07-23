class_name WaveWeightedSpawner
extends Marker3D

## Wave spawner with weighted random enemy selection.
## Ensures wave variety by controlling spawn probabilities.

@export var enemy_scenes: Array[PackedScene] = []
## Parallel array to enemy_scenes. Higher values = higher probability.
@export var spawn_weights: PackedFloat32Array = []
@export var spawn_radius: float = 2.0

var _rng := RandomNumberGenerator.new()

func _ready() -> void:
	_rng.randomize()

## Spawns a randomly selected enemy based on weights.
func spawn_enemy() -> Node3D:
	if enemy_scenes.is_empty() or spawn_weights.size() != enemy_scenes.size():
		push_error("WaveWeightedSpawner: enemy_scenes and spawn_weights must match in size.")
		return null
	
	# Expert weighted selection using RNG.rand_weighted
	var index = _rng.rand_weighted(spawn_weights)
	var enemy = enemy_scenes[index].instantiate() as Node3D
	
	add_child(enemy)
	enemy.global_position = _get_random_pos()
	
	return enemy

func _get_random_pos() -> Vector3:
	var angle = randf() * TAU
	var distance = randf() * spawn_radius
	return global_position + Vector3(cos(angle) * distance, 0, sin(angle) * distance)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_randomnumbergenerator.html
# - https://docs.godotengine.org/en/stable/tutorials/math/random_number_generation.html
# - https://docs.godotengine.org/en/stable/classes/class_marker3d.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md — weight tables vs difficulty feel
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-shooter/SKILL.md — variety without hard-coded spawn scripts
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-game-loop-waves/SKILL.md
# =============================================================================
