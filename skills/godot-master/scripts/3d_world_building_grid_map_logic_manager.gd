class_name GridMapLogicManager extends Node3D

@export var level_grid: GridMap
@export var spawn_point_scene: PackedScene

# The ID of the invisible cube in your MeshLibrary
const SPAWN_PROXY_ID: int = 5 

func _ready() -> void:
    _replace_proxies_with_logic()

func _replace_proxies_with_logic() -> void:
    # 1. Find all cells using the proxy tile
    var proxy_cells: Array[Vector3i] = level_grid.get_used_cells_by_item(SPAWN_PROXY_ID)
    
    for cell in proxy_cells:
        # 2. Convert grid pos to world pos
        var world_pos: Vector3 = level_grid.to_global(level_grid.map_to_local(cell))
        
        # 3. Instantiate actual gameplay logic
        var instance: Node3D = spawn_point_scene.instantiate()
        add_child(instance)
        instance.global_position = world_pos
        
        # 4. Clear the proxy tile to save performance
        level_grid.set_cell_item(cell, GridMap.INVALID_CELL_ITEM)
