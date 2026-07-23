class_name GridPathValidator extends Node

var _astar_grid: AStarGrid2D
@export var spawn_point: Vector2i = Vector2i(0, 0)
@export var core_point: Vector2i = Vector2i(20, 20)

func _ready() -> void:
    _astar_grid = AStarGrid2D.new()
    _astar_grid.region = Rect2i(0, 0, 40, 40)
    _astar_grid.cell_size = Vector2(64, 64)
    _astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
    _astar_grid.update()

## Simulates placing a tower. Returns true if the path remains valid.
func can_build_tower_at(cell_coords: Vector2i) -> bool:
    if _astar_grid.is_point_solid(cell_coords):
        return false
        
    # 1. Temporarily mark the cell as solid
    _astar_grid.set_point_solid(cell_coords, true)
    
    # 2. Query path from start to finish
    var test_path: Array[Vector2i] = _astar_grid.get_id_path(spawn_point, core_point)
    
    # 3. If empty, maze is sealed. Revert and deny.
    if test_path.is_empty():
        _astar_grid.set_point_solid(cell_coords, false)
        return false
        
    return true
