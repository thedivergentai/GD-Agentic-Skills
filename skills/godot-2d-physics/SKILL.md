---
name: godot-2d-physics
description: "Expert patterns for Godot 2D physics including collision layers/masks, Area2D triggers, raycasting, and PhysicsDirectSpaceState2D queries. Use when implementing collision detection, trigger zones, line-of-sight systems, or manual physics queries. Trigger keywords: CollisionShape2D, CollisionPolygon2D, collision_layer, collision_mask, set_collision_layer_value, set_collision_mask_value, Area2D, body_entered, body_exited, RayCast2D, force_raycast_update, PhysicsPointQueryParameters2D, PhysicsShapeQueryParameters2D, direct_space_state, move_and_collide, move_and_slide."
---

# 2D Physics

Expert guidance for collision detection, triggers, and raycasting in Godot 2D.

## NEVER Do

- **NEVER scale `CollisionShape2D` nodes** — Use the shape handles in the editor, NOT the Node2D scale property. Scaling causes unpredictable physics behavior and incorrect collision normals [12].
- **NEVER confuse `collision_layer` with `collision_mask`** — Layer = "What AM I?", Mask = "What do I DETECT?". Setting both to the same value is usually wrong [13].
- **NEVER multiply velocity by delta when using `move_and_slide()`** — `move_and_slide()` automatically includes timestep. Only multiply gravity/acceleration by delta [14].
- **NEVER forget `force_raycast_update()` for manual mid-frame raycasts** — Raycasts update once per physics frame. If you change target_position, you MUST force an update [15].
- **NEVER use `get_overlapping_bodies()` every frame** — It is expensive. Cache results with `body_entered`/`body_exited` signals instead [16].
- **NEVER modify `RigidBody2D` state directly in `_process`** — Use `_integrate_forces()` for safe, synchronized access to `PhysicsDirectBodyState2D` [17, 411].
- **NEVER move `PhysicsBody2D` nodes in `_process()`** — Use `_physics_process()`. Moving bodies outside the physics step causes stutter and unreliable collision detection.
- **NEVER use `RigidBody2D` for 1000+ simple entities** — Use `PhysicsServer2D` to bypass node overhead for massive performance gains (Swarms/Bullets) [18, 397].
- **NEVER use `Area2D` for high-frequency blocking (Bullets)** — Area signals can be delayed. Use `move_and_collide()` or `ShapeCast2D` for frame-perfect results [19].
- **NEVER ignore 'Physics Jitter' on high-refresh monitors** — Enable Physics Interpolation to prevent micro-stutter in motion [21, 400].
- **NEVER scale collision shapes directly at runtime** — It causes major instability. Resize the shape resource (size/radius) instead.
- **NEVER use `set_deferred` for immediate physics transform logic** — It happens at the end of the frame. Use `force_raycast_update()` or `PhysicsServer2D` instead.
- **NEVER leave Continuous CD (CCD) enabled for slow objects** — It adds significant CPU overhead. Reserve it for high-speed projectiles to prevent tunneling.
- **NEVER use a single collision layer for all tiles/entities** — Separate layers (Ground, Walls, Enemies) to allow selective filtering via masks.
- **NEVER forget to free `PhysicsServer2D` RIDs manually** — They are not garbage collected and will leak memory permanently.

---

## Godot 4.7: 2D Physics

- `body_set_shape_as_one_way_collision` adds **direction** parameter — set relative to shape orientation for one-way platforms.
- `CollisionShape2D` supports one-way collision **direction relative to the shape** (not just global up).

## Available Scripts

> **MANDATORY**: Read the script matching your workflow branch before coding. Query/Area cookbook samples live in scripts — not in this body.

### Workflow router (MANDATORY / Do NOT Load)
| Branch | Load | Do NOT Load |
|--------|------|-------------|
| Layer/mask matrix setup | `collision_bitmask_helper.gd` or `collision_setup.gd`; matrix policy → `collision_layer_matrix_manager.gd` | Swarm / CCD scripts |
| LOS / vision cones | `raycast_vision_stack.gd` (+ `physics_direct_query.gd` for nodeless rays) | `shapecast_aoe*.gd`, `physics_server_swarm.gd` |
| AOE / melee volume | **Prefer** `shapecast_aoe.gd` (faction mask); ground/volume sensing → `shapecast_aoe_detection.gd` | Area2D spam + lava DoT tutorials; do not load both shapecast scripts for the same feature |
| Hitscan / point pick / one-shot shape | `physics_queries.gd` (canonical). Specialists: `physics_direct_space_query.gd` (LOS bool), `raycast_hit_prediction.gd` | Re-load all three query helpers at once |
| Bullet hell / 1000+ bodies | **MANDATORY** `physics_server_swarm.gd` (+ `physics_server_direct_body.gd` for RID shapes) | Per-bullet Area2D / RigidBody2D nodes |
| High-speed tunneling | `continuous_collision_detection.gd` + `substepping_logic.gd` | CCD on slow props |
| RigidBody safe mutate | `safe_rigidbody_state.gd` (`_integrate_forces`) | Direct transform writes in `_process` |
| Custom CharacterBody forces | `custom_physics_2d.gd` | `custom_physics.gd` (that file is RigidBody `_integrate_forces`) |
| Gravity zones | `custom_gravity_area.gd` (Area override) or `custom_gravity_override.gd` (character weight/zones) | Both unless you need Area + character paths |
| Overlap signal spam | `collision_debouncer.gd` | Polling `get_overlapping_bodies` every frame |
| High-refresh jitter | **Prefer** `jitter_interpolation_fix.gd` | `physics_interpolation_smoothing.gd` (legacy/manual; only if built-in interpolation is unavailable) |
| Precision bounce / slide | `move_and_collide_precision.gd` | — |
| Batch static movers | `performance_batch_mover.gd` | — |
| Query result cache | `physics_query_cache.gd` | Duplicate space queries same frame |

