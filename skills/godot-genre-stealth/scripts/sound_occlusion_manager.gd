extends Node
class_name SoundOcclusionManager

## Expert Sound Propagation (Godot 4.7).
## Emits noise events and checks for physical occlusion (walls).

func emit_noise(origin: Vector3, radius: float) -> void:
	var npcs = get_tree().get_nodes_in_group("guards")
	var space = get_viewport().get_world_3d().direct_space_state
	
	for npc in npcs:
		var dist = origin.distance_to(npc.global_position)
		if dist > radius: continue
		
		# Check for physical occlusion
		var query = PhysicsRayQueryParameters3D.create(origin, npc.global_position)
		query.collision_mask = 1 # World/Geometry layer
		var result = space.intersect_ray(query)
		
		# Expert Pattern: Muffle radius if blocked by geometry
		var final_radius = radius * 0.4 if result else radius
		if dist <= final_radius:
			npc.on_noise_heard(origin)

## [SKILL NOTICE]: Use raycasts to 'muffle' sounds when blocked 
## by static geometry, creating realistic acoustic occlusion.

# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/physics/ray-casting.html
# - https://docs.godotengine.org/en/stable/tutorials/audio/audio_buses.html
# - https://docs.godotengine.org/en/stable/tutorials/navigation/navigation_using_navigationpaths.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/groups.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-audio-systems/SKILL.md — emit loud events onto AI-audible buses
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-navigation-pathfinding/SKILL.md — prefer path-length hearing over Euclidean
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-raycasting-queries/SKILL.md — geometry muffling via world-layer rays
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-stealth/SKILL.md
# =============================================================================
