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
