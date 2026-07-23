extends Node
class_name SoftLockAimAssist

## Expert Aim Assist (Godot 4.7).
## Uses Dot Product to find targets and Slerp for smooth tracking.

@export var assist_strength: float = 4.0
@export var threshold: float = 0.97 # Cone of influence

@onready var camera: Camera3D = get_viewport().get_camera_3d()

func _physics_process(delta: float) -> void:
	var target = _find_best_target()
	if target:
		_apply_soft_lock(target, delta)

func _find_best_target() -> Node3D:
	var best_target: Node3D = null
	var best_dot: float = -1.0
	
	var forward = -camera.global_transform.basis.z
	for enemy in get_tree().get_nodes_in_group("enemies"):
		var dir = camera.global_position.direction_to(enemy.global_position)
		var dot = forward.dot(dir)
		
		if dot > threshold and dot > best_dot:
			best_dot = dot
			best_target = enemy
			
	return best_target

func _apply_soft_lock(target: Node3D, delta: float) -> void:
	var target_basis = Basis.looking_at(target.global_position - camera.global_position)
	var current_q = camera.global_transform.basis.get_rotation_quaternion()
	var target_q = target_basis.get_rotation_quaternion()
	
	# Expert Pattern: Spherical linear interpolation for smooth rotation
	var result_q = current_q.slerp(target_q, assist_strength * delta)
	camera.global_transform.basis = Basis(result_q)

## [SKILL NOTICE]: Use 'dot product' to filter proximity to screen center, 
## and 'slerp' for smooth aim-assist pull. Avoid hard-snapping rotation.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/inputs/controllers_gamepads_joysticks.html
# - https://docs.godotengine.org/en/stable/classes/class_camera3d.html
# - https://docs.godotengine.org/en/stable/tutorials/3d/using_transforms.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-input-handling/SKILL.md — stick look curves before soft-lock slerp
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-camera-systems/SKILL.md — assist rotates camera basis toward target
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-shooter/SKILL.md
# =============================================================================
