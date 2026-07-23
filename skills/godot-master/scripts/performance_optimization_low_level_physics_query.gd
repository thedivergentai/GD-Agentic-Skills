# low_level_physics_query.gd
# Direct PhysicsServer queries for high performance
extends Node3D

# EXPERT NOTE: Direct space queries via DirectSpaceState 
# are faster than RayCast nodes when doing hundreds of checks 
# per frame (e.g. for AI vision or custom particles).

func _physics_process(_delta):
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(global_position, global_position + Vector3.FORWARD * 10)
	query.exclude = [get_rid()]
	
	var result = space_state.intersect_ray(query)
	if result:
		# Handle hit
		pass
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/performance/using_servers.html
# - https://docs.godotengine.org/en/stable/tutorials/physics/physics_introduction.html
# - https://docs.godotengine.org/en/stable/tutorials/performance/cpu_optimization.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-raycasting-queries/SKILL.md — space-state query patterns and masks
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-2d-physics/SKILL.md — 2D PhysicsDirectSpaceState usage
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-physics-3d/SKILL.md — 3D query equivalents and shape cost
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md
# =============================================================================
