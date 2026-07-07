extends Path3D
class_name SplineTrackSpawner

## Expert Track Spawner (Godot 4.7).
## Places obstacles/points perfectly along a Curve3D.

@export var obstacle_scene: PackedScene
@export var spacing: float = 10.0

func generate_obstacles() -> void:
	var curve: Curve3D = self.curve
	var length = curve.get_baked_length()
	var current_offset = 0.0
	
	while current_offset < length:
		var pos = curve.sample_baked(current_offset)
		var up = curve.sample_baked_up_vector(current_offset)
		
		var obj = obstacle_scene.instantiate()
		add_child(obj)
		obj.global_position = global_position + pos
		obj.look_at(obj.global_position + curve.sample_baked(current_offset + 0.1), up)
		
		current_offset += spacing

## [SKILL NOTICE]: Use 'sample_baked_up_vector()' when spawning items 
## on splines to ensure they respect the track's banking and slopes.
