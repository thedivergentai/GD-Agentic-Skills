---
name: godot-ai-navigation
description: "AI movement decision router for chase, patrol, crowd, and bake choices on top of NavigationAgent/Server. Use when deciding node agent vs RID server, bake vs obstacle, layer masks, or retarget policy — not for engine navmesh recipes. Keywords: AI navigation, chase retarget, patrol, crowd RVO, bake vs obstacle, NavigationAgent decision tree."
---

## Godot 4.7 Baseline

- Expert patterns in this skill target **Godot 4.7+** (stable, 2026-06-18).
- Consult the [Godot 4.7 migration guide](https://docs.godotengine.org/en/4.7/tutorials/migrating/upgrading_to_godot_4.7.html) when upgrading projects from 4.6.
- **NEVER** assume 4.6 defaults (stretch mode, audio area_mask, RichTextLabel percent flags) without checking 4.7 migration notes.

# AI Navigation (Decision Router)

This skill owns **AI movement decisions**. Authoritative NavigationServer scripts live in **godot-navigation-pathfinding** — this package intentionally has **no** `scripts/` (no dead local links).

> **MANDATORY**: Before implementing path/bake/avoidance code, open [godot-navigation-pathfinding](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-navigation-pathfinding/SKILL.md) and **read the linked script(s)** below. **Do NOT Load** beginner chase/patrol tutorials from memory — follow these trees, then only the pathfinding scripts you selected.

## Decision Trees (MANDATORY script triggers)

### 1. Node agent vs NavigationServer RID
| Signal | Choice | Pathfinding script (MANDATORY read) |
| :--- | :--- | :--- |
| 2D top-down / side-scroller, < ~50 agents, editor-tweakable | `NavigationAgent2D` on CharacterBody2D | [smart_navigation_agent.gd](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-navigation-pathfinding/scripts/smart_navigation_agent.gd) |
| 3D floor/slope nav, < ~50 agents, designer-placed regions | `NavigationAgent3D` on CharacterBody3D | Same script (3D branch); pair with [godot-physics-3d](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-physics-3d/SKILL.md) for body collision |
| Hundreds–thousands of simple movers (2D or 3D) | RID agents on NavigationServer | [server_navigation_setup.gd](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-navigation-pathfinding/scripts/server_navigation_setup.gd) + [low_level_avoidance.gd](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-navigation-pathfinding/scripts/low_level_avoidance.gd) |
| Agents stuck / jittering | Stuck recovery before retarget spam | [agent_stuck_detection.gd](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-navigation-pathfinding/scripts/agent_stuck_detection.gd) |

### 2. Bake vs obstacle
| Signal | Choice | Pathfinding script (MANDATORY read) |
| :--- | :--- | :--- |
| Walkable geometry changed (proc gen, doors) | Async parse + bake | [async_dynamic_baking.gd](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-navigation-pathfinding/scripts/async_dynamic_baking.gd) |
| Moving platform / shifting region | Dynamic region manager | [dynamic_nav_manager.gd](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-navigation-pathfinding/scripts/dynamic_nav_manager.gd) |
| Projectile / rolling hazard pushing agents | RVO obstacle (no full rebake) | [moving_obstacle_server.gd](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-navigation-pathfinding/scripts/moving_obstacle_server.gd) |
| Prefer roads over mud/water | Region enter/travel costs | [terrain_cost_manager.gd](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-navigation-pathfinding/scripts/terrain_cost_manager.gd) |

### 3. Layers, links, crowds
| Signal | Choice | Pathfinding script (MANDATORY read) |
| :--- | :--- | :--- |
| Walk / fly / swim (or faction) filters | Navigation layers bitmasks | [layer_mask_navigation.gd](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-navigation-pathfinding/scripts/layer_mask_navigation.gd) |
| Jump / teleport / elevator edges | NavigationLink traversal | [nav_link_traversal.gd](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-navigation-pathfinding/scripts/nav_link_traversal.gd) |
| Formation / anti-clump crowds | Leader-relative offsets | [group_avoidance_formations.gd](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-navigation-pathfinding/scripts/group_avoidance_formations.gd) |
| Hot-path query allocs | Reuse query parameter/result objects | [memory_optimized_queries.gd](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-navigation-pathfinding/scripts/memory_optimized_queries.gd) |

**Do NOT Load** scripts outside the chosen row (e.g. skip RID/server scripts for a single designer-tuned agent; skip async bake when only RVO obstacles move).

### 4. Chase / patrol retarget policy (AI layer)
- **Chase**: Retarget on timer (~0.2s) or distance threshold — **never** assign `target_position` every physics frame.
- **Patrol**: Advance waypoint only when `is_navigation_finished()` **and** `is_target_reachable()`; on unreachable, pick next or repath.
- **State ownership**: Patrol/chase/search transitions belong in [godot-state-machine-advanced](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-state-machine-advanced/SKILL.md); this skill only decides *how* to retarget once a state asks for a destination.

**Patrol state handoff (call site):** in the patrol state's `_physics_process`, when the agent finishes a waypoint, call `retarget_if_needed(next_waypoint)` — do not set `target_position` directly from the state machine root.

```gdscript
# PatrolState.gd — state machine owns transitions; this skill owns retarget policy
func _physics_process(_delta: float) -> void:
	if nav_agent.is_navigation_finished() and nav_agent.is_target_reachable():
		_ai_nav.retarget_if_needed(_waypoints[_index])
		_index = (_index + 1) % _waypoints.size()
```

```gdscript
# Threshold retarget — AI policy, not per-frame path spam
const RETARGET_DIST := 1.5
var _last_target: Vector3

func retarget_if_needed(desired: Vector3) -> void:
	if desired.distance_to(_last_target) < RETARGET_DIST:
		return
	nav_agent.target_position = desired
	_last_target = desired
```

## NEVER Do in AI Navigation

- **NEVER set `target_position` before awaiting physics frame** — MUST `call_deferred()` then `await get_tree().physics_frame`.
- **NEVER use synchronous runtime bake** — Use `bake_from_source_geometry_data_async` via pathfinding [async_dynamic_baking.gd](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-navigation-pathfinding/scripts/async_dynamic_baking.gd).
- **NEVER poll chase targets every frame** — Path recalculation spam.
- **NEVER invent local duplicate nav scripts here** — Implement from godot-navigation-pathfinding only.
- **NEVER ignore `is_target_reachable()` / stuck recovery** — Unreachable or stalled agents need policy ([agent_stuck_detection.gd](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-navigation-pathfinding/scripts/agent_stuck_detection.gd)).
- **NEVER leave avoidance radius at 0** when `avoidance_enabled` — Agents pass through each other.
- **NEVER call `get_path()` every frame** — Reuse path query objects ([memory_optimized_queries.gd](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-navigation-pathfinding/scripts/memory_optimized_queries.gd)).

## Fallback (godot-navigation-pathfinding not installed)

If the sibling skill is unavailable, use this minimal stuck-recovery checklist — **do not** paste full bake/RID tutorials from memory:

1. Defer first `target_position` with `call_deferred` + `await get_tree().physics_frame`.
2. Retarget on timer (~0.2s) or distance threshold — never every frame.
3. On stall: if `!nav_agent.is_target_reachable()` or velocity ≈ 0 for N frames, skip waypoint or call `get_next_path_position()` recovery.
4. Avoidance: set `radius > 0` when `avoidance_enabled`.
5. Re-install [godot-navigation-pathfinding](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-navigation-pathfinding/SKILL.md) before shipping async bake or RID crowds.

## Golden Path

1. Classify the AI need with the decision trees above.
2. **MANDATORY** open each linked pathfinding script for the chosen rows — **Do NOT Load** the rest of that skill's scripts.
3. Wire retarget/state policy here (timer/threshold + state machine), movement via CharacterBody.
4. **Do NOT Load** Official Docs intro recipes unless first-time region bake UI is required (use Reference links).

## Reference

> Progressive disclosure: open Official Documentation links only when researching a specific API; load Related Skills when routing to a peer domain — do not preload the whole lattice.

### Official Documentation
- [Navigation overview](https://docs.godotengine.org/en/stable/tutorials/navigation/index.html) — Tutorial index for maps, regions, agents, meshes, links, obstacles, and performance before diving into class pages.
- [Navigation introduction (2D)](https://docs.godotengine.org/en/stable/tutorials/navigation/navigation_introduction_2d.html) — Minimal NavigationRegion2D + NavigationAgent2D setup, baking walkable polygons, and first-frame readiness.
- [Navigation introduction (3D)](https://docs.godotengine.org/en/stable/tutorials/navigation/navigation_introduction_3d.html) — Parallel 3D bootstrap with NavigationRegion3D / NavigationAgent3D and mesh baking expectations.
- [Using NavigationAgents](https://docs.godotengine.org/en/stable/tutorials/navigation/navigation_using_navigationagents.html) — target_position, get_next_path_position, avoidance radius, and velocity_computed safe-velocity flow for chase/patrol AI.
- [Using NavigationServers](https://docs.godotengine.org/en/stable/tutorials/navigation/navigation_using_navigationservers.html) — RID maps/regions/agents for node-less crowds and custom server setups at scale.
- [Using navigation meshes](https://docs.godotengine.org/en/stable/tutorials/navigation/navigation_using_navigationmeshes.html) — Parse/bake source geometry, async baking, and projected obstructions for dynamic carving.
- [Using NavigationRegions](https://docs.godotengine.org/en/stable/tutorials/navigation/navigation_using_navigationregions.html) — Region ownership, enter/travel costs, and chunked/runtime region updates for terrain penalties.
- [Using NavigationObstacles](https://docs.godotengine.org/en/stable/tutorials/navigation/navigation_using_navigationobstacles.html) — RVO push obstacles vs bake-time carving without full remesh every frame.
- [Using NavigationLinks](https://docs.godotengine.org/en/stable/tutorials/navigation/navigation_using_navigationlinks.html) — Jump/teleport/elevator edges and manual link traversal on agents.
- [Using navigation layers](https://docs.godotengine.org/en/stable/tutorials/navigation/navigation_using_navigationlayers.html) — 32-bit layer bitmasks for walk/fly/swim (or faction) path filters.
- [Using navigation path query objects](https://docs.godotengine.org/en/stable/tutorials/navigation/navigation_using_navigationpathqueryobjects.html) — Reuse NavigationPathQueryParameters/Result to avoid per-frame GC in crowds.
- [Optimizing navigation performance](https://docs.godotengine.org/en/stable/tutorials/navigation/navigation_optimizing_performance.html) — Bake cost, agent/obstacle counts, and server query budgets for large AI populations.

### Related Skills

#### Prerequisites
- [godot-navigation-pathfinding](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-navigation-pathfinding/SKILL.md) — **MANDATORY** authoritative NavigationServer scripts (async bake, RID setup, query reuse, stuck detection); this skill has no local `scripts/`.
- [godot-characterbody-2d](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-characterbody-2d/SKILL.md) — Path corners become CharacterBody velocity via move_and_slide; agent scripts assume a body parent.
- [godot-2d-physics](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-2d-physics/SKILL.md) — Collision layers/shapes still block bodies; navmesh is not a physics substitute for walls and triggers.
- [godot-physics-3d](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-physics-3d/SKILL.md) — 3D agents share the same split: NavigationServer paths vs RigidBody/CharacterBody collision and slopes.

#### Complements
- [godot-raycasting-queries](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-raycasting-queries/SKILL.md) — Line-of-sight, aim cones, and hit prediction sit beside pathfinding for chase/stealth AI.
- [godot-state-machine-advanced](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-state-machine-advanced/SKILL.md) — Patrol/chase/search states own when to retarget NavigationAgent and when to stop.
- [godot-tilemap-mastery](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-tilemap-mastery/SKILL.md) — TileMap/TileSet geometry often feeds NavigationPolygon baking in 2D levels.
- [godot-3d-world-building](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-world-building/SKILL.md) — Static meshes and GridMaps are the usual NavigationMesh source geometry for baked regions.
- [godot-procedural-generation](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-procedural-generation/SKILL.md) — Runtime layouts require parse + bake_from_source_geometry_data_async after generation.
- [godot-signal-architecture](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md) — velocity_computed / navigation_finished wiring stays clean when AI systems emit typed signals instead of polling.

#### Downstream / consumers
- [godot-genre-rts](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-rts/SKILL.md) — Unit move commands and RVO crowds consume NavigationAgent/Server patterns directly.
- [godot-genre-tower-defense](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-tower-defense/SKILL.md) — Lane/path enemies and dynamic blockers depend on regions, costs, and obstacle updates.
- [godot-genre-stealth](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-stealth/SKILL.md) — Guard patrols and investigate points are NavigationAgent routes gated by detection state.
- [godot-combat-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-combat-system/SKILL.md) — Engage/kite/flank movement issues new targets and stuck recovery on top of paths.
- [godot-monte-carlo-balancer](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md) — Simulate chase reachability, travel-time bands, and crowd pressure when tuning AI difficulty.

#### Master
- [godot-master](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-master/SKILL.md) — Library router and mirrored module entry for this Domain Skill.
