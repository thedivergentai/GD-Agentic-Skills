---
name: godot-physics-3d
description: "Expert patterns for Godot 3D physics (Jolt/PhysX), including Ragdolls, PhysicalBones, Joint3D constraints, RayCasting optimizations, and collision layers. Use for rigid body simulations, character physics, or complex interactions. Trigger keywords: RigidBody3D, PhysicalBone3D, Jolt, Ragdoll, Skeleton3D, Joint3D, PinJoint3D, HingeJoint3D, Generic6DOFJoint3D, RayCast3D, PhysicsDirectSpaceState3D."
---
# 3D Physics (Jolt/Native)

High-performance 3D simulation: body choice, CCD, stairs, vehicles, ragdolls, SoftBody — routed through scripts.

## NEVER Do

- **NEVER move `PhysicsBody3D` nodes in `_process()`** — Use `_physics_process()`. Moving bodies outside the physics step causes visual jitter and unreliable collision detection [12, 13].
- **NEVER scale collision shapes directly** — Scaling physics shapes causes instability, inaccurate normals, and jitter. Use the `shape` properties (height, radius, size) instead.
- **NEVER modify `RigidBody3D` transforms directly** — This ignores the physics solver. Use `apply_impulse()`, `apply_torque()`, or the `_integrate_forces()` callback for safe manipulation [17].
- **NEVER use `RigidBody3D` for platformer player controllers** — RigidBody is for objects driven by physics. For refined movement, use `CharacterBody3D` with `move_and_slide()` [move_and_slide].
- **NEVER leave Continuous CD (CCD) enabled for static meshes** — It adds heavy CPU cost. Reserve it for high-speed small objects (bullets) to prevent them from passing through walls.
- **NEVER use `PhysicsServer3D` RIDs without manual cleanup** — RIDs are not garbage collected. If you create bodies via the server, you MUST call `free_rid()` when done to avoid memory leaks.
- **NEVER use `RayCast3D` for precise ground detection on stairs** — A single ray is too thin. Use `ShapeCast3D` with a cylinder or sphere shape to detect walkable steps reliably [Stair Logic].
- **NEVER rely on `VehicleBody3D` for non-racing arcade vehicles** — It's a complex sim. For arcade hovercraft or simple cars, a custom `CharacterBody3D` with Raycasts is often easier to tune.
- **NEVER forget to set `collision_layer` and `collision_mask` properly** — If everything is on layer 1, performance will tank from redundant checks. Categorize your world.
- **NEVER use `Area3D` for high-frequency blocking** — Areas are for detection. For walls/barriers, use `StaticBody3D` to ensure immediate, robust containment.

---

## Godot 4.7: Jolt Physics Behavior

- **WorldBoundaryShape3D** (Jolt): `plane.d` sign convention flipped vs 4.6 — flip sign to match prior behavior.
- **SoftBody3D** (Jolt): mass defaults to 1 kg total (not per-point); retune `linear_stiffness` and `damping_coefficient`.
- **Area3D** now reports overlaps with **SoftBody3D** — adjust layers/masks to avoid unwanted overlap signals.

## Body / Symptom Decision Tree

> **MANDATORY** — load the script for the chosen row before writing movement or sim code.
>
> **Do NOT Load** every physics script for one controller.

| Need / symptom | Body / API | Script |
|----------------|------------|--------|
| Player locomotion, stairs, slopes | `CharacterBody3D` | **MANDATORY** [kinematic_3d_stairs_logic.gd](scripts/kinematic_3d_stairs_logic.gd) + [shapecast_3d_ground_check.gd](scripts/shapecast_3d_ground_check.gd) |
| Debris, props, impulse-driven objects | `RigidBody3D` | NEVER + impulses; layers via [physics_layers_3d_config.gd](scripts/physics_layers_3d_config.gd) |
| Racing / wheeled sim | `VehicleBody3D` | **MANDATORY** [vehicle_simulation_tuning.gd](scripts/vehicle_simulation_tuning.gd) |
| Arcade hover / simple cars | Custom `CharacterBody3D` + rays | Prefer stairs/ray scripts; avoid full VehicleBody |
| Death / blend to physics pose | `PhysicalBone3D` / Skeleton | **MANDATORY** [ragdoll_manager.gd](scripts/ragdoll_manager.gd) |
| Cloaks, soft cloth, foliage soft | `SoftBody3D` | **MANDATORY** [soft_body_3d_interaction.gd](scripts/soft_body_3d_interaction.gd) |
| Tunneling bullets | CCD / server bullets | **MANDATORY** [physics_ccd_3d_projectile.gd](scripts/physics_ccd_3d_projectile.gd) or [physics_server_3d_bullets.gd](scripts/physics_server_3d_bullets.gd) |
| Joint snap / destructibles | `Joint3D` stress | [joint_3d_breakage_logic.gd](scripts/joint_3d_breakage_logic.gd) |
| Gravity wells / zero-G | Area priority | [custom_gravity_well_3d.gd](scripts/custom_gravity_well_3d.gd) |
| LOS / AI vision | Direct space state | [ray_query_3d_vision.gd](scripts/ray_query_3d_vision.gd) |
| Debug hit normals | visualizer | [raycast_visualizer.gd](scripts/raycast_visualizer.gd) |

