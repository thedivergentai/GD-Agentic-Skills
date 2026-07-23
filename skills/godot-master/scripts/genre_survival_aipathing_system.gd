class_name AIPathingSystem extends Node

var _astar_grid: AStarGrid2D

func _ready() -> void:
    _astar_grid = AStarGrid2D.new()
    _astar_grid.region = Rect2i(-100, -100, 200, 200)
    _astar_grid.cell_size = Vector2(1, 1)
    _astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES
    _astar_grid.update()

## Called whenever a structure is placed in the world.
func on_structure_built(grid_coords: Vector2i) -> void:
    if _astar_grid.is_in_bounds(grid_coords.x, grid_coords.y):
        # Mark the point as solid, instantly routing AI around the new structure.
        _astar_grid.set_point_solid(grid_coords, true)

## Queries the shortest path for an AI agent.
func get_ai_path(start: Vector2i, target: Vector2i) -> Array[Vector2i]:
    return _astar_grid.get_id_path(start, target)
