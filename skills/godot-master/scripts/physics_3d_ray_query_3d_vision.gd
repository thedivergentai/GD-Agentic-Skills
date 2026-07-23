# ray_query_3d_vision.gd
# Expert 3D line-of-sight using direct space state [Raycasting]
extends Node3D

func can_see_target(target: Node3D) -> bool:
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(global_position, target.global_position)
	query.collision_mask = 1 # World
	query.exclude = [get_parent().get_rid() if get_parent() is CollisionObject3D else RID()]
	
	var result = space_state.intersect_ray(query)
	return result.is_empty() or result.collider == target
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/physics/ray-casting.html
# - https://docs.godotengine.org/en/stable/classes/class_physicsdirectspacestate3d.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-raycasting-queries/SKILL.md — query masks, exclusions, and ShapeCast recipes
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-navigation-pathfinding/SKILL.md — LOS checks alongside nav agents
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-physics-3d/SKILL.md
# =============================================================================
