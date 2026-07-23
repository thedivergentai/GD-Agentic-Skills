extends Area3D
class_name HomingProjectile3D

## Expert Homing Projectile (Godot 4.7).
## Uses Quaternion slerp for smooth tracking and handles 'Target Lost' gracefully.

@export var speed: float = 15.0
@export var turn_speed: float = 5.0
var target: Node3D = null

func _physics_process(delta: float) -> void:
	# 1. Aim Logic (Rotation)
	if is_instance_valid(target):
		var target_pos = target.global_position
		var dir = global_position.direction_to(target_pos)
		
		# Expert Pattern: Smoothly rotate basis using Quaternions
		var target_basis = Basis.looking_at(dir)
		var current_quat = global_transform.basis.get_rotation_quaternion()
		var target_quat = target_basis.get_rotation_quaternion()
		
		global_transform.basis = Basis(current_quat.slerp(target_quat, turn_speed * delta))
	
	# 2. Movement Logic (Local Forward)
	global_position += -global_transform.basis.z * speed * delta

## [SKILL NOTICE]: Use 'is_instance_valid(target)' to check if the enemy 
## was freed/killed before impact to prevent null pointer crashes.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_quaternion.html
# - https://docs.godotengine.org/en/stable/classes/class_basis.html
# - https://docs.godotengine.org/en/stable/tutorials/3d/using_transforms.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-combat-system/SKILL.md — projectile lifetime and target-lost handling
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-physics-3d/SKILL.md — Area3D hit detection on impact
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md — pool homing missiles under wave spikes
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-tower-defense/SKILL.md
# =============================================================================
