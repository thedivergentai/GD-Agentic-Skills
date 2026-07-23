# spring_arm_camera_setup.gd
# [GDSKILLS] godot-adapt-2d-to-3d
# EXPORT_REFERENCE: spring_arm_camera_setup.gd

extends Node3D

## Third-person SpringArm3D + Camera3D follow for 2D→3D migrations.
## Attach under CharacterBody3D. Do NOT parent Camera3D directly to the body
## without a spring arm — that clips through walls and skips collision slide.

@export var spring_length: float = 10.0
@export var arm_height: float = 2.0
@export var mouse_sensitivity: float = 0.005
@export var pitch_min: float = -PI / 3.0
@export var pitch_max: float = PI / 6.0

@onready var spring_arm: SpringArm3D = $SpringArm3D
@onready var camera: Camera3D = $SpringArm3D/Camera3D

func _ready() -> void:
	spring_arm.spring_length = spring_length
	spring_arm.position = Vector3(0.0, arm_height, 0.0)
	spring_arm.collision_mask = 1 # World layer — tune per project matrix

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		spring_arm.rotate_y(-event.relative.x * mouse_sensitivity)
		spring_arm.rotate_object_local(Vector3.RIGHT, -event.relative.y * mouse_sensitivity)
		spring_arm.rotation.x = clampf(spring_arm.rotation.x, pitch_min, pitch_max)

func get_flat_basis() -> Basis:
	## Camera yaw only — use for CharacterBody3D movement relative to look.
	var basis := spring_arm.global_transform.basis
	basis.y = Vector3.UP
	return basis.orthonormalized()
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_springarm3d.html
# - https://docs.godotengine.org/en/stable/classes/class_camera3d.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-camera-systems/SKILL.md
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-adapt-2d-to-3d/SKILL.md
# =============================================================================
