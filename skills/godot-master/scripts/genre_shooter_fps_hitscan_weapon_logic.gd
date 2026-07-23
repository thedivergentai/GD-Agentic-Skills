extends Node3D
class_name HitscanWeaponLogic

## Expert Weapon Logic (Godot 4.7).
## Decoupled hitscan logic with signal-based VFX triggering.

signal shot_fired(hit_point: Vector3, hit_normal: Vector3, collider: Object)

@export var range_m: float = 100.0
@export var damage: float = 25.0

func shoot() -> void:
	var space = get_world_3d().direct_space_state
	var cam = get_viewport().get_camera_3d()
	
	var from = cam.global_position
	var to = from + -cam.global_transform.basis.z * range_m
	
	# Raycast query
	var query = PhysicsRayQueryParameters3D.create(from, to)
	var collision = space.intersect_ray(query)
	
	if collision:
		if collision.collider.has_method("take_damage"):
			collision.collider.take_damage(damage)
		shot_fired.emit(collision.position, collision.normal, collision.collider)
	else:
		shot_fired.emit(to, Vector3.ZERO, null)

## [SKILL NOTICE]: Use 'Signals' to trigger muzzle flashes and impacts. 
## This keeps your mathematical hitscan logic separate from the visual effects.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/physics/ray-casting.html
# - https://docs.godotengine.org/en/stable/classes/class_physicsrayqueryparameters3d.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-raycasting-queries/SKILL.md - exclude player RID and collision masks
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-combat-system/SKILL.md - hit-zone damage multipliers
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-shooter-fps/SKILL.md
# =============================================================================
