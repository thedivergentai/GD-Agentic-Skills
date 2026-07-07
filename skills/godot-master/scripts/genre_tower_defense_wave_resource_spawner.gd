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
