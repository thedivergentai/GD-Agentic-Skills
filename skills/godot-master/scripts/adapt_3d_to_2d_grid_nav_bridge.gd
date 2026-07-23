class_name GridNavBridge extends Node

var astar_grid: AStarGrid2D

func _ready() -> void:
    astar_grid = AStarGrid2D.new()
    astar_grid.region = Rect2i(0, 0, 100, 100)
    astar_grid.cell_size = Vector2(16, 16)
    astar_grid.update()

## Converts a 3D target position to a 2D grid path.
func get_grid_path_from_3d(start_3d: Vector3, end_3d: Vector3) -> PackedVector2Array:
    var start_map := Vector2i(start_3d.x / 16, start_3d.z / 16)
    var end_map := Vector2i(end_3d.x / 16, end_3d.z / 16)
    
    return astar_grid.get_point_path(start_map, end_map)
