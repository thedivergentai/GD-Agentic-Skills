extends Node
class_name WaveResourceSpawner

## Expert Wave Spawner (Godot 4.7).
## Uses WaveData Resources and Path3D for track-based enemy spawning.

@export var waves: Array[Resource] # Array of WaveData
@export var track: Path3D

var current_wave: int = 0

func spawn_wave() -> void:
	if current_wave >= waves.size(): return
	var data = waves[current_wave]
	
	for i in data.count:
		_spawn_unit(data.enemy_scene)
		await get_tree().create_timer(data.interval).timeout
	
	current_wave += 1

func _spawn_unit(scene: PackedScene) -> void:
	# Expert Pattern: Standard TD movement using PathFollow3D child
	var follower = PathFollow3D.new()
	follower.loop = false
	track.add_child(follower)
	
	var unit = scene.instantiate()
	follower.add_child(unit)

## [SKILL NOTICE]: Instantiate enemies as children of 'PathFollow3D' 
## and update the 'progress' property to move them along the track.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_path3d.html
# - https://docs.godotengine.org/en/stable/classes/class_pathfollow3d.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md — WaveData .tres spawn sequences
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-game-loop-waves/SKILL.md — interval spawning without switch spam
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md — interval/count bands vs leak rate
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-tower-defense/SKILL.md
# =============================================================================