## 3D Layer Pitfalls (not a 2D primer)

- **Layer** = what the object *is*; **mask** = what it *hits*. Name bits in [physics_layers_3d_config.gd](scripts/physics_layers_3d_config.gd).
- SoftBody overlaps Area3D in 4.7 — retune masks or you get surprise signals.
- WorldBoundaryShape3D `plane.d` sign flipped under Jolt vs 4.6 — flip when migrating.
- Do not dump a same-as-2D layers tutorial here; Official Docs cover the shared mental model.

## Available Scripts

### [kinematic_3d_stairs_logic.gd](scripts/kinematic_3d_stairs_logic.gd)
Procedural stair-step + snap for CharacterBody3D.

### [shapecast_3d_ground_check.gd](scripts/shapecast_3d_ground_check.gd)
Volume ground/stair detection (rays tunnel).

### [ragdoll_manager.gd](scripts/ragdoll_manager.gd)
Animation → PhysicalBone simulation transition, impulses, cleanup.

### [vehicle_simulation_tuning.gd](scripts/vehicle_simulation_tuning.gd)
VehicleBody3D / VehicleWheel3D arcade vs sim knobs.

### [soft_body_3d_interaction.gd](scripts/soft_body_3d_interaction.gd)
SoftBody3D flags and attachments after 4.7 mass defaults.

### [physics_ccd_3d_projectile.gd](scripts/physics_ccd_3d_projectile.gd)
CCD / sub-step anti-tunneling for small fast bodies.

### [physics_server_3d_bullets.gd](scripts/physics_server_3d_bullets.gd)
RID bullets at scale with mandatory `free_rid()`.

### [physics_layers_3d_config.gd](scripts/physics_layers_3d_config.gd)
Named 3D collision matrix architecture.

### [custom_gravity_well_3d.gd](scripts/custom_gravity_well_3d.gd)
Planet / zero-G Area3D gravity priority.

### [joint_3d_breakage_logic.gd](scripts/joint_3d_breakage_logic.gd)
Joint stress monitoring and procedural snaps.

### [ray_query_3d_vision.gd](scripts/ray_query_3d_vision.gd)
Low-level LOS / AI vision queries.

### [raycast_visualizer.gd](scripts/raycast_visualizer.gd)
In-game ray hit/normal debug draw.

## Expert Pointers (Jolt 4.7)

- Prefer `Generic6DOFJoint3D` over stacking specialized joints unless you need a specific node UX.
- SoftBody total mass default is 1 kg under Jolt — retune stiffness/damping after upgrade.
- Ragdoll/vehicle/soft samples live in scripts above — do not expand Create Physical Skeleton editor tutorials in this body.

## Reference

> Progressive disclosure: open Official Documentation links only when researching a specific API;
> load Related Skills when routing work to a peer domain — do not preload the whole lattice.

