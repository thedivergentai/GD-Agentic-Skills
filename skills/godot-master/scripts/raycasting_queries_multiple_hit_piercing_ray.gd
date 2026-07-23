# multiple_hit_piercing_ray.gd
# Implementing projectiles that pierce through multiple enemies
extends Node3D

func raycast_pierce(from: Vector3, to: Vector3, max_hits: int = 5):
	var hits = []
	var space_state = get_world_3d().direct_space_state
	var exclude = [self.get_rid()]
	
	for i in range(max_hits):
		var query = PhysicsRayQueryParameters3D.create(from, to)
		query.exclude = exclude
		var result = space_state.intersect_ray(query)
		
		if result:
			hits.append(result)
			# Exclude the RID of the hit object to pierce it in the next iteration
			exclude.append(result.rid) 
		else:
			break
			
	return hits
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_physicsrayqueryparameters3d.html
# - https://docs.godotengine.org/en/stable/classes/class_physicsdirectspacestate3d.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-combat-system/SKILL.md — pierce damage per successive hit
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-shooter/SKILL.md — multi-enemy pierce projectiles
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-raycasting-queries/SKILL.md
# =============================================================================
