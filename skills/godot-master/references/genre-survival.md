---
name: godot-genre-survival
description: "Expert blueprint for survival games (Minecraft, Don't Starve, The Forest, Rust) covering needs systems, resource gathering, crafting recipes, base building, and progression balancing. Use when building open-world survival, crafting-focused, or resource management games. Keywords survival, needs system, crafting, inventory, hunger, resource gathering, base building."
---

## Godot 4.7 Baseline

- Expert patterns in this skill target **Godot 4.7+** (stable, 2026-06-18).
- Consult the [Godot 4.7 migration guide](https://docs.godotengine.org/en/4.7/tutorials/migrating/upgrading_to_godot_4.7.html) when upgrading projects from 4.6.
- **NEVER** assume 4.6 defaults (stretch mode, audio area_mask, RichTextLabel percent flags) without checking 4.7 migration notes.

# Genre: Survival

Resource scarcity, needs management, and progression through crafting define survival games.

## NEVER Do (Expert Anti-Patterns)

### Physiology & Needs
- NEVER use constant "Needs" decay; strictly scale with activity (e.g., **Sprinting** drains hunger 3x faster than idling).
- NEVER use Instant Death for starvation/dehydration; strictly trigger gradual HP drain and provide distinct visual/audio warnings.
- NEVER use float timers for exact life-critical checks; strictly use `is_equal_approx()` or `<=` to prevent 0.0 precision misses.
- NEVER represent world time/day cycles within UI scripts; strictly use an **AutoLoad (Singleton)** to decouple state from visuals.

### Gathering & Inventory
- NEVER make gathering tedious without progression; strictly implement **Tiered Tool Scaling** (e.g., Stone Axe = 1 wood/hit, Steel Axe = 5 wood/hit) to reward technical advancement.
- NEVER allow infinite inventory stacking; strictly use **Weight Capacity** or strict **Stack Limits** (e.g., 64 items) to force strategic resource management.
- NEVER force players to "Guess" crafting recipes; strictly use a **Discovery System** where recipes unlock upon acquiring materials.
- NEVER forget to **duplicate(true)** a shared Resource (like Item Durability); otherwise, all instances will break simultaneously.
- NEVER store heavy item/crafting definitions in Node properties; strictly use custom **Resource** containers for lightweight data.

### World & Performance
- NEVER spawn threats at Respawn Points; strictly enforce a **Safe Zone radius** (Beds/Spawn) where enemy spawning is prohibited.
- NEVER instance 10,000 individual `MeshInstance3D` nodes for foliage; strictly use **MultiMeshInstance3D** for batched draw calls.
- NEVER load massive world chunks synchronously; strictly use `ResourceLoader.load_threaded_request()` to prevent hitches.
- NEVER save complex dictionaries to standard text files; strictly use binary serialization for speed and size efficiency.
- NEVER run procedural terrain/noise algorithms on the main thread; strictly offload to the **WorkerThreadPool**.
- NEVER hardcode massive crafting tables in GDScript; strictly use `ConfigFile` or JSON for easy balancing and modding.

---

## Expert Components (scripts/)

> **MANDATORY**: Prefer these scripts over inline stubs. Do not paste `pass` architectures into scenes.

### [survival_patterns.gd](../scripts/genre_survival_survival_patterns.gd)
**MANDATORY first read** — Activity-scaled vitals, MultiMesh populate, threaded chunk load, WorkerThreadPool noise chunks (`generate_noise_chunk_async`), GridMap snap/place, Persist collect, deep `duplicate(true)`.

### [status_depletion_manager.gd](../scripts/genre_survival_status_depletion_manager.gd)
**MANDATORY for needs** — Activity-scaled hunger/thirst in `_physics_process` (aligns with NEVER: no constant decay).

### [inventory_data.gd](../scripts/genre_survival_inventory_data.gd)
Core Resource-based grid inventory: stack limits, metadata, add/remove.

### [inventory_slot_data.gd](../scripts/genre_survival_inventory_slot_data.gd)
Lightweight UI↔logic slot DTO.

### [inventory_slot_resource.gd](../scripts/genre_survival_inventory_slot_resource.gd)
Serializable slot Resource with durability tracking.

### [modular_inventory_controller.gd](../scripts/genre_survival_modular_inventory_controller.gd)
Controller wiring inventory data to UI signals.

### [interactable.gd](../scripts/genre_survival_interactable.gd)
Universal harvest / pickup / world-trigger interface.

### [crafting_recipe_processor.gd](../scripts/genre_survival_crafting_recipe_processor.gd)
Ingredient check → consume → grant result (discovery-friendly).

---

## Decision Tree — Survival Systems

| Need | Route |
|------|-------|
| Item / recipe / durability data | Custom **Resource** + [inventory_slot_resource.gd](../scripts/genre_survival_inventory_slot_resource.gd) |
| Bag / stack / weight | [inventory_data.gd](../scripts/genre_survival_inventory_data.gd) + [modular_inventory_controller.gd](../scripts/genre_survival_modular_inventory_controller.gd) — weight caps / drag-drop UI → **godot-inventory-system** (Do NOT re-teach grid UI here) |
| Hunger / thirst | [status_depletion_manager.gd](../scripts/genre_survival_status_depletion_manager.gd) — set `sprinting` from movement |
| Harvest / open / pickup | [interactable.gd](../scripts/genre_survival_interactable.gd) |
| Craft | [crafting_recipe_processor.gd](../scripts/genre_survival_crafting_recipe_processor.gd) |
| Base build snap | [survival_patterns.gd](../scripts/genre_survival_survival_patterns.gd) `place_if_empty` / GridMap |
| Forest foliage | MultiMesh via `populate_nature` — never 10k MeshInstance3D |
| Chunk stream | `load_world_chunk` threaded path in survival_patterns |
| Procedural noise / biomes at scale | `generate_noise_chunk_async` in survival_patterns — or **MANDATORY** [godot-procedural-generation](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-procedural-generation/SKILL.md) when terrain exceeds chunk helpers |

| Phase | Peer skills | Purpose |
|-------|-------------|---------|
| 1. Data | godot-resource-data-patterns | Item/recipe Resources |
| 2. UI | godot-ui-containers, godot-inventory-system | Grid + drag/drop |
| 3. World | godot-procedural-generation, godot-3d-world-building | Noise, GridMap |
| 4. Logic | godot-signal-architecture, godot-state-machine-advanced | Needs + interaction |
| 5. Save | godot-save-load-systems | World + inventory + recipes |

## Key Mechanics (pointers, not tutorials)

### Needs (activity-scaled)
Wire movement → `StatusDepletionManager.sprinting`. Empty vitals → gradual HP drain + warnings (never instant death). See script — do not reintroduce constant `decay_rate` in `_process`.

### Tiered Tool Scaling
Stone Axe 1 yield / Steel Axe 5 yield / proximity Auto-Saw — encode as item Resource metadata, not hardcoded harvest scripts.

### Spawn Safe Zones
Re-roll spawn points outside bed/`player_beds` radius before enabling threat spawners.

## Godot-Specific Tips

* **TileMapLayer** (Godot 4) for 2D worlds — do not use Godot 3 `TileMap` APIs.
* **FastNoiseLite** for biome/resource density (off main thread via WorkerThreadPool for heavy maps).
* **ResourceSaver** / binary serialization for large inventories and chunk dicts.
* **Y-Sort** for top-down 2D occlusion with trees/props.

## Common Pitfalls

1. **Tedium** — Scale gather yield with tool tier.
2. **Inventory clutter** — Generous stacks + storage sinks.
3. **No goals** — Tech tree / boss pressure beyond pure survive.

---

## Elite Technical Implementations

> **MANDATORY** when starting base-building snap or biome/noise work: read [survival-elite-implementations.md](genre-survival-survival-elite-implementations.md). **Do NOT Load** for first-pass needs/inventory/crafting — use the script catalog above.

## Reference

> Progressive disclosure: open Official Documentation links only when researching a specific API; load Related Skills when routing to a peer domain — do not preload the whole lattice.

### Official Documentation
- [Resources](https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html) — Item definitions, recipe tables, and inventory slots belong as Resources so designers retune weight, stack limits, and durability without code changes.
- [Idle and physics processing](https://docs.godotengine.org/en/stable/tutorials/scripting/idle_and_physics_processing.html) — Hunger/thirst decay must multiply by `delta` in `_physics_process` (or `_process`) so vital drain stays frame-rate independent.
- [Singletons (Autoload)](https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html) — World time, day/night, and global needs state belong in Autoloads so UI scripts never own the clock.
- [Using signals](https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html) — Inventory and crafting should emit change signals so HUD grids update without polling every frame.
- [Saving games](https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html) — Persist inventory, unlocked recipes, base GridMap cells, and player vitals across sessions.
- [Binary serialization API](https://docs.godotengine.org/en/stable/tutorials/io/binary_serialization_api.html) — Large world/chunk dictionaries should use binary packs instead of bulky text dumps.
- [Background loading](https://docs.godotengine.org/en/stable/tutorials/io/background_loading.html) — Stream world chunks with `ResourceLoader.load_threaded_request()` to avoid hitching while exploring.
- [Using GridMaps](https://docs.godotengine.org/en/stable/tutorials/3d/using_gridmaps.html) — Base-building snaps and octant-batched structure pieces use `GridMap.local_to_map` / `set_cell_item`.
- [Using MultiMesh](https://docs.godotengine.org/en/stable/tutorials/performance/using_multimesh.html) — Forests, rocks, and harvestable foliage must batch via MultiMesh instead of thousands of MeshInstance3D nodes.
- [Using multiple threads](https://docs.godotengine.org/en/stable/tutorials/performance/using_multiple_threads.html) — Procedural noise/terrain generation belongs on WorkerThreadPool, never the main thread.
- [FastNoiseLite](https://docs.godotengine.org/en/stable/classes/class_fastnoiselite.html) — Biome and resource density maps sample FastNoiseLite gradients for organic world layout.
- [AStarGrid2D](https://docs.godotengine.org/en/stable/classes/class_astargrid2d.html) — When players place structures, mark cells solid so AI reroutes around new bases immediately.

### Related Skills

#### Prerequisites
- [godot-gdscript-mastery](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md) — `is_equal_approx`, Resource `duplicate(true)`, and delta-scaled timers are foundational before vital and inventory logic.
- [godot-resource-data-patterns](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md) — Items, recipes, and slot payloads must be Resource-first so durability and stack metadata serialize cleanly.
- [godot-signal-architecture](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md) — Inventory/crafting buses should signal UI and interaction systems without tight Node coupling.
- [godot-autoload-architecture](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-autoload-architecture/SKILL.md) — Day cycles and global needs managers that survive scene swaps follow Autoload ownership rules.

#### Complements
- [godot-inventory-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-inventory-system/SKILL.md) — Grid stacking, weight capacity, and drag/drop UIs deepen the survival bag beyond genre sketches.
- [godot-save-load-systems](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-save-load-systems/SKILL.md) — Versioned world saves cover inventory Resources, base cells, and unlocked recipe lists.
- [godot-procedural-generation](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-procedural-generation/SKILL.md) — Noise biomes and resource scatter compose with FastNoiseLite patterns in this skill.
- [godot-3d-world-building](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-world-building/SKILL.md) — GridMap tooling, collision, and LOD practices support large player-built bases.
- [godot-ai-navigation](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ai-navigation/SKILL.md) — Threat AI that respects built walls needs NavigationAgent / AStar updates when structures change.
- [godot-ui-containers](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md) — Crafting menus and inventory grids are Control layout problems, not gameplay scripts.
- [godot-game-loop-harvest](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-game-loop-harvest/SKILL.md) — Tiered tool yield and gather loops share harvest-loop patterns with survival gathering.

#### Downstream / consumers
- [godot-monte-carlo-balancer](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md) — After recipe costs, tool tiers, and need decay rates are data-driven, Monte Carlo careers prove hours-to-tech and starvation risk bands before shipping balance sheets.
- [godot-genre-open-world](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-open-world/SKILL.md) — Open-world survival consumes chunk streaming, safe-zone spawn, and scarcity loops defined here.
- [godot-economy-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-economy-system/SKILL.md) — Trading posts and crafted-good sinks extend survival crafting into soft-currency economies.

#### Master
- [godot-master](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-master/SKILL.md) — Library router and mirrored module entry; use when discovering peer skills or syncing shared script mirrors after Domain Skill edits.
