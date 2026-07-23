---
name: godot-game-loop-waves
description: Expert patterns for managing combat waves, difficulty scaling, and automated enemy spawning in Godot 4. Use when building wave-based shooters, tower defense, or arena games.
---

## Godot 4.7 Baseline

- Expert patterns in this skill target **Godot 4.7+** (stable, 2026-06-18).
- Consult the [Godot 4.7 migration guide](https://docs.godotengine.org/en/4.7/tutorials/migrating/upgrading_to_godot_4.7.html) when upgrading projects from 4.6.
- **NEVER** assume 4.6 defaults (stretch mode, audio area_mask, RichTextLabel percent flags) without checking 4.7 migration notes.

# Wave Loop: Combat Pacing

> [!NOTE]
> **Resource Context**: This module provides expert patterns for **Wave Loops**. Accessed via Godot Master.

## Architectural Thinking: The "Wave-State" Pattern

A Master implementation treats waves as **Data-Driven Transitions**. Instead of hardcoding spawn counts, use a `WaveResource` to define "Encounters" that the `WaveManager` processes sequentially.

### Core Responsibilities
- **Manager**: Orchestrates the timeline. Handles delays between waves and tracks "Victory" conditions (all enemies dead).
- **Spawner**: Decoupled nodes that provide spatial context for where enemies appear (`wave_spawner.gd` / `wave_weighted_spawner.gd`).
- **Resource**: Immutable data containers that allow designers to rebalance the game without touching code.

## Density Decision Tree (pick scale before coding)

| Live density | Approach | MANDATORY loads |
| :--- | :--- | :--- |
| **Under ~80 SceneTree enemies** | Node manager + Marker spawners | [wave_manager.gd](scripts/wave_manager.gd), [wave_spawner.gd](scripts/wave_spawner.gd), [wave_resource.gd](scripts/wave_resource.gd) |
| **Swarm visuals / hundreds** | MultiMesh + weighted composition | [wave_loop_patterns.gd](scripts/wave_loop_patterns.gd) (MultiMesh / async path), [wave_weighted_spawner.gd](scripts/wave_weighted_spawner.gd) |
| **~10k bodies** | PhysicsServer / NavigationServer RIDs (no per-mob Node) | [wave_loop_patterns.gd](scripts/wave_loop_patterns.gd) server-RID patterns; do **not** scale `wave_manager` node spawns |

`wave_manager.gd` is the SceneTree golden path (deferred `add_child`, group/signal clear counts, optional pool). Treat it as **prototype→mid-scale** — for RID swarms, follow `wave_loop_patterns.gd` instead of instantiating thousands of nodes.

## Composition Golden Path

1. Author a [wave_resource.gd](scripts/wave_resource.gd) composition table.
2. Place [wave_spawner.gd](scripts/wave_spawner.gd) Markers (or [wave_weighted_spawner.gd](scripts/wave_weighted_spawner.gd) when variety weights matter).
3. Point [wave_manager.gd](scripts/wave_manager.gd) `spawner` at that Marker; manager defers spawn and clears via `&"enemies"` group + signals.
4. When weights replace fixed counts, call `WaveWeightedSpawner.spawn_enemy()` from the composition loop (or set manager `spawner` to the weighted node).

## Expert Code Patterns

### 1. The Async Wave Trigger
Use `await` timers in [wave_manager.gd](scripts/wave_manager.gd) — **MANDATORY read** before writing a custom timeline. Spawns use `call_deferred(&"add_child", …)`; clear via signals/groups (not `get_children()` scans).

### 2. Composition-Based Spawning
Define variety in [wave_resource.gd](scripts/wave_resource.gd); place units with [wave_spawner.gd](scripts/wave_spawner.gd) / [wave_weighted_spawner.gd](scripts/wave_weighted_spawner.gd). Do not hardcode scene paths in the manager.

## Master Decision Matrix: Progression

| Pattern | Best For | Logic |
| :--- | :--- | :--- |
| **Linear** | Story missions | Hand-crafted list of `WaveResource`. |
| **Endless** | Survival modes | Code-generated `WaveResource` with multiplier math. |
| **Triggered** | RPG Encounters | Wave starts only when player enters an `Area3D`. |

## NEVER Do

- **NEVER iterate through get_children() to find all enemies** — This is extremely slow. Always add enemies to an "enemies" group and use `get_tree().get_nodes_in_group(&"enemies")` for efficient access.
- **NEVER constantly instantiate() and queue_free() hundreds of enemies** — This causes garbage collection stutters. Use an object pool to reuse existing enemy instances.
- **NEVER spawn thousands of separate MeshInstance3D nodes for swarms** — This will tank your draw calls. Use `MultiMeshInstance3D` to batch thousands of meshes into a single GPU call.
- **NEVER calculate pathfinding for hundreds of agents on the main thread** — This will freeze your game. Enable `use_async_iterations` on your navigation regions or use `NavigationServer3D.query_path()`.
- **NEVER forget to check is_inside_tree() before adding a child** — If the spawner is queued for deletion, adding a child will crash. Always verify the spawner is still active in the tree.
- **NEVER assign a preloaded resource (like stats.tres) directly to spawned mobs** — They will all share the exact same health/stats. Always call `base_stats.duplicate_deep()` to give each mob its own unique data.
- **NEVER use standard strings for high-frequency group calls** — Always use `StringName` (&"enemies", &"take_damage") for optimal hash performance and to avoid unnecessary string allocations.
- **NEVER spawn entities directly inside physics callbacks synchronously** — Instantiating nodes during physics steps can corrupt the physics state. Always use `call_deferred(&"add_child", enemy)`.
- **NEVER leave CollisionShapes on dead enemies active** — Corpses will block towers and navigation. Use `set_deferred("disabled", true)` immediately upon death.
- **NEVER synchronize complex Object types via MultiplayerSynchronizer** — It only supports primitive types. For complex data, sync a UID or ID and look up the data locally on the client.
- **NEVER auto-start waves without player feedback** — Always provide a UI countdown, a visual "Wave Incoming" effect, or a start button to maintain player agency.
- **NEVER hardcode spawn positions at (0,0,0)** — Use `Marker3D` nodes in the editor so you can visually adjust spawn points without digging into code.
- **NEVER check wave completion by counting children every frame** — It's too expensive. Maintain a local counter or use a signal-based system to track active enemy counts.
- **NEVER use the same navigation map for every entity type** — If you have flying and walking enemies, use separate navigation maps to prevent pathing issues.
- **NEVER scale collision shapes non-uniformly for spawners** — This breaks the collision detection math. Adjust the shape resource properties instead.

---

## Available Scripts

> **MANDATORY**: Read the appropriate script before implementing the corresponding pattern.

### [wave_loop_patterns.gd](scripts/wave_loop_patterns.gd)
10 Expert patterns: MultiMesh swarms, async pathfinding, background preloading, and server-side physics mobs.

### [wave_manager.gd](scripts/wave_manager.gd)
Orchestrates the timeline, delays between waves, and tracks clear via group counts + signals. Uses `call_deferred` add_child; optional pool via `use_pool` / `recycle_enemy`.

### [wave_resource.gd](scripts/wave_resource.gd)
Data containers for wave compositions and difficulty settings.

### [wave_spawner.gd](scripts/wave_spawner.gd)
`Marker3D` spatial portal — `get_spawn_position()` with optional radius jitter. Wire as `WaveManager.spawner`.

### [wave_weighted_spawner.gd](scripts/wave_weighted_spawner.gd)
Weighted random enemy selection at a Marker. Use when composition variety is probability-driven rather than fixed counts.

---

## Expert Wave Patterns

### 1. Occlusion Culling for Swarms
To optimize performance with hundreds of enemies, enable **Occlusion Culling**.
- **Setup**: Add an `OccluderInstance3D` to your arena and bake it.
- **Result**: Enemies completely hidden behind walls/pillars won't be processed by the GPU, significantly boosting FPS.

### 2. Wave UI Architecture
Decouple your wave data from the UI using a `CanvasLayer` and signals.
- **Wave Counter**: Display current/total waves.
- **Health Bars**: Use a `TextureProgressBar` on a `CanvasLayer` for bosses, or `Sprite3D` with a viewport texture for individual enemy health bars.

## Reference

> Progressive disclosure: open Official Documentation links only when researching a specific API; load Related Skills when routing to a peer domain — do not preload the whole lattice.

### Official Documentation
- [Resources](https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html) — `WaveResource` compositions and delays stay designer-editable without hardcoding spawn tables in managers.
- [Nodes and scene instances](https://docs.godotengine.org/en/stable/tutorials/scripting/nodes_and_scene_instances.html) — `PackedScene.instantiate()` plus `add_child` / `call_deferred` is the safe spawn path for wave enemies.
- [Groups](https://docs.godotengine.org/en/stable/tutorials/scripting/groups.html) — track live mobs with `StringName` groups and `get_node_count_in_group` instead of scanning children every frame.
- [Idle and Physics Processing](https://docs.godotengine.org/en/stable/tutorials/scripting/idle_and_physics_processing.html) — keep pacing on timers/`await`; never instantiate mid-physics callback without deferring.
- [SceneTreeTimer](https://docs.godotengine.org/en/stable/classes/class_scenetreetimer.html) — pre-wave delays and spawn-rate gaps via `create_timer` without a forever `_process` countdown.
- [Using signals](https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html) — `wave_started` / `wave_cleared` / `all_waves_complete` decouple UI, audio, and combat from the manager timeline.
- [Background loading](https://docs.godotengine.org/en/stable/tutorials/io/background_loading.html) — `ResourceLoader.load_threaded_request` bosses/heavy waves so first spawn does not hitch.
- [Random number generation](https://docs.godotengine.org/en/stable/tutorials/math/random_number_generation.html) — weighted composition and spawn jitter with `RandomNumberGenerator.rand_weighted`.
- [Using MultiMesh](https://docs.godotengine.org/en/stable/tutorials/performance/using_multimesh.html) — batch swarm visuals when hundreds of minions would explode draw calls.
- [Occlusion culling](https://docs.godotengine.org/en/stable/tutorials/3d/occlusion_culling.html) — hide off-camera arena mobs so dense waves stay GPU-affordable.
- [Navigation introduction (3D)](https://docs.godotengine.org/en/stable/tutorials/navigation/navigation_introduction_3d.html) — async agent paths and separate maps for flying vs walking wave units.
- [Using Servers](https://docs.godotengine.org/en/stable/tutorials/performance/using_servers.html) — PhysicsServer3D/NavigationServer3D RID swarms when SceneTree nodes cannot scale.

### Related Skills

#### Prerequisites
- [godot-project-foundations](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md) — scene tree, exports, and groups before wiring a WaveManager into an arena.
- [godot-gdscript-mastery](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md) — typed `await`, signals, and `call_deferred` patterns the async wave trigger depends on.
- [godot-resource-data-patterns](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md) — `Resource`/`@export` composition and `duplicate_deep` so spawned mobs do not share stats.

#### Complements
- [godot-signal-architecture](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md) — ownership of wave/UI/combat signals so countdown and clear events stay leak-free.
- [godot-combat-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-combat-system/SKILL.md) — hitboxes, death, and damage that decrement active-enemy counters when a wave unit dies.
- [godot-navigation-pathfinding](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-navigation-pathfinding/SKILL.md) — NavigationServer queries, avoidance masks, and maps for pathing hundreds of wave agents.
- [godot-scene-management](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-scene-management/SKILL.md) — pools, threaded loads, and safe add/remove when waves churn PackedScenes.
- [godot-performance-optimization](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md) — MultiMesh, occlusion, and server-side bodies for swarm density budgets.
- [godot-monte-carlo-balancer](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md) — style-matrix sampling of spawn counts, rates, and difficulty curves before shipping endless modes.

#### Downstream / consumers
- [godot-genre-tower-defense](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-tower-defense/SKILL.md) — lane/portal waves driven by WaveResource sequences and clear-win conditions.
- [godot-genre-shooter](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-shooter/SKILL.md) — arena/horde spawn pacing and enemy variety for wave shooters.
- [godot-genre-survival](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-survival/SKILL.md) — endless multiplier waves and pressure ramps built on the same manager loop.

#### Master
- [godot-master](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-master/SKILL.md) — library router and mirrored module entry for cross-skill discovery.
