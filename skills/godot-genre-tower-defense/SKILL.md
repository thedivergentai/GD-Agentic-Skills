---
name: godot-genre-tower-defense
description: "Expert blueprint for tower defense games (Bloons TD, Kingdom Rush, Fieldrunners) covering wave management, tower targeting logic, path algorithms, economy balance, and mazing mechanics. Use when building TD, lane defense, or tower placement strategy games. Keywords tower defense, wave spawner, pathfinding, targeting priority, mazing, NavigationServer baking."
---

## Godot 4.7 Baseline

- Expert patterns in this skill target **Godot 4.7+** (stable, 2026-06-18).
- Consult the [Godot 4.7 migration guide](https://docs.godotengine.org/en/4.7/tutorials/migrating/upgrading_to_godot_4.7.html) when upgrading projects from 4.6.
- **NEVER** assume 4.6 defaults (stretch mode, audio area_mask, RichTextLabel percent flags) without checking 4.7 migration notes.

# Genre: Tower Defense

Strategic placement, resource management, and escalating difficulty define tower defense.

## Core Loop
1.  **Prepare**: Build/upgrade towers with available currency
2.  **Wave**: Enemies spawn and traverse path toward goal
3.  **Defend**: Towers auto-target and damage enemies
4.  **Reward**: Kills grant currency
5.  **Escalate**: Waves increase in difficulty/complexity

## NEVER Do (Expert Anti-Patterns)

### Design & Strategy
- NEVER make all towers have the same niche; strictly ensure distinct specialties: **Aura Slow**, **Armor Piercing**, **Anti-Air**, **Burst Sniper**, and **Splash Damage**.
- NEVER allow a "Death Spiral" with no exit; strictly provide small **comeback bonuses** or interest on saved gold to prevent early inevitable failure.
- NEVER make early waves feel like busywork; strictly provide an **"Early Call" bonus** to skip wait times and accelerate engagement.
- NEVER trust client-side economy updates; strictly require the **authoritative server** to validate currency addition and tower purchases in co-op.

### Pathing & Placement
- NEVER allow the player to "Seal" the exit in mazing games; strictly validate path existence with **`NavigationServer2D.map_get_path()`** before finalizing tower placement.
- NEVER use synchronous `bake_navigation_polygon()` for mazing; strictly offload to a **worker thread** to prevent 100ms+ frame hitches during placement.
- NEVER use global coordinates for grid logic; strictly convert to **Vector2i/Vector3i** to ensure pixel-perfect tower alignment.

### Performance & Systems
- NEVER call `get_overlapping_bodies()` every frame; strictly use **signals** (`body_entered`/`body_exited`) to maintain a local target cache.
- NEVER use `_process()` for projectile movement if count > 500; strictly use the **PhysicsServer2D/3D** directly for high-performance bullet-hell tiers.
- NEVER spawn hundreds of projectiles as full Nodes; strictly use **Object Pooling** to reuse resources and avoid garbage collection stutters.
- NEVER use standard Strings for priorities; strictly use `StringName` (&"first", &"strongest") for O(1) hash comparisons in targeting loops.
- NEVER ignore the `progress` property on PathFollow nodes; strictly use it as the O(1) way to identify the **target closest to exit**.
- NEVER process tower search logic every frame; strictly **throttle ACQUIRE searches** (e.g., every 5-10 frames) to save significant CPU cycles.
- NEVER scale Tower `CollisionShape` non-uniformly; strictly adjust the radius property of the Shape resource to preserve collision math.
- NEVER delete enemies immediately on death; strictly use **set_deferred("disabled", true)** and wait one frame to prevent physics server crashes.
- NEVER hardcode waves in huge switch statements; strictly use **Custom Resources (.tres)** for clean balancing and sequence editing.

---

## 🛠 Expert Components (scripts/)

### Original Expert Patterns
- [wave_manager.gd](scripts/wave_manager.gd) - Professional wave orchestrator with Resource-based enemy composition and cleanup.
- [tower.gd](scripts/tower.gd) - Base turret class with FSM state management and firing logic.
- [tower_targeting_system.gd](scripts/tower_targeting_system.gd) - Autonomous priority logic (First/Last/Strongest/Weakest) for efficient targeting.

### Modular Components
- [tower_defense_patterns.gd](scripts/tower_defense_patterns.gd) - Collection of patterns for furthest-target logic and PhysicsServer projectile optimization.


## Decision Trees (MANDATORY script reads)

### Path style
| Style | Approach | Scripts / APIs |
|-------|----------|----------------|
| Fixed lanes | `Path2D` / `PathFollow2D` `progress` | [wave_manager.gd](scripts/wave_manager.gd), [wave_resource_spawner.gd](scripts/wave_resource_spawner.gd) |
| Mazing | Seal-check before place | `NavigationServer2D.map_get_path` / `AStarGrid2D` (NEVER) |
| Organic curves | Bezier PathFollow `progress` | Prefer PathFollow over per-frame seek |

### Targeting priority
| Priority | Sort key | **MANDATORY** |
|----------|----------|---------------|
| FIRST | Highest `progress` (closest to exit) | [tower_targeting_system.gd](scripts/tower_targeting_system.gd) |
| LAST | Lowest `progress` | same — LAST implemented |
| STRONGEST / WEAKEST | `health` desc / asc | same — WEAKEST implemented |

Use **signal-cached** range `Area` enter/exit + **frame-sliced** acquire (`acquire_interval_frames`). Never `get_overlapping_bodies()` every frame.

### Economy
| Concern | Rule | Script |
|---------|------|--------|
| Wave composition | Resource `.tres` waves | [wave_manager.gd](scripts/wave_manager.gd) |
| Co-op purchases | Server validates gold | [tower_defense_patterns.gd](scripts/tower_defense_patterns.gd) |
| Comeback | Interest / early-call bonus | Design-level — not tower FSM |

## PhysicsServer Projectile Golden Path

When count > ~500:

1. **MANDATORY** [tower_defense_patterns.gd](scripts/tower_defense_patterns.gd) `spawn_fast_bullet` (`PhysicsServer3D` kinematic RIDs).
2. Pool RIDs; AoE via `intersect_shape`; defer collision disable on death.
3. Modest counts: [homing_projectile_3d.gd](scripts/homing_projectile_3d.gd) / pooled Nodes OK.

## Tower FSM

**MANDATORY**: [tower.gd](scripts/tower.gd) for idle → acquire → windup → fire. Targeting stays in [tower_targeting_system.gd](scripts/tower_targeting_system.gd).


## Reference

> Progressive disclosure: open Official Documentation links only when researching a specific API; load Related Skills when routing to a peer domain — do not preload the whole lattice.

### Official Documentation
- [Navigation introduction (2D)](https://docs.godotengine.org/en/stable/tutorials/navigation/navigation_introduction_2d.html) — NavigationRegion2D baking and map queries for mazing TD path validity.
- [Using NavigationAgents](https://docs.godotengine.org/en/stable/tutorials/navigation/navigation_using_navigationagents.html) — agent path following and avoidance when towers reshape walkable space.
- [NavigationServer2D](https://docs.godotengine.org/en/stable/classes/class_navigationserver2d.html) — `map_get_path` seal checks before committing tower placement.
- [AStarGrid2D](https://docs.godotengine.org/en/stable/classes/class_astargrid2d.html) — integer-grid path probes that simulate build cells without a full nav bake.
- [PathFollow2D](https://docs.godotengine.org/en/stable/classes/class_pathfollow2d.html) — `progress` / `progress_ratio` for fixed-lane enemies and First/Last targeting.
- [PathFollow3D](https://docs.godotengine.org/en/stable/classes/class_pathfollow3d.html) — 3D track followers used by wave spawners and homing aim references.
- [Using Area2D](https://docs.godotengine.org/en/stable/tutorials/physics/using_area_2d.html) — signal-driven range caches (`body_entered` / `body_exited`) instead of per-frame overlap polls.
- [Physics introduction](https://docs.godotengine.org/en/stable/tutorials/physics/physics_introduction.html) — layers/masks so tower ranges hit enemies, not other towers or walls.
- [Using servers](https://docs.godotengine.org/en/stable/tutorials/performance/using_servers.html) — PhysicsServer bodies for high-count projectiles without Node overhead.
- [Resources](https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html) — WaveDefinition `.tres` data instead of hard-coded spawn switches.
- [Using multiple threads](https://docs.godotengine.org/en/stable/tutorials/performance/using_multiple_threads.html) — WorkerThreadPool / Thread patterns for async navigation rebakes during placement.
- [Using TileMaps](https://docs.godotengine.org/en/stable/tutorials/2d/using_tilemaps.html) — TileMapLayer grids for build cells, paths, and placement snapping.

### Related Skills

#### Prerequisites
- [godot-project-foundations](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md) — project settings, layers, and scene structure before wave/tower wiring.
- [godot-navigation-pathfinding](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-navigation-pathfinding/SKILL.md) — NavigationServer bake, agents, and path queries that mazing TD depends on.
- [godot-tilemap-mastery](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-tilemap-mastery/SKILL.md) — TileMapLayer/TileSet grids for buildable cells and lane painting.

#### Complements
- [godot-2d-physics](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-2d-physics/SKILL.md) — Area2D range, layers, and PhysicsServer2D projectile patterns for dense waves.
- [godot-state-machine-advanced](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-state-machine-advanced/SKILL.md) — StringName tower FSM states (Idle/Acquire/Attack/Cooldown).
- [godot-economy-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-economy-system/SKILL.md) — kill rewards, interest, and early-call income without death spirals.
- [godot-combat-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-combat-system/SKILL.md) — damage types, armor pierce, splash, and projectile hit resolution.
- [godot-resource-data-patterns](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md) — typed Wave/Tower Resources and `duplicate(true)` for balance edits.
- [godot-game-loop-waves](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-game-loop-waves/SKILL.md) — prepare/defend/reward phase orchestration around the spawner.
- [godot-signal-architecture](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md) — wave_started / enemy_died / currency_changed buses without frame polling.
- [godot-performance-optimization](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md) — pooling, server bodies, and throttled acquire searches under heavy projectile counts.
- [godot-monte-carlo-balancer](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md) — sample wave DPS, leak rates, and economy bands before shipping difficulty curves.

#### Downstream / consumers
- [godot-genre-rts](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-rts/SKILL.md) — base defense and unit-placement loops that reuse path validation and economy pressure.
- [godot-multiplayer-networking](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-multiplayer-networking/SKILL.md) — authoritative purchase validation and unreliable minion sync for co-op TD.

#### Master
- [godot-master](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-master/SKILL.md) — library router and mirrored module entry for cross-skill discovery.
