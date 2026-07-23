# Puzzle Elite Implementations (load on demand)

> **LLM-ignorance keep rule:** content here is expert Godot/genre knowledge a general agent would not know without reading — never delete, only relocate.

> **MANDATORY** when implementing systems beyond the `scripts/` catalog. Peer skills own full tutorials — route after this reference.

---

## Architecture Overview

### 1. Command Pattern (Undo System)
Essential for puzzle games. Never punish testing.

```gdscript
# command.gd
class_name Command extends RefCounted

func execute() -> void: pass
func undo() -> void: pass

# level_manager.gd
var history: Array[Command] = []
var history_index: int = -1

func commit_command(cmd: Command) -> void:
    # Clear redo history if diverging
    if history_index < history.size() - 1:
        history = history.slice(0, history_index + 1)
        
    cmd.execute()
    history.append(cmd)
    history_index += 1

func undo() -> void:
    if history_index >= 0:
        history[history_index].undo()
        history_index -= 1
```

### 2. Grid System (TileMap vs Custom)
For grid-based puzzles (Sokoban), a custom data structure is often better than just reading physics.

```gdscript
# grid_manager.gd
var grid_size: Vector2i = Vector2i(16, 16)
var objects: Dictionary = {} # Vector2i -> Node

func move_object(obj: Node, direction: Vector2i) -> bool:
    var start_pos = grid_pos(obj.position)
    var target_pos = start_pos + direction
    
    if is_wall(target_pos):
        return false
        
    if objects.has(target_pos):
        # Handle pushing logic here
        return false
        
    # Execute move
    objects.erase(start_pos)
    objects[target_pos] = obj
    tween_movement(obj, target_pos)
    return true
```

---

## Key Mechanics Implementation

### Win Condition Checking
Check victory state after every move.

```gdscript
func check_win_condition() -> void:
    for target in targets:
        if not is_satisfied(target):
            return
    
    level_complete.emit()
    save_progress()
```

### Non-Verbal Tutorials
Teach mechanics through level design, not text.
1.  **Isolation**: Level 1 introduces *only* the new mechanic in a safe room.
2.  **Reinforcement**: Level 2 requires using it to solve a trivial problem.
3.  **Combination**: Level 3 combines it with previous mechanics.

---

## Godot-Specific Tips

*   **Tweens**: Use `create_tween()` for all grid movements. It feels much better than instant snapping.
*   **Custom Resources**: Store level data (layout, starting positions) in `.tres` files for easy editing in the Inspector.
*   **Signals**: Use signals like `state_changed` to update UI/Visuals decoupled from the logic.


---

---

## 🚀 Elite Technical Implementations (Batch 09)

### 1. Level-Editor Serialization Pattern
For puzzle games with custom editors, avoid using `.tscn` at runtime. Instead, use `FileAccess` and `JSON` to serialize grid data into compact, human-readable files in the `user://` directory.

```gdscript
class_name LevelSerializer extends Node

const LEVEL_DIR := "user://levels/"

---

## Deserializes a JSON file back into a Dictionary.
static func load_level(level_name: String) -> Dictionary:
    var path := LEVEL_DIR + level_name + ".json"
    var file := FileAccess.open(path, FileAccess.READ)
    
    if file:
        var json_string := file.get_as_text()
        var parsed_data = JSON.parse_string(json_string)
        if parsed_data is Dictionary:
            return parsed_data as Dictionary
    return {}
```

### 2. Hint-Systems (A* Solvers)
Use `AStarGrid2D` to provide logical hints. It is optimized for uniform grids and supports Jump Point Search (JPS) via `jumping_enabled` to drastically speed up pathfinding on large puzzle layouts.

```gdscript
class_name PuzzleHintSystem extends Node

var _astar_grid: AStarGrid2D

func _ready() -> void:
    _astar_grid = AStarGrid2D.new()
    _astar_grid.region = Rect2i(0, 0, 32, 32)
    _astar_grid.cell_size = Vector2(1, 1)
    _astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
    _astar_grid.jumping_enabled = true 
    _astar_grid.update()

---

## Queries the solver for the next logical step.
func get_next_hint_step(player_pos: Vector2i, goal_pos: Vector2i) -> Vector2i:
    var path := _astar_grid.get_id_path(player_pos, goal_pos)
    if path.size() > 1:
        return path[1] # Return next step in sequence
    return player_pos
```

### 3. State-Snapshot Pattern (Instant Resets)
Avoid `reload_current_scene()` for resets to prevent frame drops and UI flickering. Instead, capture the initial positions of all pieces into a `Dictionary` and restore them instantly.

```gdscript
class_name StateSnapshotManager extends Node

signal state_restored()
var _initial_state_snapshot: Dictionary[NodePath, Vector2] = {}
