class_name SoundPropagation
extends Node

# Sound travels through connected navigation points, not through walls
func propagate_sound(origin: Vector3, loudness: float, sound_type: String) -> void:
    for enemy in get_tree().get_nodes_in_group("enemies"):
        var path := NavigationServer3D.map_get_path(
            get_world_3d().navigation_map,
            origin,
            enemy.global_position,
            true
        )
        
        if path.is_empty():
            continue  # No path = sound blocked
        
        var path_distance := calculate_path_length(path)
        var heard_loudness := loudness - (path_distance * 0.5)  # Falloff
        
        if heard_loudness > enemy.hearing_threshold:
            enemy.hear_sound(origin, sound_type, heard_loudness)

func calculate_path_length(path: PackedVector3Array) -> float:
    var length := 0.0
    for i in range(1, path.size()):
        length += path[i].distance_to(path[i - 1])
    return length
