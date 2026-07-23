# Query Elite Patterns (load on demand)

> **MANDATORY** for NavMesh LOS, surface metadata hits, and advanced picking beyond the decision table in SKILL.md.

## 3D mouse picking (baseline)

```gdscript
func screen_point_to_ray() -> Object:
    var space_state := get_world_3d().direct_space_state
    var mouse_pos := get_viewport().get_mouse_position()
    var origin := project_ray_origin(mouse_pos)
    var end := origin + project_ray_normal(mouse_pos) * 2000.0
    var query := PhysicsRayQueryParameters3D.create(origin, end)
    query.exclude = [get_rid()]
    var result := space_state.intersect_ray(query)
    return result.collider if result else null
```

See [mouse_pick_3d_query.gd](../scripts/mouse_pick_3d_query.gd).

## NavMesh line-of-sight

Physics rays hit collision shapes; carved NavMesh holes need path-based LOS.

```gdscript
class_name NavMeshRayValidator extends Node

@export var agent: NavigationAgent3D

func has_navmesh_line_of_sight(target_position: Vector3) -> bool:
    if not is_instance_valid(agent):
        return false
    var map: RID = agent.get_navigation_map()
    var path: PackedVector3Array = NavigationServer3D.map_get_path(
        map, agent.global_position, target_position, true, agent.navigation_layers
    )
    return path.size() == 2  # direct line = exactly start + end
```

> **WHY:** `path.size() == 2` means funnel found no intermediate corners — unobstructed on the nav mesh.

## Surface metadata (decoupled hit response)

```gdscript
if collider.has_meta(&"surface_type"):
    var surface: StringName = collider.get_meta(&"surface_type")
```

Prefer metadata over `is Enemy` / group name checks for footstep VFX, bullet decals, etc.

## Compute shader raycasts — out of scope

Godot physics BVH is CPU-bound. GPU compute ray pipelines require owning triangle buffers and sync stalls — **not** a drop-in for `intersect_ray`. Escalate to [godot-performance-optimization](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md) before building custom RD pipelines.

## Piercing / multi-hit

Repeated `intersect_ray` with growing `exclude` RID list — [multiple_hit_piercing_ray.gd](../scripts/multiple_hit_piercing_ray.gd).

## Tunneling fast projectiles

Thin rays miss between frames — use `cast_motion` or ShapeCast stepping — [shapecast_ground_detection.gd](../scripts/shapecast_ground_detection.gd).

## Query timing contract

**NEVER** read `direct_space_state` in `_process()` — physics step only (`_physics_process`).

## RayCast node update lag

After teleporting a `RayCast3D`, call `force_raycast_update()` before reading `is_colliding()`.
