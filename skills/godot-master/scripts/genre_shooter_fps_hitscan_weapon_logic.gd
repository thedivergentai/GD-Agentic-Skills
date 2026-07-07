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
