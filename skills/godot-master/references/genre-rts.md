---
name: godot-genre-rts
description: "Expert blueprint for real-time strategy games including unit selection (drag box, shift-add), command systems (move, attack, gather), pathfinding (NavigationAgent2D with RVO avoidance), fog of war (SubViewport mask shader), resource economy (gather/build loop), and AI opponents (behavior trees, utility AI). Use for base-building RTS or tactical combat games. Trigger keywords: RTS, unit_selection, command_system, fog_of_war, pathfinding_RVO, resource_economy, command_queue."
---

## Godot 4.7 Baseline

- Expert patterns in this skill target **Godot 4.7+** (stable, 2026-06-18).
- Consult the [Godot 4.7 migration guide](https://docs.godotengine.org/en/4.7/tutorials/migrating/upgrading_to_godot_4.7.html) when upgrading projects from 4.6.
- **NEVER** assume 4.6 defaults (stretch mode, audio area_mask, RichTextLabel percent flags) without checking 4.7 migration notes.

# Genre: Real-Time Strategy (RTS)

Expert blueprint for RTS games balancing strategy, micromanagement, and performance.

## NEVER Do (Expert Anti-Patterns)

### Unit Logic & Pathfinding
- NEVER allow pathfinding "Jitter" when moving group units; strictly **stagger path queries** and enable **RVO Avoidance** only when units are in motion to save CPU cycles.
- NEVER update RVO avoidance every frame for all units; strictly use **Avoidance Threading** (Project Settings) and replace static units with `NavigationObstacle`.
- NEVER let units get stuck in infinite path loops; strictly implement a **timeout and IDLE state** if a destination is unreachable.
- NEVER use `_process()` on hundreds of individual units; strictly use a central **UnitManager** or `_physics_process` only when required.
- NEVER calculate unit visibility manually for Fog of War; strictly use a **Shader-based mask** (SubViewport + ColorRect) for GPU efficiency.
- NEVER process unit AI or pathfinding synchronously for mass groups; strictly offload to **`WorkerThreadPool`** and stagger path updates.
- NEVER use high-poly visual meshes as NavMesh source geometry; strictly use simplified **Collision Shapes** for baking.

### Interaction & Commands
- NEVER forget **Command Queuing** (Shift-Click); strictly store an `Array[Command]` and implement a "Force Move/Attack" bypass.
- NEVER create excessive micromanagement; strictly automate low-level tasks like **auto-aggro range** and auto-return for resource gathering.
- NEVER use exact floating-point equality (==) for grid or timers; strictly use `is_equal_approx()` for deterministic triggers.
- NEVER rely on the visual SceneTree for selection data; strictly maintain a **Typed Selection Set** of `RefCounted` or `Resource` objects for deterministic serialization and netcode.
- NEVER forget **Command Queuing**; strictly implement a **Command Pattern** using serializable `Dictionary` or `JSON` states for save-game and multiplayer playback.
- NEVER forget to **duplicate_deep()** globally shared Resources; otherwise, modifying one unit's data (e.g., stats) affects all.

### Performance & Simulation
- NEVER render thousands of units using separate `MeshInstance3D` nodes; strictly use **`MultiMeshInstance`** with **`INSTANCE_CUSTOM`** data to drive unique GPU-side state animations (walking/attacking/color).
- NEVER calculate transforms for mass units on the main thread; strictly use **`WorkerThreadPool`** to push buffers to `RenderingServer.multimesh_set_buffer()`.
- NEVER update every unit's navigation path in the same frame; strictly use random timers to **stagger updates**.
- NEVER use standard Strings for high-frequency AI state identifiers; strictly use **StringName** (&"harvesting") for pointer-speed comparisons.
- NEVER allow simulation coordinates to exceed 8192 units without float-precision management; strictly use world-origin shifts.
- NEVER use `CSGShape3D` for building placement ghosts; strictly use optimized static `ArrayMesh` geometry.

---

## 🛠 Expert Components (scripts/)

> **MANDATORY**: Read the script for the workflow you are implementing — do not re-inline selection/fog recipes in the agent body.

### Selection / commands
- [selection_manager_marquee_2d.gd](../scripts/genre_rts_selection_manager_marquee_2d.gd) — **MANDATORY** for 2D drag-box, filter, shift-add.
- [selection_manager_raycast_3d.gd](../scripts/genre_rts_selection_manager_raycast_3d.gd) — **MANDATORY** for 3D PhysicsServer picks.
- [rts_selection_overlay.gd](../scripts/genre_rts_rts_selection_overlay.gd) — Selection visuals / box overlay.
- [rts_group_commander.gd](../scripts/genre_rts_rts_group_commander.gd) — SceneTree group broadcast for mass orders.
- [rts_targeting_logic.gd](../scripts/genre_rts_rts_targeting_logic.gd) — Distance-squared enemy filtering.

### Units / navigation / army
- [rts_unit.gd](../scripts/genre_rts_rts_unit.gd) — **MANDATORY** unit controller (states + NavigationAgent).
- [crowd_navigation_unit.gd](../scripts/genre_rts_crowd_navigation_unit.gd) — RVO / crowd agent wiring.
- [rts_path_query_pool.gd](../scripts/genre_rts_rts_path_query_pool.gd) — Pooled Navigation path queries.
- [navigation_mask_helper.gd](../scripts/genre_rts_navigation_mask_helper.gd) — Nav layers / avoidance bitmasks.
- [rts_army_manager.gd](../scripts/genre_rts_rts_army_manager.gd) — WorkerThreadPool army AI batches.
- [rts_unit_stat_duplicator.gd](../scripts/genre_rts_rts_unit_stat_duplicator.gd) — `duplicate_deep()` isolation for unit Resources.

### Economy / build / fog / ghosts
- [global_economy_manager.gd](../scripts/genre_rts_global_economy_manager.gd) — Gather/spend bank Autoload pattern.
- [building_grid_astar.gd](../scripts/genre_rts_building_grid_astar.gd) — Grid placement pathing.
- [fog_of_war_tile_mask.gd](../scripts/genre_rts_fog_of_war_tile_mask.gd) — **MANDATORY** TileMapLayer fog clear (2D/grid).
- [rendering_ghost_spawner.gd](../scripts/genre_rts_rendering_ghost_spawner.gd) — Placement ghosts via RenderingServer RIDs.

---

## Core Loop
1. **Gather**: Units collect resources (Gold, Wood, etc.).
2. **Build**: Construct base buildings to unlock tech/units.
3. **Train**: Produce an army of diverse units.
4. **Command**: Micromanage units in real-time battles.
5. **Expand**: Secure map control and resources.

## Skill Chain

| Phase | Skills | Purpose |
|-------|--------|---------|
| 1. Controls | `godot-input-handling`, `godot-camera-systems` | Selection box, camera pan/zoom/edge-scroll |
| 2. Units | `godot-navigation-pathfinding`, `godot-state-machine-advanced` | Pathfinding, RVO avoidance, Idle/Move/Attack |
| 3. Systems | `godot-shaders-basics`, `godot-tilemap-mastery`, `godot-economy-system` | Fog masks / TileMap fog, gather-spend ledger |
| 4. AI | `godot-ai-navigation`, `godot-autoload-architecture` | Enemy commander routing + army/economy Autoloads |
| 5. Polish | `godot-ui-containers`, `godot-particles` | Strategic UI chrome, battle feedback |
| 6. Balance | `godot-monte-carlo-balancer` | Build-order policies vs extracted AI orders |

## Decision Tree: NavigationAgent+RVO vs MultiMesh+server sim

| Active units (order of magnitude) | Simulation / pathing | Rendering | Load |
|-----------------------------------|----------------------|-----------|------|
| < ~80 | Per-unit `NavigationAgent2D/3D` + RVO; `set_velocity` → `velocity_computed` | MeshInstance / Sprite nodes OK | **MANDATORY** `rts_unit.gd`, `crowd_navigation_unit.gd` |
| ~80–400 | Stagger path queries; RVO only while moving; static → `NavigationObstacle`; central commander | Still node visuals; pool path queries | + `rts_path_query_pool.gd`, `rts_army_manager.gd`, Batch 09 COM formation |
| > ~400 / thousands | **Server sim**: logical transforms on WorkerThreadPool; few NavigationServer map queries (COM / squads), not one agent per soldier | **`MultiMeshInstance`** + `INSTANCE_CUSTOM`; push buffers off main thread | `rts_army_manager.gd` + MultiMesh path in Batch 09; **Do NOT Load** per-unit `_process` agents |

**Rule**: Keep NavigationAgent+RVO while units need individual collision avoidance and micromanage feel. Switch to MultiMesh + server-side transforms when draw-call/node cost dominates — path as squads, not as thousands of agents.

## Architecture Overview

### 1. Selection Manager
**MANDATORY**: [selection_manager_marquee_2d.gd](../scripts/genre_rts_selection_manager_marquee_2d.gd) (2D) or [selection_manager_raycast_3d.gd](../scripts/genre_rts_selection_manager_raycast_3d.gd) (3D). Maintain a **typed selection set** (not SceneTree-only) for netcode/save. Overlay: [rts_selection_overlay.gd](../scripts/genre_rts_rts_selection_overlay.gd).

### 2. Unit Controller (State Machine)
**MANDATORY**: [rts_unit.gd](../scripts/genre_rts_rts_unit.gd) for Idle/Move/Attack/Hold + NavigationAgent. Deep state graphs → `godot-state-machine-advanced`. Always `duplicate_deep()` shared stat Resources ([rts_unit_stat_duplicator.gd](../scripts/genre_rts_rts_unit_stat_duplicator.gd)).

### 3. Group Movement & Formations
Avoid clumping on one click target: compute **center of mass**, apply **relative offsets**, issue per-unit destinations. For hundreds of units, use **one** NavigationServer path for the COM (Batch 09) plus [rts_group_commander.gd](../scripts/genre_rts_rts_group_commander.gd) / [rts_path_query_pool.gd](../scripts/genre_rts_rts_path_query_pool.gd).

### 4. Fog of War
**MANDATORY** for tile/grid fog: [fog_of_war_tile_mask.gd](../scripts/genre_rts_fog_of_war_tile_mask.gd). SubViewport mask + shader overlay is valid for soft vision — implement via docs (`Using Viewports`) + `godot-shaders-basics`; **Do NOT** paste long fog shaders into this skill body when the tile-mask script covers the grid path.

## Key Mechanics Implementation

### Command Queue
Shift-click chains: store `Array` of serializable commands; pop on finish; draw queued path lines. Pair with selection scripts' issue-command hooks.

### Resource Gathering
`ResourceNode` → work timer → `DropoffPoint` → bank update. Wire bank through [global_economy_manager.gd](../scripts/genre_rts_global_economy_manager.gd) / `godot-economy-system`.

## Common Pitfalls

1. **Pathfinding jitter** — Enable RVO; call `set_velocity` + move on `velocity_computed`; stagger group path queries.
2. **Too much micro** — Auto-aggro / auto-return gather; command queue for force-move/attack.
3. **Node explosion** — Past a few hundred units, follow the decision tree (MultiMesh + army manager), not per-unit `_process`.

## Godot-Specific Tips

* **Avoidance**: `NavigationAgent*` RVO requires `set_velocity()` + `velocity_computed` for the actual move.
* **Server architecture**: Central `UnitManager` / [rts_army_manager.gd](../scripts/genre_rts_rts_army_manager.gd) for 100+ units.
* **Groups**: `Units`, `Buildings`, `Resources` for selection filters.

---

## 🚀 Elite Technical Implementations (Batch 09)

### 1. Center-of-Mass Formation Movement
For large selections, one NavigationServer path from COM → target, then offset each unit (see decision tree). Keep the algorithm in project code or formation helpers; pair with [rts_path_query_pool.gd](../scripts/genre_rts_rts_path_query_pool.gd) so path objects are pooled.

```gdscript
# Sketch only — prefer pooled queries from rts_path_query_pool.gd
static func move_group_to_target(units: Array, target: Vector3, map_rid: RID) -> void:
    if units.is_empty():
        return
    var com := Vector3.ZERO
    for u in units:
        com += u.global_position
    com /= units.size()
    var path: PackedVector3Array = NavigationServer3D.map_get_path(map_rid, com, target, true)
    if path.is_empty():
        return
    var dest: Vector3 = path[path.size() - 1]
    for u in units:
        u.set_movement_target(dest + (u.global_position - com))
```

### 2. MultiMesh armies (when decision tree says so)
Pre-allocate `instance_count`, drive `visible_instance_count`, push transforms (optionally via WorkerThreadPool → `RenderingServer.multimesh_set_buffer`). No per-soldier `MeshInstance3D`. See Official Documentation → Using MultiMesh.

### 3. Fog — script first
Prefer [fog_of_war_tile_mask.gd](../scripts/genre_rts_fog_of_war_tile_mask.gd). SubViewport vision masks: docs + `godot-shaders-basics` (do not duplicate long shader bodies here).
## Reference

> Progressive disclosure: open Official Documentation links only when researching a specific API;
> load Related Skills when routing work to a peer domain — do not preload the whole lattice.

### Official Documentation
- [Navigation (tutorial index)](https://docs.godotengine.org/en/stable/tutorials/navigation/index.html) — Entry map for agents, servers, meshes, layers, and obstacles before wiring army movement.
- [Using NavigationAgents](https://docs.godotengine.org/en/stable/tutorials/navigation/navigation_using_navigationagents.html) — `set_velocity` / `velocity_computed` RVO loop that stops crowd jitter and stuck IDLE timeouts.
- [Using NavigationServers](https://docs.godotengine.org/en/stable/tutorials/navigation/navigation_using_navigationservers.html) — Direct map path queries for center-of-mass formation moves without per-unit agent spam.
- [Using navigation path query objects](https://docs.godotengine.org/en/stable/tutorials/navigation/navigation_using_navigationpathqueryobjects.html) — Pooled `NavigationPathQueryParameters*` patterns for mass move orders without heap churn.
- [Optimizing navigation performance](https://docs.godotengine.org/en/stable/tutorials/navigation/navigation_optimizing_performance.html) — Staggered queries, avoidance budgets, and obstacle swaps when hundreds of units path each tick.
- [Using MultiMesh](https://docs.godotengine.org/en/stable/tutorials/performance/using_multimesh.html) — GPU instance buffers for thousands of units instead of one `MeshInstance` per soldier.
- [Using multiple threads](https://docs.godotengine.org/en/stable/tutorials/performance/using_multiple_threads.html) — `WorkerThreadPool` contracts for army AI batches off the main thread.
- [Ray-casting](https://docs.godotengine.org/en/stable/tutorials/physics/ray-casting.html) — Direct space-state picks for 3D selection and ground click targeting.
- [Using Viewports](https://docs.godotengine.org/en/stable/tutorials/rendering/viewports.html) — SubViewport vision masks that feed fog-of-war shaders without CPU tile floods.
- [Mouse and input coordinates](https://docs.godotengine.org/en/stable/tutorials/inputs/mouse_and_input_coordinates.html) — Screen-to-world mapping for marquee boxes, unproject selection, and shift-queued orders.
- [AStarGrid2D](https://docs.godotengine.org/en/stable/classes/class_astargrid2d.html) — Fast grid pathing for building footprints and base placement checks.
- [Resources](https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html) — Why unit stats must `duplicate(true)` so health/armor never mutate a shared template.

### Related Skills

#### Prerequisites
- [godot-project-foundations](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md) — Physics ticks, navigation/avoidance project settings, and input map actions before selection and pathing stay deterministic.
- [godot-input-handling](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-input-handling/SKILL.md) — Mouse buttons, shift-modifiers, and physics-step sampling that drive marquee select and command queuing.
- [godot-navigation-pathfinding](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-navigation-pathfinding/SKILL.md) — NavigationAgent RVO, maps, layers, and query-object pools this genre's army movement builds on.

#### Complements
- [godot-camera-systems](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-camera-systems/SKILL.md) — RTS pan/zoom/edge-scroll framing so selection and orders stay readable at strategic scale.
- [godot-raycasting-queries](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-raycasting-queries/SKILL.md) — PhysicsServer ray/shape recipes for 3D picks under heavy unit counts.
- [godot-state-machine-advanced](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-state-machine-advanced/SKILL.md) — Idle/Move/Attack/Hold command states and queue transitions per unit without spaghetti flags.
- [godot-shaders-basics](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-shaders-basics/SKILL.md) — CanvasItem/spatial mask shaders that sample SubViewport fog textures.
- [godot-autoload-architecture](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-autoload-architecture/SKILL.md) — Global economy and army managers as Autoloads with clear boot order.
- [godot-economy-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-economy-system/SKILL.md) — Gather/spend ledgers and cost dictionaries the RTS bank Autoload should reuse.
- [godot-signal-architecture](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md) — Group broadcast and command buses so commanders never hard-iterate every unit node.

#### Downstream / consumers
- [godot-monte-carlo-balancer](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md) — Build-order policies, unit cost curves, and AI opponent strength — simulate win% instead of gut-tuning gather rates.
- [godot-performance-optimization](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md) — Escalate here when MultiMesh buffers, avoidance, or WorkerThreadPool still dominate the profiler.
- [godot-combat-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-combat-system/SKILL.md) — Hit/hurt and targeting contracts once move/attack commands need damage resolution.

#### Master
- [godot-master](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-master/SKILL.md) — Library router and mirrored module entry; open when discovering which Domain Skill owns a cross-cutting RTS concern.
