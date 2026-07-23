# Gridmap And Csg

## GridMap Fundamentals

### Setup Workflow

```gdscript
# 1. Create MeshLibrary resource (editor)
# Scene → New Inherits Scene → Create Grid-aligned meshes
# Scene → Convert To → MeshLibrary...

# 2. Assign to GridMap
extends GridMap

func _ready() -> void:
    mesh_library = load("res://tilesets/dungeon_library.tres")
    cell_size = Vector3(2, 2, 2)  # Must match library cell size
```

### Cell Manipulation

```gdscript
# gridmap_builder.gd
extends GridMap

# Place cell
func place_tile(grid_pos: Vector3i, tile_index: int) -> void:
    set_cell_item(grid_pos, tile_index)

# Get cell
func get_tile(grid_pos: Vector3i) -> int:
    return get_cell_item(grid_pos)  # Returns index or INVALID_CELL_ITEM (-1)

# Remove cell
func remove_tile(grid_pos: Vector3i) -> void:
    set_cell_item(grid_pos, INVALID_CELL_ITEM)

# Rotate cell (0-23, see GridMap.ROTATION_* constants)
func place_rotated(grid_pos: Vector3i, tile_index: int, orientation: int) -> void:
    set_cell_item(grid_pos, tile_index, orientation)
```

### Coordinate Conversion

```gdscript
# World position ↔ Grid coordinates
func _input(event: InputEvent) -> void:
    if event is InputEventMouseButton and event.pressed:
        var camera := get_viewport().get_camera_3d()
        var from := camera.project_ray_origin(event.position)
        var to := from + camera.project_ray_normal(event.position) * 1000
        
        var space := get_world_3d().direct_space_state
        var query := PhysicsRayQueryParameters3D.create(from, to)
        var result := space.intersect_ray(query)
        
        if result:
            var world_pos: Vector3 = result.position
            var grid_pos := local_to_map(to_local(world_pos))
            place_tile(grid_pos, 0)  # Place tile at clicked position

# Grid → World
func get_cell_center(grid_pos: Vector3i) -> Vector3:
    return to_global(map_to_local(grid_pos))
```

---

## CSG (Constructive Solid Geometry)

### Boolean Operations

```
CSG Combiner3D
  ├─ CSGBox3D (Operation: Union)        # Base room
  ├─ CSGBox3D (Operation: Subtraction)  # Door cutout
  └─ CSGSphere3D (Operation: Intersection)  # Rounded corner
```

### CSG Brush Types

```gdscript
# CSGBox3D - Room primitives
var room := CSGBox3D.new()
room.size = Vector3(10, 5, 10)

# CSGCylinder3D - Pillars
var pillar := CSGCylinder3D.new()
pillar.radius = 0.5
pillar.height = 5.0

# CSGSphere3D - Domes
var dome := CSGSphere3D.new()
dome.radius = 3.0
dome.radial_segments = 16
dome.rings = 8

# CSGPolygon3D - Extruded 2D shapes
var arch := CSGPolygon3D.new()
arch.polygon = PackedVector2Array([
    Vector2(-1, 0), Vector2(-1, 2), Vector2(1, 2), Vector2(1, 0)
])
arch.depth = 0.5
```

### CSG Performance

```gdscript
# ❌ BAD: Use CSG at runtime (slow)
func _ready() -> void:
    var csg := CSGBox3D.new()
    add_child(csg)  # Recalculates mesh every frame

# ✅ GOOD: Bake to MeshInstance3D (editor only)
# Select CSG node → Mesh → Bake Mesh Instance
# Then delete CSG node

# ✅ ALSO GOOD: Use CSG for level editor, bake on export
```

---

## Expert Pattern: GridMap-Custom-Data (Logic Proxies)

Since `GridMap` is optimized for visuals/collision rather than logic, use "Proxy Tiles" to mark locations for spawn points, NPCs, or triggers during level design.

```gdscript
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
```

---
