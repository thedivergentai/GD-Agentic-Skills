extends Node
class_name SandboxWorldSerializer

## Expert Sandbox Serialization (Godot 4.7).
## Serializes all player-placed 'Persist' nodes to JSON.

const SAVE_PATH = "user://sandbox_world.json"

func save_world() -> void:
	var data = []
	for node in get_tree().get_nodes_in_group("Persist"):
		if node.scene_file_path.is_empty(): continue
		
		var node_data = {
			"res": node.scene_file_path,
			"pos": var_to_str(node.global_position),
			"rot": var_to_str(node.global_rotation)
		}
		data.append(node_data)
	
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(data))

func load_world() -> void:
	if not FileAccess.file_exists(SAVE_PATH): return
	
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	
	for entry in data:
		var scene = load(entry.res) as PackedScene
		var inst = scene.instantiate() as Node3D
		get_tree().current_scene.add_child(inst)
		inst.global_position = str_to_var(entry.pos)
		inst.global_rotation = str_to_var(entry.rot)

## [SKILL NOTICE]: Use 'scene_file_path' and 'str_to_var()' to cleanly 
## serialize complex 3D world states into lightweight JSON files.