### Canonical vs overlap (dedupe guide)
- **ShapeCast AOE**: load `shapecast_aoe.gd` for combat AOE; `shapecast_aoe_detection.gd` only for grounded/volume checks — never both for one feature.
- **Space queries**: start with `physics_queries.gd`; add `physics_direct_query.gd` / `physics_direct_space_query.gd` only if that specialist matches.
- **Custom physics**: CharacterBody → `custom_physics_2d.gd`; RigidBody integrate → `custom_physics.gd`.
- **Interpolation**: `jitter_interpolation_fix.gd` wins over `physics_interpolation_smoothing.gd`.

### Script index
- [collision_setup.gd](scripts/collision_setup.gd) / [collision_bitmask_helper.gd](scripts/collision_bitmask_helper.gd) / [collision_layer_matrix_manager.gd](scripts/collision_layer_matrix_manager.gd)
- [physics_queries.gd](scripts/physics_queries.gd) / [physics_direct_query.gd](scripts/physics_direct_query.gd) / [physics_direct_space_query.gd](scripts/physics_direct_space_query.gd) / [physics_query_cache.gd](scripts/physics_query_cache.gd)
- [raycast_vision_stack.gd](scripts/raycast_vision_stack.gd) / [raycast_hit_prediction.gd](scripts/raycast_hit_prediction.gd)
- [shapecast_aoe.gd](scripts/shapecast_aoe.gd) / [shapecast_aoe_detection.gd](scripts/shapecast_aoe_detection.gd)
- [physics_server_swarm.gd](scripts/physics_server_swarm.gd) / [physics_server_direct_body.gd](scripts/physics_server_direct_body.gd)
- [continuous_collision_detection.gd](scripts/continuous_collision_detection.gd) / [substepping_logic.gd](scripts/substepping_logic.gd)
- [safe_rigidbody_state.gd](scripts/safe_rigidbody_state.gd) / [custom_physics.gd](scripts/custom_physics.gd) / [custom_physics_2d.gd](scripts/custom_physics_2d.gd)
- [custom_gravity_area.gd](scripts/custom_gravity_area.gd) / [custom_gravity_override.gd](scripts/custom_gravity_override.gd)
- [collision_debouncer.gd](scripts/collision_debouncer.gd) / [jitter_interpolation_fix.gd](scripts/jitter_interpolation_fix.gd)
- [move_and_collide_precision.gd](scripts/move_and_collide_precision.gd) / [performance_batch_mover.gd](scripts/performance_batch_mover.gd)
- [physics_interpolation_smoothing.gd](scripts/physics_interpolation_smoothing.gd) — legacy; prefer jitter fix script

---

## Decision Tree: Collision Detection Methods

| Use Case | Method | Why / script |
|----------|--------|--------------|
| Continuous trigger zone | Area2D + signals | Memory of occupants; debounce with `collision_debouncer.gd` |
| One-time pickup | Area2D + `queue_free` on enter | Simple cleanup |
| Line-of-sight | RayCast2D / direct ray | `raycast_vision_stack.gd` or `physics_direct_query.gd` |
| Click-to-select | `PhysicsPointQueryParameters2D` | `physics_queries.gd` |
| AOE spell / melee volume | ShapeCast2D / shape query | `shapecast_aoe.gd` (not Area signal lag) |
| Instant-hit weapon | `PhysicsRayQueryParameters2D` | `physics_queries.gd` / `raycast_hit_prediction.gd` |
| Platformer ground / ledge | Ray or ShapeCast down | CharacterBody skill + `shapecast_aoe_detection.gd` |
| 1000+ projectiles | PhysicsServer2D RIDs | **MANDATORY** `physics_server_swarm.gd` |

---

## Mental model (keep short)

- **Layer** = who I am; **Mask** = who I detect. Helpers in `collision_bitmask_helper.gd` — do not hardcode undocumented bitmasks.
- Mid-frame ray/shape changes require `force_raycast_update()` / `force_shapecast_update()`.
- `_ready` physics queries are false until after a physics frame (`await get_tree().physics_frame`).
- Free PhysicsServer RIDs yourself — they are not GC'd.

