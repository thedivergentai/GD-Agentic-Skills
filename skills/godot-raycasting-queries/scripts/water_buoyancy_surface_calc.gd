# water_buoyancy_surface_calc.gd
# Vertical raycasting to find water surface levels
extends Node3D

func get_water_height_at(pos_2d: Vector2) -> float:
	var space_state = get_world_3d().direct_space_state
	
	# Cast from high altitude down to find the surface
	var start = Vector3(pos_2d.x, 100, pos_2d.y)
	var end = Vector3(pos_2d.x, -50, pos_2d.y)
	
	var query = PhysicsRayQueryParameters3D.create(start, end)
	query.collision_mask = 16 # Water layer mask
	query.hit_from_inside = true # Detect if we're already underwater
	
	var res = space_state.intersect_ray(query)
	if res:
		return res.position.y
	return -1.0 # No water found
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_physicsrayqueryparameters3d.html
# - https://docs.godotengine.org/en/stable/tutorials/physics/physics_introduction.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-physics-3d/SKILL.md — water layer/mask conventions
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md — named layer for water mask bit
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-raycasting-queries/SKILL.md
# =============================================================================
