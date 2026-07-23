class_name PassPredictor extends Node3D

func is_lane_clear(target_pos: Vector3) -> bool:
    var space_state := get_world_3d().direct_space_state
    var query := PhysicsRayQueryParameters3D.create(global_position, target_pos)
    query.collision_mask = 1 # Environment/Opponents
    
    var result := space_state.intersect_ray(query)
    return result.is_empty() # Path is clear if no collision