## Reference

> Progressive disclosure: open Official Documentation links only when researching a specific API;
> load Related Skills when routing work to a peer domain — do not preload the whole lattice.

### Official Documentation
- [Physics introduction](https://docs.godotengine.org/en/stable/tutorials/physics/physics_introduction.html) — Collision layers vs masks, body types, and the mental model every 2D setup depends on.
- [Collision shapes (2D)](https://docs.godotengine.org/en/stable/tutorials/physics/collision_shapes_2d.html) — Correct shape sizing and why scaling `CollisionShape2D` nodes breaks normals and contacts.
- [Using CharacterBody2D](https://docs.godotengine.org/en/stable/tutorials/physics/using_character_body_2d.html) — `move_and_slide` / `move_and_collide`, floor detection, and kinematic movement contracts.
- [Using Area2D](https://docs.godotengine.org/en/stable/tutorials/physics/using_area_2d.html) — Trigger monitoring, overlap signals, and space/gravity overrides for zones.
- [Ray-casting](https://docs.godotengine.org/en/stable/tutorials/physics/ray-casting.html) — `RayCast2D` vs `PhysicsDirectSpaceState2D` rays, exclusions, and mid-frame `force_raycast_update`.
- [RigidBody](https://docs.godotengine.org/en/stable/tutorials/physics/rigid_body.html) — Safe rigid-body control via `_integrate_forces` / `PhysicsDirectBodyState2D` instead of fighting the solver in `_process`.
- [Troubleshooting physics issues](https://docs.godotengine.org/en/stable/tutorials/physics/troubleshooting_physics_issues.html) — Tunneling, jitter, one-way platforms, and common layer/mask misconfigurations.
- [Physics interpolation introduction](https://docs.godotengine.org/en/stable/tutorials/physics/interpolation/physics_interpolation_introduction.html) — Why fixed physics ticks stutter on high-refresh displays and when interpolation fixes it.
- [PhysicsServer2D](https://docs.godotengine.org/en/stable/classes/class_physicsserver2d.html) — RID-based body/shape APIs for swarm-scale 2D physics without SceneTree overhead.
- [PhysicsDirectSpaceState2D](https://docs.godotengine.org/en/stable/classes/class_physicsdirectspacestate2d.html) — Point, ray, and shape queries for LOS, AOE, and click-picking without permanent query nodes.
- [ShapeCast2D](https://docs.godotengine.org/en/stable/classes/class_shapecast2d.html) — Volume casts for frame-perfect melee/AOE detection when `Area2D` signal lag is unacceptable.

### Related Skills

#### Prerequisites
- [godot-project-foundations](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md) — Project Settings layer names, physics ticks, and default gravity must be set before layer/mask matrices stay sane.
- [godot-gdscript-mastery](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md) — Bitmask enums, typed dictionaries for overlap sets, and `_physics_process` discipline underpin every pattern here.
- [godot-signal-architecture](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md) — `body_entered` / `body_exited` wiring and debounce patterns need clean signal ownership to avoid spam.

#### Complements
- [godot-characterbody-2d](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-characterbody-2d/SKILL.md) — Coyote time, jump buffers, and one-way platforms sit on top of the collision contracts this skill defines.
- [godot-raycasting-queries](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-raycasting-queries/SKILL.md) — Deeper query parameter recipes (exclusions, masks, shape casts) when vision/hitscan systems grow beyond basics.
- [godot-tilemap-mastery](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-tilemap-mastery/SKILL.md) — Tile physics layers and one-way tile collisions must match the same layer matrix used by bodies and areas.
- [godot-input-handling](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-input-handling/SKILL.md) — Physics-step input sampling and vsync/latency choices couple tightly with `move_and_slide` feel.
- [godot-physics-3d](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-physics-3d/SKILL.md) — Parallel 3D body/query concepts when porting or sharing layer policy across dimensions.
- [godot-performance-optimization](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md) — Profiling and batching guidance when `PhysicsServer2D` swarms or query caches become bottlenecks.
- [godot-debugging-profiling](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md) — Visible collision shapes, contact normals, and frame-time traps when diagnosing jitter or missed hits.

#### Downstream / consumers
- [godot-combat-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-combat-system/SKILL.md) — Hitboxes/hurtboxes are `Area2D` + layer/mask products; damage timing inherits overlap and CCD choices.
- [godot-genre-platformer](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-platformer/SKILL.md) — Platformer feel (floors, ledges, one-ways) consumes CharacterBody2D + collision setup from this domain.
- [godot-navigation-pathfinding](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-navigation-pathfinding/SKILL.md) — Agents still need physics layers for blockers and LOS; keep nav meshes and collision worlds consistent.
- [godot-monte-carlo-balancer](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md) — Jump windows, projectile speed/CCD, gravity, and hitbox size directly change win-rate and difficulty curves; simulate those physics knobs instead of guessing.

#### Master
- [godot-master](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-master/SKILL.md) — Library router and mirrored entry point for discovering 2D physics alongside sibling domains.
