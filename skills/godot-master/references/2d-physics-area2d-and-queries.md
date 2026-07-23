# Area2D patterns and manual queries

## Multi-shape duplicate `body_entered`

> **CAUTION:** If an `Area2D` has multiple `CollisionShape2D` children, `body_entered` fires **once per shape** — pickups trigger 3×, damage applies 3×.

```gdscript
# BAD — no dedupe
func _on_body_entered(body: Node2D) -> void:
    body.take_damage(10)  # Fires per shape!

# GOOD — track unique bodies (or use collision_debouncer.gd)
var _active_bodies := {}

func _on_body_entered(body: Node2D) -> void:
    if body in _active_bodies:
        return
    _active_bodies[body] = true
    body.take_damage(10)

func _on_body_exited(body: Node2D) -> void:
    _active_bodies.erase(body)
```

## Damage-over-time zones

Per-body tick timers in `_process` — do not poll `get_overlapping_bodies()` every frame. See lava pattern in baseline; prefer signals + timer dict.

## RayCast2D

```gdscript
func can_see_target(target: Node2D) -> bool:
    var direction := global_position.direction_to(target.global_position)
    vision_ray.target_position = direction * 300
    vision_ray.force_raycast_update()  # REQUIRED after mid-frame target change
    return vision_ray.is_colliding() and vision_ray.get_collider() == target
```

Ledge check: front ray hits floor, back ray does not → `at_ledge()`.

Exclusions: `add_exception(self)` on weapon/child colliders.

## PhysicsDirectSpaceState2D

| Task | API |
|------|-----|
| Click pick | `PhysicsPointQueryParameters2D` + `intersect_point` |
| AOE | `PhysicsShapeQueryParameters2D` + `intersect_shape` |
| Hitscan | `PhysicsRayQueryParameters2D.create(from, to)` + `exclude` |

Canonical samples: [physics_queries.gd](../scripts/2d_physics_physics_queries.gd), [raycast_vision_stack.gd](../scripts/2d_physics_raycast_vision_stack.gd), [shapecast_aoe.gd](../scripts/2d_physics_shapecast_aoe.gd).

## Performance

- Disable optional raycasts when idle; enable → `force_raycast_update()` → read → disable.
- 1000+ bullets: **MANDATORY** [physics_server_swarm.gd](../scripts/2d_physics_physics_server_swarm.gd) — free RIDs manually (not GC'd).
- High-refresh jitter: [jitter_interpolation_fix.gd](../scripts/2d_physics_jitter_interpolation_fix.gd).

## Elite: compound RID bodies

Multiple shapes on one `PhysicsServer2D` body RID — [compound_body_sync.gd](../scripts/2d_physics_compound_body_sync.gd).

## Debug draw

Contact normals/points from `KinematicCollision2D` — [collision_visual_debugger.gd](../scripts/2d_physics_collision_visual_debugger.gd).
