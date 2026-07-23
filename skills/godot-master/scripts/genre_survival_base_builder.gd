class_name BaseBuilder extends Node3D

@export var grid_map: GridMap
@export var wooden_wall_item_id: int = 1

## Snaps a global 3D coordinate to the grid and places a structure.
func build_structure(hit_position: Vector3) -> void:
    # 1. Convert global space to grid map coordinate.
    var grid_pos: Vector3i = grid_map.local_to_map(hit_position)
    
    # 2. Verify the target cell is empty.
    if grid_map.get_cell_item(grid_pos) == GridMap.INVALID_CELL_ITEM:
        # 3. Place the structure item at the snapped coordinates.
        grid_map.set_cell_item(grid_pos, wooden_wall_item_id)
        print("Structure successfully snapped and built!")
    else:
        push_warning("Cannot build here: Cell is already occupied.")