### Official Documentation
- [Physics introduction](https://docs.godotengine.org/en/stable/tutorials/physics/physics_introduction.html) — Layers vs masks, body types, and the shared 2D/3D collision mental model every 3D setup depends on.
- [Collision shapes (3D)](https://docs.godotengine.org/en/stable/tutorials/physics/collision_shapes_3d.html) — Primitive vs convex/concave shapes and why scaling `CollisionShape3D` breaks normals and contacts.
- [Using Jolt Physics](https://docs.godotengine.org/en/stable/tutorials/physics/using_jolt_physics.html) — Engine switch, joint-property gaps vs Godot Physics, and project-setting caveats for stable 3D sims.
- [Using RigidBody](https://docs.godotengine.org/en/stable/tutorials/physics/rigid_body.html) — Safe control via forces, impulses, and `_integrate_forces` instead of fighting the solver with per-frame transforms.
- [Ragdoll system](https://docs.godotengine.org/en/stable/tutorials/physics/ragdoll_system.html) — `PhysicalBoneSimulator3D` / `PhysicalBone3D` setup for death sims and animation↔physics handoff.
- [Using SoftBody3D](https://docs.godotengine.org/en/stable/tutorials/physics/soft_body.html) — Cloth/flag deformation, pinning, and why Jolt is preferred for soft-body robustness.
- [Ray-casting](https://docs.godotengine.org/en/stable/tutorials/physics/ray-casting.html) — `RayCast3D` vs `PhysicsDirectSpaceState3D` queries, exclusions, and space access during the physics tick.
- [Troubleshooting physics issues](https://docs.godotengine.org/en/stable/tutorials/physics/troubleshooting_physics_issues.html) — Tunneling, jitter, CCD misuse, and common layer/mask misconfigurations.
- [Physics interpolation introduction](https://docs.godotengine.org/en/stable/tutorials/physics/interpolation/physics_interpolation_introduction.html) — Why fixed physics ticks stutter on high-refresh displays and when interpolation smooths 3D motion.
- [PhysicsServer3D](https://docs.godotengine.org/en/stable/classes/class_physicsserver3d.html) — RID-based body/shape APIs for swarm-scale projectiles with mandatory `free_rid` cleanup.
- [PhysicsDirectSpaceState3D](https://docs.godotengine.org/en/stable/classes/class_physicsdirectspacestate3d.html) — Ray/shape/point queries for LOS, hover constraints, and custom suspensions without permanent query nodes.
- [ShapeCast3D](https://docs.godotengine.org/en/stable/classes/class_shapecast3d.html) — Volume casts for stair/ground detection when a thin `RayCast3D` misses ledges or uneven floors.

### Related Skills

#### Prerequisites
- [godot-project-foundations](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md) — 3D physics engine choice, tick rate, gravity, and named layer bits must be set before matrices and Jolt tuning stay sane.
- [godot-gdscript-mastery](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md) — Typed RIDs, bitmask enums, and `_physics_process` discipline underpin server-side and CharacterBody3D patterns here.
- [godot-signal-architecture](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md) — `body_entered` / contact-monitor wiring needs clean ownership so Area3D gravity wells and CCD hits do not spam.

#### Complements
- [godot-2d-physics](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-2d-physics/SKILL.md) — Parallel layer/mask and body-type contracts when sharing policy across dimensions or porting mechanics.
- [godot-raycasting-queries](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-raycasting-queries/SKILL.md) — Deeper query-parameter recipes (masks, exclusions, shape casts) when vision/hitscan systems outgrow the basics.
- [godot-3d-world-building](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-world-building/SKILL.md) — Static collision from GridMap/CSG/meshes must match the same 3D layer matrix used by characters and projectiles.
- [godot-animation-tree-mastery](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-animation-tree-mastery/SKILL.md) — AnimationTree poses and state machines feed ragdoll start/stop and influence blending on `PhysicalBoneSimulator3D`.
- [godot-performance-optimization](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md) — Profiling and pooling guidance when `PhysicsServer3D` swarms, soft bodies, or CCD counts become bottlenecks.
- [godot-debugging-profiling](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md) — Visible collision shapes, contact normals, and profiler traps when diagnosing jitter, tunneling, or missed stairs.

#### Downstream / consumers
- [godot-combat-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-combat-system/SKILL.md) — 3D hitboxes/hurtboxes and projectile CCD inherit layer/mask and space-query choices from this domain.
- [godot-genre-racing](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-racing/SKILL.md) — `VehicleBody3D` suspension/friction tuning and drift feel consume the vehicle and Jolt guidance here.
- [godot-genre-shooter-fps](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-shooter-fps/SKILL.md) — Hitscan rays, CharacterBody3D movement, and high-speed projectile CCD are direct consumers of these contracts.
- [godot-navigation-pathfinding](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-navigation-pathfinding/SKILL.md) — Agents still need physics layers for blockers and LOS; keep nav meshes and the collision world consistent.
- [godot-monte-carlo-balancer](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md) — Gravity, CCD, joint break thresholds, and hitbox size change win-rates; simulate those physics knobs instead of guessing.

#### Master
- [godot-master](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-master/SKILL.md) — Library router and mirrored entry point for discovering 3D physics alongside sibling domains.
