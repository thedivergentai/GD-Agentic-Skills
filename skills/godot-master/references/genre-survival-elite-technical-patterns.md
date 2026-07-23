# Survival Elite Implementations (load on demand)

> **MANDATORY** when starting base-building snap placement or biome/noise world work — not for first-pass needs/inventory/crafting (use `scripts/` catalog).

## When to open this file
- GridMap snap base-building beyond `SurvivalPatterns.place_if_empty`
- AStar reroute when structures block threat AI
- FastNoiseLite biome sampling at scale (pair with `SurvivalPatterns.generate_noise_chunk_async`)

## Do NOT Load
- Hunger/thirst wiring — use `status_depletion_manager.gd`
- Bag/stack basics — use `inventory_data.gd`; weight caps → godot-inventory-system (Do NOT re-teach grid drag/drop here)
- Full procedural terrain pipeline — MANDATORY-link godot-procedural-generation when noise maps exceed chunk helpers

---

## 1. Grid-Map-Snap (Base-Building)

Use `GridMap` octants. **MANDATORY:** `SurvivalPatterns.place_if_empty` / `get_snapped_pos` rather than freeform MeshInstance walls.

## 2. AStar-Path-Avoidance

When structures place, mark `AStarGrid2D` cells solid so threat AI reroutes immediately (pair with godot-ai-navigation).

## 3. FastNoiseLite Biomes

Sample noise gradients → biome ids; keep generation off the main thread via `SurvivalPatterns.generate_noise_chunk_async` for large maps.

---

# ðŸš€ Elite Technical Implementations (Batch 09)

### 1. Grid-Map-Snap Pattern (Base-Building)
For performant base-building in 3D, use the `GridMap` node. It uses octant-based optimization to handle thousands of structure pieces with minimal CPU overhead compared to standard `MeshInstance3D` nodes.

```gdscript
class_name BaseBuilder extends Node3D

@export var grid_map: GridMap
@export var wooden_wall_item_id: int = 1

---

# Snaps a global 3D coordinate to the grid and places a structure.

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
```

### 2. AStar-Path-Avoidance (Dynamic AI Routing)
When players build structures, AI must immediately find new paths. `AStarGrid2D` provides an efficient way to update the pathfinding graph in real-time by flagging specific cells as solid.

```gdscript
class_name AIPathingSystem extends Node

var _astar_grid: AStarGrid2D

func _ready() -> void:
    _astar_grid = AStarGrid2D.new()
    _astar_grid.region = Rect2i(-100, -100, 200, 200)
    _astar_grid.cell_size = Vector2(1, 1)
    _astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES
    _astar_grid.update()

---

# Called whenever a structure is placed in the world.

func on_structure_built(grid_coords: Vector2i) -> void:
    if _astar_grid.is_in_bounds(grid_coords.x, grid_coords.y):
        # Mark the point as solid, instantly routing AI around the new structure.
        _astar_grid.set_point_solid(grid_coords, true)

---

# Queries the shortest path for an AI agent.

func get_ai_path(start: Vector2i, target: Vector2i) -> Array[Vector2i]:
    return _astar_grid.get_id_path(start, target)
```

### 3. FastNoiseLite Biome-Generation Pattern
Procedural world generation requires organic transitions between ecosystems. Use `FastNoiseLite` to generate a noise map and map its gradients (-1.0 to 1.0) to specific biomes.

```gdscript
class_name BiomeGenerator extends Node

var _biome_noise: FastNoiseLite

func _ready() -> void:
    _biome_noise = FastNoiseLite.new()
    _biome_noise.seed = randi() 
    _biome_noise.fractal_type = FastNoiseLite.FRACTAL_FBM
    _biome_noise.fractal_octaves = 5
    _biome_noise.frequency = 0.05

---

# Samples the noise at a specific coordinate to determine the biome type.

func get_biome_at_coordinate(x: float, y: float) -> String:
    var noise_val: float = _biome_noise.get_noise_2d(x, y)
    
    if noise_val < -0.25:
        return "Deep_Ocean"
    elif noise_val < 0.0:
        return "Shallow_Water"
    elif noise_val < 0.4:
        return "Forest"
    else:
        return "Mountain"
```


- Master Skill: [godot-master](../SKILL.md)
