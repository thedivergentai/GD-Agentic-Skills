# query_exclusion_optimization.gd
# Optimizing queries by specifically excluding RIDs
extends Node

var _ignored_rids: Array[RID] = []

func add_ignored_body(body: CollisionObject3D):
	_ignored_rids.append(body.get_rid())

func efficient_query(from: Vector3, to: Vector3):
	var query = PhysicsRayQueryParameters3D.create(from, to)
	# EXPERT: Passing RIDs directly is faster than NodePath arrays
	query.exclude = _ignored_rids
	
	return get_world_3d().direct_space_state.intersect_ray(query)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_physicsrayqueryparameters3d.html
# - https://docs.godotengine.org/en/stable/tutorials/physics/ray-casting.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md — RID exclude lists at scale
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-combat-system/SKILL.md — ignore caster/allies on hitscan
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-raycasting-queries/SKILL.md
# =============================================================================
