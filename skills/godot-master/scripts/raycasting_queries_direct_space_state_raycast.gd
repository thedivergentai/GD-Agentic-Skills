# direct_space_state_raycast.gd
# Querying physics state directly via PhysicsServer for max speed
extends Node3D

func fire_laser(origin: Vector3, end: Vector3) -> void:
	var space_state = get_world_3d().direct_space_state
	
	# create() is a fast helper to initialize the query parameters
	var query = PhysicsRayQueryParameters3D.create(origin, end)
	query.exclude = [self.get_rid()] # Expert: Use RID for faster exclusion
	
	var result = space_state.intersect_ray(query)
	
	if result:
		print("Hit at point: ", result.position)
		print("Collider: ", result.collider)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/physics/ray-casting.html
# - https://docs.godotengine.org/en/stable/classes/class_physicsdirectspacestate3d.html
# - https://docs.godotengine.org/en/stable/classes/class_physicsrayqueryparameters3d.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-physics-3d/SKILL.md — 3D bodies/masks the ray can hit
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-combat-system/SKILL.md — hitscan from direct space rays
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-raycasting-queries/SKILL.md
# =============================================================================
