# fast_travel_system.gd
class_name FastTravelSystem extends Node

func travel_to_node(scene_path: String, spawn_id: StringName) -> void:
    # Load the packed scene resource
    var room_scene := ResourceLoader.load(scene_path) as PackedScene
    if room_scene:
        # Cache the spawn ID for the next scene's _ready() call
        GlobalState.target_spawn_id = spawn_id
        get_tree().change_scene_to_packed(room_scene)
