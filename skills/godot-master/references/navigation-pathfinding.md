---
name: godot-navigation-pathfinding
description: "Expert blueprint for AI pathfinding (tower defense, RTS, stealth) using NavigationAgent2D/3D, NavigationServer, avoidance, and dynamic navigation mesh generation. Use when implementing enemy AI, NPC movement, or obstacle avoidance. Keywords NavigationAgent2D, NavigationRegion2D, pathfinding, NavigationServer, avoidance, baking, NavigationObstacle."
---
## Godot 4.7 Baseline

- Expert patterns in this skill target **Godot 4.7+** (stable, 2026-06-18).
- Consult the [Godot 4.7 migration guide](https://docs.godotengine.org/en/4.7/tutorials/migrating/upgrading_to_godot_4.7.html) when upgrading projects from 4.6.
- **NEVER** assume 4.6 defaults (stretch mode, audio area_mask, RichTextLabel percent flags) without checking 4.7 migration notes.

# Navigation & Pathfinding

NavigationServer pathfinding, async bake, RVO avoidance, and stuck recovery — not editor intro recipes.

## NEVER Do in Navigation & Pathfinding

- **NEVER set `target_position` before awaiting physics frame** — NavigationServer not ready in `_ready()`? Path fails silently. MUST `call_deferred()` then `await get_tree().physics_frame`.
- **NEVER use `NavigationRegion2D.bake_navigation_polygon()` at runtime** — Synchronous baking freezes game for 100+ ms. Use `NavigationServer.bake_from_source_geometry_data_async()` for stutter-free updates.
- **NEVER forget to check `is_navigation_finished()`** — Calling `get_next_path_position()` after reaching target = stale path, AI walks to old position.
- **NEVER use `avoidance_enabled` without setting radius** — Default radius = 0, agent passes through others. Set `nav_agent.radius = collision_shape.radius` for proper avoidance.
- **NEVER poll `target_position` every frame for chase AI** — Setting target 60x/sec = path recalculation spam. Use timer (0.2s intervals) or distance threshold for updates.
- **NEVER assume path exists** — Target unreachable (blocked by walls)? `get_next_path_position()` returns invalid. Check `is_target_reachable()` or validate path length.
- **NEVER use heavy node-based navigation for thousands of simple entities** — Use `NavigationServer3D/2D` RIDs directly to bypass node overhead.
- **NEVER call `get_path()` every frame** — Use `query_path()` with reused `NavigationPathQueryResult` objects to prevent massive heap allocation and GC pressure.
- **NEVER leave 'enter_cost' at 0 for high-penalty areas** — Use costs to make AI prefer logical paths (roads over water) instead of just shortest geometric distance.
- **NEVER ignore `agent_set_avoidance_callback`** — Always use the callback for safe velocity computation to avoid synchronization issues and "jittery" movement.


## Decision Tree → Scripts

> **MANDATORY** for the chosen path. **Do NOT Load** editor-intro / Official Docs bootstrap recipes from this skill body (use Reference links when you need first-time region setup).

| Need | Script |
|------|--------|
| Runtime / procedural bake without hitch | **MANDATORY** [async_dynamic_baking.gd](../scripts/navigation_pathfinding_async_dynamic_baking.gd) |
| Agent stuck / jitter recovery | **MANDATORY** [agent_stuck_detection.gd](../scripts/navigation_pathfinding_agent_stuck_detection.gd) |
| High-count RVO without nodes | **MANDATORY** [low_level_avoidance.gd](../scripts/navigation_pathfinding_low_level_avoidance.gd) |
| Moving platforms / dynamic regions | [dynamic_nav_manager.gd](../scripts/navigation_pathfinding_dynamic_nav_manager.gd) |
| RID-only maps/regions | [server_navigation_setup.gd](../scripts/navigation_pathfinding_server_navigation_setup.gd) |
| Reused path query objects | [memory_optimized_queries.gd](../scripts/navigation_pathfinding_memory_optimized_queries.gd) |
| Terrain enter/travel costs | [terrain_cost_manager.gd](../scripts/navigation_pathfinding_terrain_cost_manager.gd) |
| Projectiles as RVO obstacles | [moving_obstacle_server.gd](../scripts/navigation_pathfinding_moving_obstacle_server.gd) |
| Links (jump/teleport/elevator) | [nav_link_traversal.gd](../scripts/navigation_pathfinding_nav_link_traversal.gd) |
| Walk / fly / swim layers | [layer_mask_navigation.gd](../scripts/navigation_pathfinding_layer_mask_navigation.gd) |
| Crowd formation offsets | [group_avoidance_formations.gd](../scripts/navigation_pathfinding_group_avoidance_formations.gd) |
| Smart agent wrapper | [smart_navigation_agent.gd](../scripts/navigation_pathfinding_smart_navigation_agent.gd) |

## Chase / Retarget Rule (never contradict NEVER)

Do **not** assign `target_position` every physics frame. Retarget on a timer (~0.2s) or when the chased body moves beyond a distance threshold:

```gdscript
# Threshold retarget — not per-frame path spam
const RETARGET_DIST := 1.5
var _last_target: Vector3

func _physics_process(_delta: float) -> void:
    var desired := prey.global_position
    if desired.distance_to(_last_target) >= RETARGET_DIST:
        nav_agent.target_position = desired
        _last_target = desired
    if nav_agent.is_navigation_finished():
        return
    var next := nav_agent.get_next_path_position()
    velocity = (next - global_position).normalized() * speed
    move_and_slide()
```

## Available Scripts

### [async_dynamic_baking.gd](../scripts/navigation_pathfinding_async_dynamic_baking.gd)
`bake_from_source_geometry_data_async` — parse on main, bake off-thread.

### [agent_stuck_detection.gd](../scripts/navigation_pathfinding_agent_stuck_detection.gd)
Distance-over-time stall detection and recovery.

### [low_level_avoidance.gd](../scripts/navigation_pathfinding_low_level_avoidance.gd)
Server-side RVO agents + avoidance callbacks.

### [dynamic_nav_manager.gd](../scripts/navigation_pathfinding_dynamic_nav_manager.gd)
Runtime navmesh updates for moving platforms.

### [server_navigation_setup.gd](../scripts/navigation_pathfinding_server_navigation_setup.gd)
Node-less maps/regions via NavigationServer RIDs.

### [memory_optimized_queries.gd](../scripts/navigation_pathfinding_memory_optimized_queries.gd)
Reuse path query parameter/result objects.

### [terrain_cost_manager.gd](../scripts/navigation_pathfinding_terrain_cost_manager.gd)
`enter_cost` / `travel_cost` for preferred routes.

### [moving_obstacle_server.gd](../scripts/navigation_pathfinding_moving_obstacle_server.gd)
Dynamic RVO obstacles without full rebake.

### [nav_link_traversal.gd](../scripts/navigation_pathfinding_nav_link_traversal.gd)
NavigationLink jump/teleport/elevator handling.

### [layer_mask_navigation.gd](../scripts/navigation_pathfinding_layer_mask_navigation.gd)
Multi-domain navigation layers (walk/fly/swim).

### [group_avoidance_formations.gd](../scripts/navigation_pathfinding_group_avoidance_formations.gd)
Leader-relative offsets to reduce clumping.

### [smart_navigation_agent.gd](../scripts/navigation_pathfinding_smart_navigation_agent.gd)
Production NavigationAgent wrapper patterns.

## Expert Pointers

- Prefer Official Docs intros for first NavigationRegion bake UI; this skill owns async bake, server RVO, costs, and stuck recovery.
- Thousands of simple agents → RID server path ([server_navigation_setup.gd](../scripts/navigation_pathfinding_server_navigation_setup.gd) + [low_level_avoidance.gd](../scripts/navigation_pathfinding_low_level_avoidance.gd)), not one NavigationAgent node each.

## Reference

> Progressive disclosure: open Official Documentation links only when researching a specific API;
> load Related Skills when routing work to a peer domain — do not preload the whole lattice.

### Official Documentation
- [Navigation introduction (2D)](https://docs.godotengine.org/en/stable/tutorials/navigation/navigation_introduction_2d.html) — Minimal NavigationRegion2D + NavigationAgent2D setup, baking walkable polygons, and first-frame readiness.
- [Navigation introduction (3D)](https://docs.godotengine.org/en/stable/tutorials/navigation/navigation_introduction_3d.html) — Parallel 3D bootstrap with NavigationRegion3D / NavigationAgent3D and mesh baking expectations.
- [Using NavigationAgents](https://docs.godotengine.org/en/stable/tutorials/navigation/navigation_using_navigationagents.html) — target_position, get_next_path_position, avoidance radius, and velocity_computed safe-velocity flow.
- [Using NavigationServers](https://docs.godotengine.org/en/stable/tutorials/navigation/navigation_using_navigationservers.html) — RID maps/regions/agents for node-less crowds and custom server setups.
- [Using navigation meshes](https://docs.godotengine.org/en/stable/tutorials/navigation/navigation_using_navigationmeshes.html) — Parse/bake source geometry, async baking, and projected obstructions for dynamic carving.
- [Using NavigationRegions](https://docs.godotengine.org/en/stable/tutorials/navigation/navigation_using_navigationregions.html) — Region ownership, enter/travel costs, and chunked/runtime region updates.
- [Using NavigationObstacles](https://docs.godotengine.org/en/stable/tutorials/navigation/navigation_using_navigationobstacles.html) — RVO push obstacles vs bake-time carving without full remesh every frame.
- [Using NavigationLinks](https://docs.godotengine.org/en/stable/tutorials/navigation/navigation_using_navigationlinks.html) — Jump/teleport/elevator edges and manual link traversal on agents.
- [Using navigation layers](https://docs.godotengine.org/en/stable/tutorials/navigation/navigation_using_navigationlayers.html) — 32-bit layer bitmasks for walk/fly/swim (or faction) path filters.
- [Using navigation path query objects](https://docs.godotengine.org/en/stable/tutorials/navigation/navigation_using_navigationpathqueryobjects.html) — Reuse NavigationPathQueryParameters/Result to avoid per-frame GC in crowds.
- [Optimizing navigation performance](https://docs.godotengine.org/en/stable/tutorials/navigation/navigation_optimizing_performance.html) — Bake cost, agent/obstacle counts, and server query budgets for large AI populations.

### Related Skills

#### Prerequisites
- [godot-characterbody-2d](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-characterbody-2d/SKILL.md) — Path corners become CharacterBody velocity via move_and_slide; agent scripts assume a body parent.
- [godot-2d-physics](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-2d-physics/SKILL.md) — Collision layers/shapes still block bodies; navmesh is not a physics substitute for walls and triggers.
- [godot-physics-3d](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-physics-3d/SKILL.md) — 3D agents share the same split: NavigationServer paths vs RigidBody/CharacterBody collision and slopes.

#### Complements
- [godot-raycasting-queries](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-raycasting-queries/SKILL.md) — Line-of-sight, aim cones, and hit prediction sit beside pathfinding for chase/stealth AI.
- [godot-state-machine-advanced](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-state-machine-advanced/SKILL.md) — Patrol/chase/search states own when to retarget NavigationAgent and when to stop.
- [godot-tilemap-mastery](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-tilemap-mastery/SKILL.md) — TileMap/TileSet geometry often feeds NavigationPolygon baking in 2D levels.
- [godot-3d-world-building](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-world-building/SKILL.md) — Static meshes and GridMaps are the usual NavigationMesh source geometry for baked regions.
- [godot-procedural-generation](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-procedural-generation/SKILL.md) — Runtime layouts require parse + bake_from_source_geometry_data_async after generation.
- [godot-performance-optimization](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md) — Crowds push toward server RIDs, query reuse, and avoidance tuning called out in this skill.

#### Downstream / consumers
- [godot-genre-rts](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-rts/SKILL.md) — Unit move commands and RVO crowds consume NavigationAgent/Server patterns directly.
- [godot-genre-tower-defense](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-tower-defense/SKILL.md) — Lane/path enemies and dynamic blockers depend on regions, costs, and obstacle updates.
- [godot-genre-stealth](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-stealth/SKILL.md) — Guard patrols and investigate points are NavigationAgent routes gated by detection state.
- [godot-combat-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-combat-system/SKILL.md) — Engage/kite/flank movement issues new targets and stuck recovery on top of paths.
- [godot-monte-carlo-balancer](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md) — Simulate chase reachability, travel-time bands, and crowd pressure when tuning AI difficulty.

#### Master
- [godot-master](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-master/SKILL.md) — Library router and mirrored module entry for this Domain Skill.
