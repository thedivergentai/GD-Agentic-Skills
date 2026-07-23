# room_metadata.gd
class_name RoomMetadata extends Resource

@export var is_cleared: bool = false
@export var collected_item_ids: Array[StringName] = []
@export var enemy_positions: Array[Vector3] = []

func save_room_state(node: Node) -> void:
    # Logic to populate resource from current room state
    ResourceSaver.save(self, node.scene_file_path + ".tres")
