---
name: godot-genre-roguelike
description: "Expert blueprint for roguelikes including procedural generation (Walker method, BSP rooms), permadeath with meta-progression (unlock persistence), run state vs meta state separation, seeded RNG (shareable runs), loot/relic systems (hook-based modifiers), and difficulty scaling (floor-based progression). Use for dungeon crawlers, action roguelikes, or roguelites. Trigger keywords: roguelike, procedural_generation, permadeath, meta_progression, seeded_RNG, relic_system, run_state."
---

## Godot 4.7 Baseline

- Expert patterns in this skill target **Godot 4.7+** (stable, 2026-06-18).
- Consult the [Godot 4.7 migration guide](https://docs.godotengine.org/en/4.7/tutorials/migrating/upgrading_to_godot_4.7.html) when upgrading projects from 4.6.
- **NEVER** assume 4.6 defaults (stretch mode, audio area_mask, RichTextLabel percent flags) without checking 4.7 migration notes.

# Genre: Roguelike

Expert blueprint for roguelikes balancing challenge, progression, and replayability.

## NEVER Do (Expert Anti-Patterns)

### Generation & RNG
- NEVER make runs dependent on pure RNG; strictly provide **mitigation** (rerolls, shops, pity timers) to ensure every run is winnable.
- NEVER use unseeded RNG for world generation; strictly initialize isolated `RandomNumberGenerator` with a predictable seed for daily runs/debugging.
- NEVER rely on `@GlobalScope.randi()` for critical logic; strictly use local RNG instances to prevent global state pollution.
- NEVER use `Array.pick_random()` for critical content drops; strictly use a **Shuffle Bag** to prevent statistically unfair streaks.
- NEVER generate massive dungeons on the main thread; strictly use **`WorkerThreadPool.add_task()`** or **`add_group_task()`** to distribute generation across cores and prevent frame freezes.
- NEVER interact with the SceneTree from a background thread; strictly generate dungeon data in a **thread-safe Array/PackedByteArray** before parsing on the main thread.

### Data & State
- NEVER allow **Save Scumming**; strictly delete mid-run save files immediately upon loading to enforce permadeath.
- NEVER allow the player to see the "Edge of the World"; strictly use **Fog of War** or limited vision cones to maintain the mystery of the unknown.
- NEVER evaluate complex "Director" heuristics every frame; strictly use **Frame-Slicing (`Engine.get_process_frames()`)** to run heavy pacing logic only once every 60-120 frames for CPU efficiency.
- NEVER move rooms individually by pixel values during procedural generation; strictly use **`Marker2D` Connection Points** in pre-authored scenes to calculate exact offsets for seamless room stitching.
- NEVER allow Run State to leak into Meta State; strictly use separate singletons or Resources for `RunManager` and `MetaManager`.
- NEVER scale meta-progression to be overpowered (+100% damage); strictly keep upgrades subtle (+5-15%) to maintain skill-based play.
- NEVER forget to call `duplicate(true)` on base stat Resources; failing to deep-duplicate causes all entities to share a single health instance.
- NEVER save run states to `.tscn` files; strictly serialize to JSON or binary in `user://` to prevent bloat.
- NEVER rely on the `SceneTree` as the source of truth for grid logic; strictly maintain grid data in a separate Dictionary or Array.

### Grid & Performance
- NEVER forget to handle **Navigation re-baking**; strictly rebake `NavigationRegion2D` AFTER procedural tiles are placed.
- NEVER use AStar2D for tile grids; strictly use **`AStarGrid2D`** with **`jumping_enabled = true`** (Jump Point Search) for O(1) queries and high-performance pathing across open areas.
- NEVER forget to call `update()` on `AStarGrid2D` after modifying states; strictly ensures pathfinding queries aren't stale.
- NEVER use floats (`Vector2`) for discrete grid coordinates; strictly use **Vector2i** to prevent precision drift.
- NEVER use Manhattan heuristics for 8-way movement; strictly use **`HEURISTIC_CHEBYSHEV`** or **`HEURISTIC_OCTILE`**.
- NEVER iterate over every cell coordinate (0 to W,H) in GDScript; strictly use `get_used_cells()` for optimized tile access.
- NEVER clear procedural levels using `free()`; strictly use `queue_free()` to avoid mid-frame segmentation faults.
- NEVER broadcast mass state changes to a grid immediately; strictly use `call_deferred()` or **`call_group_flags`** to avoid frame spikes during turn transitions.
- NEVER use heavy TileMapLayer nodes for high-resolution Fog of War; strictly use a **GPU Shader Mask** via `ColorRect` and an `ImageTexture` updated via **`RenderingServer.texture_2d_update()`**.

## 🛠 Expert Components (scripts/)

> **MANDATORY** before implementing generation, seed sharing, or meta unlocks — read these first (do not reinvent from inline samples):
> - [dungeon_generator_walker.gd](../scripts/genre_roguelike_dungeon_generator_walker.gd) — Drunkard's Walk with **local** `RandomNumberGenerator` (`rng.randi() % n`, never `Array.pick_random()`).
> - [seeded_rng_resource.gd](../scripts/genre_roguelike_seeded_rng_resource.gd) — seed persistence for shareable / daily runs.
> - [meta_progression_manager.gd](../scripts/genre_roguelike_meta_progression_manager.gd) — permanent unlock currency + save boundaries vs run state.
>
> **Do NOT Load** the full scripts/ folder for a single task. Open only the script that matches the phase below.

### Original Expert Patterns
- [meta_progression_manager.gd](../scripts/genre_roguelike_meta_progression_manager.gd) - Foundational meta-progression logic with secure data persistence and currency unlocks.
- [roguelike_patterns.gd](../scripts/genre_roguelike_roguelike_patterns.gd) - 10 Essential Roguelike Expert Snippets (AStar, BSP, WorkerThreadPool, ShuffleBag, etc.).

### Modular Components
- [dungeon_generator_walker.gd](../scripts/genre_roguelike_dungeon_generator_walker.gd) - Drunkard's Walk algorithm for carving procedural rooms and caves.
- [fov_raycast_calculator.gd](../scripts/genre_roguelike_fov_raycast_calculator.gd) - High-performance LOS checking using physics server queries.
- [seeded_rng_resource.gd](../scripts/genre_roguelike_seeded_rng_resource.gd) - RNG state persistence for deterministic and shareable replayability.
- [turn_manager_decoupled.gd](../scripts/genre_roguelike_turn_manager_decoupled.gd) - Signal-driven turn coordination for decoupled entity logic.
- [astar_grid_handler.gd](../scripts/genre_roguelike_astar_grid_handler.gd) - Specialised AStarGrid2D wrapper for optimized roguelike pathfinding.
- [weighted_loot_table.gd](../scripts/genre_roguelike_weighted_loot_table.gd) - Native-optimized weighted random item drops with drop-rate controls.
- [json_state_serializer.gd](../scripts/genre_roguelike_json_state_serializer.gd) - Persistent serialization for procedural entity data and run states.
- [fog_of_war_masker.gd](../scripts/genre_roguelike_fog_of_war_masker.gd) - TileMapLayer-based visibility masking and discovery system.
- [meta_progression_resource.gd](../scripts/genre_roguelike_meta_progression_resource.gd) - Data separation for permanent game unlocks and skill trees.
- [move_command_object.gd](../scripts/genre_roguelike_move_command_object.gd) - Command pattern implementation for reversible turn-based actions.
- [dungeon_generator.gd](../scripts/genre_roguelike_dungeon_generator.gd) - High-level procedural orchestrator for room-and-hallway layout generation.

## Core Loop
1.  **Preparation**: Select character, equip meta-upgrades (see `meta_progression_resource.gd`).
2.  **The Run**: complete procedural levels (`dungeon_generator_walker.gd`), acquire temporary power-ups.
3.  **The Challenge**: Survive increasingly difficult encounters using A* pathfinding (`astar_grid_handler.gd`).
4.  **Death/Victory**: Run ends, resources calculated.
5.  **Meta-Progression**: Spend resources on permanent unlocks (`meta_progression_resource.gd`).
6.  **Repeat**: Start a new run with new capabilities.

## Skill Chain

| Phase | Skills | Purpose |
|-------|--------|---------|
| 1. Architecture | `godot-autoload-architecture`, `godot-state-machine-advanced` | Run State vs Meta State boundaries |
| 2. World Gen | `godot-procedural-generation`, `godot-tilemap-mastery` | Unique levels every run (walker/BSP/noise) |
| 3. Combat | `godot-combat-system`, `godot-ai-navigation` | High-stakes encounters + FOV/pathing |
| 4. Progression | `godot-inventory-system`, `godot-resource-data-patterns` | Run items/relics + typed Resources |
| 5. Persistence | `godot-save-load-systems` | Meta unlocks + anti-scum mid-run deletes |
| 6. Balance | `godot-monte-carlo-balancer` | Win% vs meta level; dead-item detection |

## Architecture Overview

Roguelikes require a strict separation between **Run State** (temporary) and **Meta State** (persistent).

- **Run lifespan / seed**: Own an AutoLoad that resets on death; seed via **MANDATORY** [seeded_rng_resource.gd](../scripts/genre_roguelike_seeded_rng_resource.gd). Never leak run HP/gold into meta saves.
- **Meta unlocks**: **MANDATORY** [meta_progression_manager.gd](../scripts/genre_roguelike_meta_progression_manager.gd) + [meta_progression_resource.gd](../scripts/genre_roguelike_meta_progression_resource.gd) — subtle permanent bonuses only (+5–15%).
- **Serialize**: Prefer [json_state_serializer.gd](../scripts/genre_roguelike_json_state_serializer.gd) / `user://` JSON-binary; never treat `.tscn` as a run save.

## Key Mechanics (route to scripts/)

### Procedural Dungeon Generation
- **Drunkard's Walk**: **MANDATORY** [dungeon_generator_walker.gd](../scripts/genre_roguelike_dungeon_generator_walker.gd) — pass a local seeded `RandomNumberGenerator`; directions via `rng.randi() % directions.size()` (never `Array.pick_random()`).
- **Critical drops / fairness**: Use Shuffle Bag patterns in [roguelike_patterns.gd](../scripts/genre_roguelike_roguelike_patterns.gd) or weights in [weighted_loot_table.gd](../scripts/genre_roguelike_weighted_loot_table.gd).
- **BSP / room orchestrator**: [dungeon_generator.gd](../scripts/genre_roguelike_dungeon_generator.gd); deeper WFC/noise → peer `godot-procedural-generation`.
- **Pathing after gen**: [astar_grid_handler.gd](../scripts/genre_roguelike_astar_grid_handler.gd) — call `update()` after solid-cell edits; rebake `NavigationRegion2D` if using nav meshes.

### Relics, turns, fog, pacing
- Relic hooks / synergy tags: Resource subclasses + [weighted_loot_table.gd](../scripts/genre_roguelike_weighted_loot_table.gd); inventory peer `godot-inventory-system`.
- Turns: [turn_manager_decoupled.gd](../scripts/genre_roguelike_turn_manager_decoupled.gd) + [move_command_object.gd](../scripts/genre_roguelike_move_command_object.gd).
- Fog / LOS: [fog_of_war_masker.gd](../scripts/genre_roguelike_fog_of_war_masker.gd), [fov_raycast_calculator.gd](../scripts/genre_roguelike_fov_raycast_calculator.gd).
- Director pacing: frame-slice with `Engine.get_process_frames() % N` (see NEVER); keep heuristics out of every-frame `_process` work.

## Common Pitfalls

1.  **RNG Dependency**: Don't make runs entirely dependent on luck. Good roguelikes allow skill to mitigate bad RNG.
2.  **Meta-progression Imbalance**: If meta-upgrades are too strong, the game becomes a "grind to win" rather than "learn to win".
3.  **Lack of Variety**: Procedural generation is only as good as the content it arranges. You need *a lot* of content (rooms, enemies, items) to keep it fresh.
4.  **Save Scumming**: Players will try to quit to avoid death. Save the state only on floor transition or quit, and delete the save on load (optional, but standard for strict roguelikes).

## Godot-Specific Tips

-   **Seeded Runs**: Always initialize `RandomNumberGenerator` with a seed. This allows players to share specific run layouts.
-   **ResourceSaver**: Use `ResourceSaver` for meta-progression, but be careful with cyclical references in deeply nested resources.
-   **Scenes as Rooms**: Build your "rooms" as separate scenes (`Room1.tscn`, `Room2.tscn`) and instance them into the generated layout for handcrafted quality within procedural layouts.
-   **Navigation**: Rebake `NavigationRegion2D` at runtime after generating the dungeon layout if using 2D navigation.

## Advanced Techniques

-   **Synergy System**: Tag items (`fire`, `projectile`, `companion`) and check for tag combinations to create emergent power-ups.
-   **Director AI**: An invisible "Director" system that tracks player health/stress and adjusts spawn rates dynamically (like *Left 4 Dead*).


## Reference

> Progressive disclosure: open Official Documentation links only when researching a specific API; load Related Skills when routing to a peer domain — do not preload the whole lattice.

### Official Documentation
- [Using TileMaps](https://docs.godotengine.org/en/stable/tutorials/2d/using_tilemaps.html) — TileMapLayer cells, sources, and runtime placement for procedural floors/walls.
- [TileMapLayer](https://docs.godotengine.org/en/stable/classes/class_tilemaplayer.html) — `set_cell` / `get_used_cells` APIs used after walker/BSP generation and fog clears.
- [AStarGrid2D](https://docs.godotengine.org/en/stable/classes/class_astargrid2d.html) — grid pathfinding with heuristics, diagonal modes, and `update()` after solid-cell edits.
- [RandomNumberGenerator](https://docs.godotengine.org/en/stable/classes/class_randomnumbergenerator.html) — seeded PCG32 for shareable runs; prefer local instances over global `randi()`.
- [WorkerThreadPool](https://docs.godotengine.org/en/stable/classes/class_workerthreadpool.html) — offload heavy dungeon generation without freezing the main thread.
- [Using multiple threads](https://docs.godotengine.org/en/stable/tutorials/performance/using_multiple_threads.html) — when WorkerThreadPool/tasks are safe versus SceneTree ownership rules.
- [Thread-safe APIs](https://docs.godotengine.org/en/stable/tutorials/performance/thread_safe_apis.html) — generate data off-thread, then apply tiles/nodes on the main thread only.
- [Saving games](https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html) — `user://` persistence patterns for meta unlocks and anti-scum mid-run deletes.
- [Resources](https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html) — Resource-backed meta/run data, `duplicate(true)`, and save/load of `.tres`/custom resources.
- [Singletons (AutoLoad)](https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html) — isolate RunManager vs MetaManager so run death cannot wipe permanent progress.
- [Ray-casting](https://docs.godotengine.org/en/stable/tutorials/physics/ray-casting.html) — PhysicsDirectSpaceState queries for FOV / line-of-sight without Area2D spam.
- [FastNoiseLite](https://docs.godotengine.org/en/stable/classes/class_fastnoiselite.html) — noise fields for cave-style maps before connectivity validation with AStarGrid2D.

### Related Skills

#### Prerequisites
- [godot-project-foundations](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md) — project layout, Autoloads, and Resource basics before run/meta split.
- [godot-tilemap-mastery](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-tilemap-mastery/SKILL.md) — TileMapLayer authorship and runtime cell edits that procedural generators write into.
- [godot-resource-data-patterns](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md) — Resource duplication, typed data, and save-friendly schemas for relics/meta stats.
- [godot-autoload-architecture](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-autoload-architecture/SKILL.md) — singleton boundaries so Run state resets cleanly without touching Meta state.

#### Complements
- [godot-procedural-generation](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-procedural-generation/SKILL.md) — deeper Walker/BSP/WFC generators that feed this genre's dungeon loop.
- [godot-navigation-pathfinding](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-navigation-pathfinding/SKILL.md) — NavigationRegion rebake and agent pathing when not using pure AStarGrid2D.
- [godot-combat-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-combat-system/SKILL.md) — hit/hurt pipelines and turn-paced encounters inside generated floors.
- [godot-inventory-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-inventory-system/SKILL.md) — run bags, relic slots, and item Resources consumed by loot tables.
- [godot-save-load-systems](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-save-load-systems/SKILL.md) — JSON/binary persistence, floor-transition saves, and permadeath delete-on-load.
- [godot-signal-architecture](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md) — decoupled turn/floor/run signals without SceneTree as grid source of truth.
- [godot-performance-optimization](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md) — thread pools, fog GPU masks, and frame-sliced director heuristics at scale.

#### Downstream / consumers
- [godot-monte-carlo-balancer](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md) — simulate win% vs meta level, pity timers, and dead-item detection across seeded runs.
- [godot-genre-action-rpg](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-action-rpg/SKILL.md) — action-RPG combat/progression layers that often consume roguelike run/meta patterns.

#### Master
- [godot-master](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-master/SKILL.md) — library router and mirrored module entry for cross-skill discovery.
