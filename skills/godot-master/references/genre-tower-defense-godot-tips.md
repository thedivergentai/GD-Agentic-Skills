# Godot-Specific Tips

*   **Physics Layers**: Put enemies on a specific layer (e.g., Layer 2) and tower "range" Areas on a different mask to avoid towers detecting each other or walls.
*   **Area2D Performance**: For massive numbers of enemies, avoid `monitorable/monitoring` on every frame if possible. Use `PhysicsServer2D` queries for optimization if enemy count > 500.
*   **Object Pooling**: Essential for projectiles and enemies to avoid garbage collection stutters during intense waves.


---

## ðŸš€ Elite Technical Implementations (Batch 09)

### 1. Navigation-Path-Validation (Maze Sealing Prevention)
In mazing TD games, players must not be able to block the exit. Use `AStarGrid2D` to simulate building placement and verify that a valid path still exists from spawn to core.

```gdscript
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
```

### 2. Burst-Searching (Frame-Sliced Targeting)
Towers scanning for enemies every frame create CPU spikes. Use `Engine.get_process_frames()` with a random offset to distribute targeting logic across multiple frames.

```gdscript
class_name BurstSearchTower extends Node2D

@export var search_interval_frames: int = 10
@export var attack_range: float = 250.0

var _frame_offset: int = 0
var _current_target: Node2D = null

func _ready() -> void:
    # Stagger search frame per tower
    _frame_offset = randi() % search_interval_frames

func _physics_process(_delta: float) -> void:
    # Execute expensive logic only once every N frames
    if (Engine.get_process_frames() + _frame_offset) % search_interval_frames == 0:
        _burst_search_for_target()

func _burst_search_for_target() -> void:
    var enemies: Array[Node] = get_tree().get_nodes_in_group("enemies")
    # ... distance squared logic to pick closest target ...
```

### 3. Bezier-Path-Follow (Organic Movement)
Smooth, curved enemy movement is achieved using `Path2D` and `PathFollow2D`. Increase the `progress` property to move the enemy along the spline.

```gdscript
class_name OrganicEnemyMovement extends PathFollow2D

@export var move_speed: float = 150.0

func _physics_process(delta: float) -> void:
    # Use 'progress' (Godot 4) to advance along the Curve2D
    progress += move_speed * delta
    
    if progress_ratio >= 1.0:
        # Reached the core
        queue_free()
```


- Master Skill: [godot-master](../SKILL.md)
- Related: Prove wave/economy bands with [godot-monte-carlo-balancer](../SKILL.md) (see also lane-defense example ref).
