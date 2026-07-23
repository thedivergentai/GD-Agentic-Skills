# building_grid_astar.gd
extends Node
class_name BuildingGridAStar

# Grid-Based AStar for Base Building
# Instant grid pathfinding for placing structures and unit grid-navigation.

var astar_grid := AStarGrid2D.new()

func init_grid(size: Vector2i, cell_size: Vector2) -> void:
    astar_grid.region = Rect2i(Vector2i.ZERO, size)
    astar_grid.cell_size = cell_size
    astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
    astar_grid.update()

func mark_occupied(cell: Vector2i, occupied: bool) -> void:
    # Pattern: AStarGrid2D is much faster than Node-based AStar for grid RTS.
    astar_grid.set_point_solid(cell, occupied)

func is_cell_valid(cell: Vector2i) -> bool:
    return not astar_grid.is_point_solid(cell)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_astargrid2d.html
# - https://docs.godotengine.org/en/stable/tutorials/navigation/navigation_introduction_2d.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-navigation-pathfinding/SKILL.md — grid placement path checks
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-builder/SKILL.md — base-building placement loops
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-rts/SKILL.md
# =============================================================================
