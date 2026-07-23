# occlusion_aware_camera_3d.gd
class_name OcclusionAwareCamera3D
extends Camera3D
## Prevents camera clipping via manual physics space raycasting.

@export var target: Node3D
@export var ideal_distance: float = 5.0
@export var wall_offset: float = 0.2

func _physics_process(_delta: float) -> void:
	if not target:
		return

	var space_state := get_world_3d().direct_space_state
	var desired_pos := target.global_position + (Vector3.BACK * ideal_distance)

	var query := PhysicsRayQueryParameters3D.create(target.global_position, desired_pos)
	query.exclude = [target.get_rid()]

	var result: Dictionary = space_state.intersect_ray(query)

	if not result.is_empty():
		global_position = result.position + result.normal * wall_offset
	else:
		global_position = desired_pos

	look_at(target.global_position, Vector3.UP)
