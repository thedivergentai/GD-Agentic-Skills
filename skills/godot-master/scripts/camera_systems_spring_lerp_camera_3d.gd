# spring_lerp_camera_3d.gd
# Advanced 3D camera follow using Spring interpolation [169]
extends Camera3D

@export var target: Node3D
@export var offset: Vector3 = Vector3(0, 5, 10)
@export var spring_stiffness: float = 15.0

func _physics_process(delta: float) -> void:
	if not target: return
	
	var target_pos = target.global_position + offset
	
	# Spring-based follow prevents the 'elastic' feel of simple lerp 
	# and reduces visual stutter at high speeds.
	global_position = global_position.lerp(target_pos, delta * spring_stiffness)
	
	look_at(target.global_position)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_camera3d.html
# - https://docs.godotengine.org/en/stable/tutorials/3d/spring_arm.html
# - https://docs.godotengine.org/en/stable/classes/class_springarm3d.html
# - https://docs.godotengine.org/en/stable/tutorials/math/interpolation.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-physics-3d/SKILL.md — follow CharacterBody3D / collision context
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-raycasting-queries/SKILL.md — custom occlusion if not using SpringArm
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — prove follow jitter vs physics tick
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-camera-systems/SKILL.md
# =============================================================================
