---
name: godot-raycasting-queries
description: "Expert blueprint for physics queries using RayCast, ShapeCast, and DirectSpaceState. Covers hit detection, volume overlap, mouse picking, and high-performance server-side intersection queries. Use when implementing projectiles, LOS, terrain grounding, or AI sensors. Keywords raycast, shapecast, direct_space_state, intersect_ray, intersect_shape, PhysicsRayQueryParameters, collision mask, mouse picking."
---

## Godot 4.7 Baseline

- Expert patterns in this skill target **Godot 4.7+** (stable, 2026-06-18).
- Consult the [Godot 4.7 migration guide](https://docs.godotengine.org/en/4.7/tutorials/migrating/upgrading_to_godot_4.7.html) when upgrading projects from 4.6.
- **NEVER** assume 4.6 defaults (stretch mode, audio area_mask, RichTextLabel percent flags) without checking 4.7 migration notes.

# Raycasting and Physics Queries

Physics queries allow for instantaneous detection of objects using lines (rays), volumes (shapes), or points.

## Available Scripts

### [direct_space_state_raycast.gd](scripts/direct_space_state_raycast.gd)
Expert usage of `PhysicsDirectSpaceState2D/3D` for bypassing node-based overhead in high-frequency queries.

### [shapecast_ground_detection.gd](scripts/shapecast_ground_detection.gd)
Reliable ground/footing detection using volume-based `ShapeCast` instead of thin rays.

### [multiple_hit_piercing_ray.gd](scripts/multiple_hit_piercing_ray.gd)
Implementing piercing projectiles that detect and return multiple hits in a single line.

### [field_of_view_scanner.gd](scripts/field_of_view_scanner.gd)
AI sensor logic using a fan of raycasts to detect targets within a FOV cone.

### [raycast_reflection_logic.gd](scripts/raycast_reflection_logic.gd)
Calculating bounces for lasers or bullets using collision normal reflection.

### [point_in_shape_query.gd](scripts/point_in_shape_query.gd)
Checking for overlapping physics bodies at a single point (Explosion epicenters).

### [rest_info_3d_stuck_fix.gd](scripts/rest_info_3d_stuck_fix.gd)
Using `get_rest_info` to detect stuck objects and resolve overlaps immediately.

### [mouse_pick_3d_query.gd](scripts/mouse_pick_3d_query.gd)
Converting 2D screen coordinates to 3D world rays for point-and-click interaction.

### [water_buoyancy_surface_calc.gd](scripts/water_buoyancy_surface_calc.gd)
Finding water surface height for buoyancy systems using high-to-low raycasting.

### [query_exclusion_optimization.gd](scripts/query_exclusion_optimization.gd)
Optimizing performance by excluding specific RIDs (Resource IDs) from intersection checks.

## NEVER Do in Physics Queries

- **NEVER access `direct_space_state` outside of `_physics_process()`** — The physics space can be locked or running on a separate thread; querying it in `_process()` is unsafe [1, 2].
- **NEVER use ShapeCast when a thin RayCast is sufficient** — Volume queries are significantly more expensive. Default to rays unless you need volumetric detection [3, 4].
- **NEVER assume results return `CollisionObject` nodes** — CSG shapes, `GridMap`, and `TileMapLayer` return themselves, not a generic physics body [5, 6].
- **NEVER assume `RayCast` nodes update instantly** — They update once per physics frame. If you move a node and query it immediately, you MUST call `force_raycast_update()` [3, 9].
- **NEVER use complex visual meshes for physics queries** — GPU-only data requires expensive thread locking to parse. Use simplified primitive collision shapes [10, 11].
- **NEVER iterate results to find the first valid hit** — Use `collision_mask` and `collision_layer` to filter queries at the server level for maximum performance.
- **NEVER forget to exclude the caster** — A ray starting from the center of a character will hit the character itself. Use `query.exclude = [self.get_rid()]` [20].
- **NEVER use rays for small, fast detection areas** — Rays can "tunnel" through thin walls if the frame rate drops. Use `cast_motion` or high-frequency stepping for bullets.
- **NEVER query 1000+ rays individually in GDScript** — Batch your queries or use the `PhysicsServer` directly in C++ if you reach extreme query counts.
- **NEVER ignore the `result.rid`** — RIDs are the fastest way to identify and exclude objects in subsequent queries, bypassing node-path lookups [20].

---

## 3D Mouse Picking Example

```gdscript
func screen_point_to_ray():
    var space_state = get_world_3d().direct_space_state
    var mouse_pos = get_viewport().get_mouse_position()
    
    var origin = project_ray_origin(mouse_pos)
    var end = origin + project_ray_normal(mouse_pos) * 2000
    
    var query = PhysicsRayQueryParameters3D.create(origin, end)
    var result = space_state.intersect_ray(query)
    
    if result:
        return result.collider
    return null
```

---

## Expert Raycasting & Query Architectures

### 1. NavMesh-Ray-Constrain (Line-of-Sight via NavMesh)
Standard physics raycasts check against collision shapes, but if using `NavigationObstacle3D` with `carve_navigation_mesh` enabled, the NavMesh dynamically adapts. To check LOS strictly against the NavMesh (avoiding carved holes), query an optimized path between points. If the result contains exactly 2 points, it's a direct, unobstructed line.

```gdscript
class_name NavMeshRayValidator extends Node
## Validates line-of-sight using NavigationServer3D path optimization.

@export var agent: NavigationAgent3D

## Returns true if there is a direct, unobstructed line-of-sight on the NavMesh.
func has_navmesh_line_of_sight(target_position: Vector3) -> bool:
    if not is_instance_valid(agent): return false
        
    var map: RID = agent.get_navigation_map()
    var start_position: Vector3 = agent.global_position
    
    # Query an optimized path using the funnel algorithm.
    var path: PackedVector3Array = NavigationServer3D.map_get_path(
        map, start_position, target_position, true, agent.navigation_layers
    )
    
    # A direct line of sight will yield exactly two points: start and end.
    return path.size() == 2
```

### 2. Collision-Object-Metadata (Decoupled Surface Types)
Instead of checking groups or names on `intersect_ray()` results, utilize Godot's built-in `Object` metadata. Attach arbitrary `Variant` data (e.g., "Stone", "Metal") to `StaticBody3D` nodes. This decouples the physics query from specific class implementations and allows for highly extensible surface interaction logic.

```gdscript
class_name SurfaceRaycaster extends Node3D
## Extracts surface metadata from raycast colliders for decoupled logic.

func perform_surface_raycast() -> void:
    var space_state := get_world_3d().direct_space_state
    var query := PhysicsRayQueryParameters3D.create(global_position, target_pos)
    var result: Dictionary = space_state.intersect_ray(query)
    
    if not result.is_empty():
        var collider: Object = result.collider
        var surface: StringName = &"default"
        
        # Check for explicitly assigned surface metadata.
        if collider.has_meta(&"surface_type"):
            surface = collider.get_meta(&"surface_type")
            
        print_rich("[color=cyan]Hit surface: %s[/color]" % surface)
```

### 3. Compute-Shader-Raycast (Massively Parallel Hits)
When performing tens of thousands of rays (Radar, GI, or Volumetrics), CPU-bound queries bottleneck. Use the `RenderingDevice` API to execute GLSL compute shaders. Note: Since the physics BVH is CPU-bound, world geometry must be serialized into a GPU storage buffer to perform ray-triangle intersections in GLSL.

```gdscript
class_name ComputeRaycaster extends Node
## Orchestrates massively parallel raycasts using the RenderingDevice API.

var _rd: RenderingDevice
var _shader: RID
var _pipeline: RID

func _ready() -> void:
    _rd = RenderingServer.get_rendering_device()
    var shader_file: RDShaderFile = load("res://compute_raycast.glsl")
    var spirv: RDShaderSPIRV = shader_file.get_spirv()
    _shader = _rd.shader_create_from_spirv(spirv)
    _pipeline = _rd.compute_pipeline_create(_shader)

func dispatch_rays(data_bytes: PackedByteArray) -> PackedByteArray:
    var buffer_rid: RID = _rd.storage_buffer_create(data_bytes.size(), data_bytes)
    var uniform := RDUniform.new()
    uniform.uniform_type = RenderingDevice.UNIFORM_TYPE_STORAGE_BUFFER
    uniform.binding = 0
    uniform.add_id(buffer_rid)
    
    var uniform_set: RID = _rd.uniform_set_create([uniform], _shader, 0)
    var compute_list: int = _rd.compute_list_begin()
    _rd.compute_list_bind_compute_pipeline(compute_list, _pipeline)
    _rd.compute_list_bind_uniform_set(compute_list, uniform_set, 0)
    _rd.compute_list_dispatch(compute_list, 1, 1, 1) 
    _rd.compute_list_end()
    _rd.submit()
    _rd.sync()
    
    var output: PackedByteArray = _rd.buffer_get_data(buffer_rid)
    _rd.free_rid(buffer_rid)
    return output
```

## Reference
- [Godot Docs: Raycasting](https://docs.godotengine.org/en/stable/tutorials/physics/ray-casting.html)
- [Godot Docs: Compute Shaders](https://docs.godotengine.org/en/stable/tutorials/shaders/compute_shaders.html)


### Related
- `godot-2d-physics`, `godot-physics-3d`
- Master Skill: [godot-master](../godot-master/SKILL.md)
