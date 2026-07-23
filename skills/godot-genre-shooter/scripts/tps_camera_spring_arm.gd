extends SpringArm3D
class_name TPSCameraSpringArm

## Expert TPS Camera (Godot 4.7).
## Collision-aware SpringArm with dynamic shoulder swapping.

@export var shoulder_offset: float = 0.6
@onready var camera: Camera3D = get_child(0)

func _ready() -> void:
	# Add the player to exclusion to prevent self-collision
	add_excluded_object(get_parent().get_rid())

func swap_shoulder(to_right: bool) -> void:
	var target = shoulder_offset if to_right else -shoulder_offset
	# Expert Pattern: Use 'h_offset' to shift view without moving the collision ray
	var tween = create_tween()
	tween.tween_property(camera, "h_offset", target, 0.25).set_trans(Tween.TRANS_SINE)

## [SKILL NOTICE]: Use 'h_offset' on the Camera3D child of a SpringArm3D 
## for shoulder swapping. This keeps the collision ray centered on the player.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/3d/spring_arm.html
# - https://docs.godotengine.org/en/stable/classes/class_springarm3d.html
# - https://docs.godotengine.org/en/stable/classes/class_camera3d.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-camera-systems/SKILL.md — SpringArm boom, exclusions, shoulder swap
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-input-handling/SKILL.md — look input driving arm rotation
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-shooter/SKILL.md
# =============================================================================
