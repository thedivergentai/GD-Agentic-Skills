# characterbody3d_migration_movement.gd
# [GDSKILLS] godot-adapt-2d-to-3d
# EXPORT_REFERENCE: characterbody3d_migration_movement.gd

extends CharacterBody3D

## Camera-relative CharacterBody3D movement for 2D→3D ports.
## Requires a SpringArm helper exposing `get_flat_basis()` (see spring_arm_camera_setup.gd).

@export var speed: float = 5.0
@export var jump_velocity: float = 4.5
@export var gravity: float = 9.8
@export var turn_lerp: float = 0.1
@export var spring_arm_path: NodePath = ^"SpringArmCamera"

@onready var _spring: Node = get_node_or_null(spring_arm_path)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	var input_dir := Input.get_vector("left", "right", "forward", "back")
	var basis := Basis.IDENTITY
	if _spring and _spring.has_method("get_flat_basis"):
		basis = _spring.get_flat_basis()
	elif _spring is Node3D:
		basis = (_spring as Node3D).global_transform.basis
		basis.y = Vector3.UP
		basis = basis.orthonormalized()

	var direction := (basis * Vector3(input_dir.x, 0.0, input_dir.y)).normalized()
	if direction != Vector3.ZERO:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		rotation.y = lerp_angle(rotation.y, atan2(-direction.x, -direction.z), turn_lerp)
	else:
		velocity.x = move_toward(velocity.x, 0.0, speed)
		velocity.z = move_toward(velocity.z, 0.0, speed)

	move_and_slide()
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_characterbody3d.html
# - https://docs.godotengine.org/en/stable/classes/class_characterbody3d.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-physics-3d/SKILL.md
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-adapt-2d-to-3d/SKILL.md
# =============================================================================
