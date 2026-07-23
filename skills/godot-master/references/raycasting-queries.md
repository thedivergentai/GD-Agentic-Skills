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

> **MANDATORY** for common paths — read before implementing (do not improvise query APIs from memory):
> - [direct_space_state_raycast.gd](../scripts/raycasting_queries_direct_space_state_raycast.gd) — high-frequency `intersect_ray` without RayCast nodes.
> - [query_exclusion_optimization.gd](../scripts/raycasting_queries_query_exclusion_optimization.gd) — RID exclude lists so casters never self-hit.
> - [shapecast_ground_detection.gd](../scripts/raycasting_queries_shapecast_ground_detection.gd) — footing / volume casts when thin rays tunnel or miss.
>
> **Do NOT Load** every script below for one task. Open only the row that matches the decision table.

### [direct_space_state_raycast.gd](../scripts/raycasting_queries_direct_space_state_raycast.gd)
Expert usage of `PhysicsDirectSpaceState2D/3D` for bypassing node-based overhead in high-frequency queries.

### [shapecast_ground_detection.gd](../scripts/raycasting_queries_shapecast_ground_detection.gd)
Reliable ground/footing detection using volume-based `ShapeCast` instead of thin rays.

### [multiple_hit_piercing_ray.gd](../scripts/raycasting_queries_multiple_hit_piercing_ray.gd)
Implementing piercing projectiles that detect and return multiple hits in a single line.

### [field_of_view_scanner.gd](../scripts/raycasting_queries_field_of_view_scanner.gd)
AI sensor logic using a fan of raycasts to detect targets within a FOV cone.

### [raycast_reflection_logic.gd](../scripts/raycasting_queries_raycast_reflection_logic.gd)
Calculating bounces for lasers or bullets using collision normal reflection.

### [point_in_shape_query.gd](../scripts/raycasting_queries_point_in_shape_query.gd)
Checking for overlapping physics bodies at a single point (Explosion epicenters).

### [rest_info_3d_stuck_fix.gd](../scripts/raycasting_queries_rest_info_3d_stuck_fix.gd)
Using `get_rest_info` to detect stuck objects and resolve overlaps immediately.

### [mouse_pick_3d_query.gd](../scripts/raycasting_queries_mouse_pick_3d_query.gd)
Converting 2D screen coordinates to 3D world rays for point-and-click interaction.

### [water_buoyancy_surface_calc.gd](../scripts/raycasting_queries_water_buoyancy_surface_calc.gd)
Finding water surface height for buoyancy systems using high-to-low raycasting.

### [query_exclusion_optimization.gd](../scripts/raycasting_queries_query_exclusion_optimization.gd)
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

## Query-Type Decision Table

Pick the cheapest API that answers the question. Always pair rays/shapes with RID exclude + masks ([query_exclusion_optimization.gd](../scripts/raycasting_queries_query_exclusion_optimization.gd)).

| Need | Prefer | Cost | When | Script |
|------|--------|------|------|--------|
| Persistent sensor in the scene (ledge, aim assist debug) | `RayCast2D`/`RayCast3D` node | Low–med | Few casts; OK waiting one physics frame (or `force_raycast_update()`) | Scene node + NEVER rules |
| Hitscan / LOS / one-shot mid-frame ray | `PhysicsDirectSpaceState*.intersect_ray` | Low | High frequency, no permanent node | **MANDATORY** [direct_space_state_raycast.gd](../scripts/raycasting_queries_direct_space_state_raycast.gd) |
| Footing, thick walls, melee volume | `ShapeCast*` / `intersect_shape` | Med–high | Thin ray tunnels or misses volume | **MANDATORY** [shapecast_ground_detection.gd](../scripts/raycasting_queries_shapecast_ground_detection.gd) |
| Explosion / occupancy at a point | `intersect_point` | Low–med | Epicenter overlap list | [point_in_shape_query.gd](../scripts/raycasting_queries_point_in_shape_query.gd) |
| Stuck / penetration resolve | `get_rest_info` | Med | Overlap recovery | [rest_info_3d_stuck_fix.gd](../scripts/raycasting_queries_rest_info_3d_stuck_fix.gd) |
| Pierce / multi-hit along a line | Repeated `intersect_ray` + exclude RIDs | Med | Projectiles that keep going | [multiple_hit_piercing_ray.gd](../scripts/raycasting_queries_multiple_hit_piercing_ray.gd) |
| Screen → world click | Camera project + `intersect_ray` | Low | Picking | [mouse_pick_3d_query.gd](../scripts/raycasting_queries_mouse_pick_3d_query.gd) |

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

### 3. Compute Path — Demoted (not a physics-query substitute)
GPU compute raycasts are **out of scope** for this skill’s production recipes. Godot’s physics BVH lives on the CPU; there is **no** shipped `compute_raycast` shader or BVH→GPU serializer here.

- **Default**: stay on DirectSpaceState / ShapeCast / masks / RID exclude (table above).
- **If you truly need 10k+ custom rays**: treat it as a rendering research spike — you must own triangle buffers, acceleration structure rebuilds, and sync stalls yourself. Do **not** assume `RenderingDevice` replaces `intersect_ray` for gameplay hit detection.
- Escalate extreme CPU query counts to `godot-performance-optimization` (batching, C++/GDExtension) before inventing a compute pipeline.

