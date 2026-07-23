extends Node3D
class_name VisionCone3D

## Expert Vision Cone (Godot 4.7).
## Combines Dot Product angle checks with Physics Raycasts for LoS.

@export var fov: float = 90.0
@export var view_distance: float = 20.0
@export var detection_speed: float = 0.5

var detection_level: float = 0.0

func _physics_process(delta: float) -> void:
	var player = get_tree().get_first_node_in_group("player")
	if not player: return
	
	if _has_line_of_sight(player):
		var dist_factor = 1.0 - (global_position.distance_to(player.global_position) / view_distance)
		detection_level += delta * detection_speed * max(0.1, dist_factor)
	else:
		detection_level = max(0.0, detection_level - delta * 0.2)

func _has_line_of_sight(target: Node3D) -> bool:
	var to_target = global_position.direction_to(target.global_position)
	var forward = -global_transform.basis.z
	
	# 1. Angle Check (Dot Product)
	if forward.dot(to_target) < cos(deg_to_rad(fov/2)): return false
	
	# 2. Physics Check (Raycast)
	var space = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(global_position, target.global_position)
	var result = space.intersect_ray(query)
	
	return result and result.collider == target

## [SKILL NOTICE]: Use 'intersect_ray' instead of multiple RayCast3D 
## nodes for dynamic, high-performance line-of-sight checks.

# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/physics/ray-casting.html
# - https://docs.godotengine.org/en/stable/classes/class_physicsdirectspacestate3d.html
# - https://docs.godotengine.org/en/stable/classes/class_physicsrayqueryparameters3d.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-raycasting-queries/SKILL.md — dot-product FOV then intersect_ray confirmation
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-physics-3d/SKILL.md — collider identity checks on ray results
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md — FOV/view_distance/detection_speed knobs
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-stealth/SKILL.md
# =============================================================================
