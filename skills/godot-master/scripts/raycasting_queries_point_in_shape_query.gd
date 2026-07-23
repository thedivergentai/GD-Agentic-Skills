# point_in_shape_query.gd
# Checking for overlapping physics bodies at a pinpoint epicenter
extends Node3D

func check_point_overlap(epicenter: Vector3, mask: int = 1) -> Array[Dictionary]:
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsPointQueryParameters3D.new()
	query.position = epicenter
	query.collision_mask = mask
	
	# Checks whether the point is inside any solid shape (Concave/Convex/Primitive)
	return space_state.intersect_point(query)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_physicspointqueryparameters3d.html
# - https://docs.godotengine.org/en/stable/classes/class_physicsdirectspacestate3d.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-combat-system/SKILL.md — explosion epicenter overlap
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-2d-physics/SKILL.md — 2D point query twin patterns
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-raycasting-queries/SKILL.md
# =============================================================================