## Reference

> Progressive disclosure: open Official Documentation links only when researching a specific API;
> load Related Skills when routing work to a peer domain — do not preload the whole lattice.

### Official Documentation
- [Ray-casting](https://docs.godotengine.org/en/stable/tutorials/physics/ray-casting.html) — Node `RayCast*` vs `PhysicsDirectSpaceState*` queries, result dictionaries, and `exclude` to avoid self-hits.
- [Physics introduction](https://docs.godotengine.org/en/stable/tutorials/physics/physics_introduction.html) — Collision layers/masks that filter every ray, shape, and point query at the physics server.
- [Collision shapes (3D)](https://docs.godotengine.org/en/stable/tutorials/physics/collision_shapes_3d.html) — Why queries need primitive/convex shapes instead of visual meshes for reliable, cheap intersections.
- [PhysicsDirectSpaceState3D](https://docs.godotengine.org/en/stable/classes/class_physicsdirectspacestate3d.html) — `intersect_ray` / `intersect_shape` / `intersect_point` / `get_rest_info` / `cast_motion` contracts for mid-frame space queries.
- [PhysicsDirectSpaceState2D](https://docs.godotengine.org/en/stable/classes/class_physicsdirectspacestate2d.html) — 2D twin of direct space queries for LOS, hitscan, and point epicenters without permanent cast nodes.
- [PhysicsRayQueryParameters3D](https://docs.godotengine.org/en/stable/classes/class_physicsrayqueryparameters3d.html) — Mask, exclude RIDs, `hit_from_inside`, and collide-with flags for reusable ray parameter objects.
- [PhysicsShapeQueryParameters3D](https://docs.godotengine.org/en/stable/classes/class_physicsshapequeryparameters3d.html) — Shape RID + transform setup for volume casts, rest info, and stuck-overlap resolution.
- [PhysicsPointQueryParameters3D](https://docs.godotengine.org/en/stable/classes/class_physicspointqueryparameters3d.html) — Point-in-shape overlap lists for explosion epicenters and occupancy checks.
- [RayCast3D](https://docs.godotengine.org/en/stable/classes/class_raycast3d.html) — Scene-tree cast nodes, collision exceptions, and when `force_raycast_update()` is required after moving.
- [ShapeCast3D](https://docs.godotengine.org/en/stable/classes/class_shapecast3d.html) — Volume casts and `force_shapecast_update()` for footing/melee detection that thin rays miss.
- [Camera3D](https://docs.godotengine.org/en/stable/classes/class_camera3d.html) — `project_ray_origin` / `project_ray_normal` for screen-to-world picking rays from the active camera.
- [Mouse and input coordinates](https://docs.godotengine.org/en/stable/tutorials/inputs/mouse_and_input_coordinates.html) — Viewport mouse position vs canvas/world space before building a pick ray.

### Related Skills

#### Prerequisites
- [godot-project-foundations](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md) — Named physics layers and tick settings must exist before query masks and water/ground layer bits stay coherent.
- [godot-gdscript-mastery](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md) — Typed query parameters, RID arrays, and `_physics_process`-only space access are language-level contracts this skill depends on.
- [godot-2d-physics](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-2d-physics/SKILL.md) — 2D body/area layer matrices and when to prefer `RayCast2D` nodes vs direct space state for sensors.

#### Complements
- [godot-physics-3d](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-physics-3d/SKILL.md) — 3D body types, CCD, and collision setup that determine what your rays and shape casts can actually hit.
- [godot-characterbody-2d](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-characterbody-2d/SKILL.md) — Grounding, ledges, and coyote-time feel often consume ShapeCast/ray footing results from this domain.
- [godot-input-handling](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-input-handling/SKILL.md) — Physics-step click/aim sampling couples with mouse-pick rays and hitscan timing.
- [godot-navigation-pathfinding](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-navigation-pathfinding/SKILL.md) — Physics LOS vs NavMesh path-straightness checks; keep obstacle carve and collision worlds consistent.
- [godot-ai-navigation](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ai-navigation/SKILL.md) — FOV fans and vision sensors feed AI perception stacks that still need correct query masks/exclusions.
- [godot-performance-optimization](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md) — Budgeting hundreds of rays, reusing query params, and knowing when node casts become SceneTree overhead.
- [godot-debugging-profiling](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md) — Visualizing cast lines/shapes and diagnosing missed hits from mask, exclude, or update-timing mistakes.

#### Downstream / consumers
- [godot-combat-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-combat-system/SKILL.md) — Hitscan, piercing rays, and melee volumes resolve damage from query results produced here.
- [godot-genre-shooter](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-shooter/SKILL.md) — Hitscan weapons, bullet pierce, and aim assist consume exclusion/mask recipes and multi-hit pierce loops.
- [godot-monte-carlo-balancer](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md) — View distance, FOV ray counts, pierce max-hits, and query tick rate change fairness and difficulty; simulate those knobs instead of guessing.

#### Master
- [godot-master](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-master/SKILL.md) — Library router and mirrored entry point for discovering raycasting/query patterns alongside sibling domains.
