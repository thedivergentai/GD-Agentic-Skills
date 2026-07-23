---
name: godot-game-loop-harvest
description: "Data-driven resource harvesting (mining, logging, foraging) for Godot 4: apply_hit tool/tier validation via HarvestToolData enums, HarvestResourceData yields, harvestable_node shake/deplete, respawn_manager world persistence, UNIX offline progress, autosave, and noise vein proc-gen. Trigger keywords: apply_hit, HarvestResourceData, HarvestToolData, offline UNIX, respawn_manager, tool tier, harvestable_node, FastNoiseLite veins."
---

## Godot 4.7 Baseline

- Expert patterns in this skill target **Godot 4.7+** (stable, 2026-06-18).
- Consult the [Godot 4.7 migration guide](https://docs.godotengine.org/en/4.7/tutorials/migrating/upgrading_to_godot_4.7.html) when upgrading projects from 4.6.
- **NEVER** assume 4.6 defaults (stretch mode, audio area_mask, RichTextLabel percent flags) without checking 4.7 migration notes.

# Godot Game Loop: Harvest

Decoupled, data-driven gathering: tool/tier gates, health depletion, yields, respawn, and offline UNIX progress.

## Script Catalog (MANDATORY by path)

| Path | MANDATORY reads |
|---|---|
| **Hit / gather** | [harvestable_node.gd](../scripts/game_loop_harvest_harvestable_node.gd), [resource_data.gd](../scripts/game_loop_harvest_resource_data.gd), [harvest_tool_data.gd](../scripts/game_loop_harvest_harvest_tool_data.gd) |
| **Offline / autosave** | [harvest_loop_patterns.gd](../scripts/game_loop_harvest_harvest_loop_patterns.gd), [harvest_autosave_manager.gd](../scripts/game_loop_harvest_harvest_autosave_manager.gd), [harvest_inventory_manager.gd](../scripts/game_loop_harvest_harvest_inventory_manager.gd) |
| **Vein / respawn / world** | [harvest_respawn_manager.gd](../scripts/game_loop_harvest_harvest_respawn_manager.gd) + `FastNoiseLite` vein notes below |

## Setup (short)

1. Author `HarvestResourceData` / `HarvestToolData` `.tres` (tool **enum** + tier, yield range, optional drop scene).
2. Attach `harvestable_node.gd` to `StaticBody3D`; assign data + `mesh_to_shake`; keep interaction on **Layer 1**.
3. Autoload `harvest_respawn_manager.gd` as `HarvestRespawnManager` when world persistence is required.

## Hit path

Raycast/interact → `apply_hit(tool_data: HarvestToolData)`:

```gdscript
if collider is HarvestableNode:
    collider.apply_hit(player_tool)
```

| Signal | Payload | Wire to |
|---|---|---|
| `harvested` | `(data, amount)` | Inventory / `harvest_inventory_manager` |
| `took_damage` | `(curr, max)` | HUD bar / popup pool |
| `interaction_failed` | `(reason: StringName)` | `"wrong_tool"` / `"low_tier"` feedback |

## NEVER Do

- **NEVER use float for accumulated harvest counts** — use `int`.
- **NEVER gather rates in `_process` without `delta`** — framerate-scales economy.
- **NEVER trust `OS.get_ticks_msec()` for offline progress** — use `Time.get_unix_time_from_system()`.
- **NEVER check tool type via free-form strings** — use `HarvestToolData.ToolType` / `StringName` enums (see scripts).
- **NEVER mutate shared Resource templates** — `duplicate(true)` before runtime durability/health mutation.
- **NEVER `queue_free()` before VFX/SFX finish** — hide mesh, swap collision layer, free after juice.
- **NEVER skip saving UNIX timestamp on exit** — offline gains depend on it.
- **NEVER couple harvest logic to UI counters** — signals only.
- **NEVER scale collision shapes non-uniformly** — edit shape resource sizes.

## Vein proc-gen (noise)

Use `FastNoiseLite` thresholds for organic clusters; spawn `HarvestableNode` instances where `noise.get_noise_2dv(pos) > threshold`. Persist depleted IDs via respawn manager — do not re-roll veins every load without a seed.

## Tool durability

Keep durability on `HarvestToolData` (Resource), not the player node. Emit durability/break signals from the tool Resource after successful hits.

## Reference

> **Progressive disclosure:** Skim Official Documentation only for the APIs you are implementing (Resources, StaticBody3D hits, signals, timers, save/offline time). Open Related Skills when wiring inventory, autoloads, raycasts, or economy balance—do not preload the whole lattice.

### Official Documentation
- [Resources](https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html) — Author `HarvestResourceData` / `HarvestToolData` as shareable `.tres` assets so designers tune health, yield ranges, and tool gates without editing harvest scripts.
- [Resource](https://docs.godotengine.org/en/stable/classes/class_resource.html) — Call `duplicate(true)` before mutating runtime harvest/tool state so one node’s depletion or durability cannot rewrite the shared template Resource.
- [GDScript exports](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_exports.html) — `@export` / `@export_group` power Inspector-authored tool tiers, yield ranges, respawn times, and drop scenes on harvest data Resources.
- [Using signals](https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html) — Emit `harvested`, `took_damage`, and `interaction_failed` so inventory, HUD bars, and feedback UI subscribe without coupling to `HarvestableNode` internals.
- [StaticBody3D](https://docs.godotengine.org/en/stable/classes/class_staticbody3d.html) — World harvestables are static colliders players query/hit; keep them on an interaction layer and move to an inactive layer while depleted.
- [Collision shapes (3D)](https://docs.godotengine.org/en/stable/tutorials/physics/collision_shapes_3d.html) — Size shape resources directly; non-uniform scale on collision shapes breaks hit tests for pickaxes/axes against trees and ore nodes.
- [Idle and Physics Processing](https://docs.godotengine.org/en/stable/tutorials/scripting/idle_and_physics_processing.html) — Multiply continuous gather rates by `delta` (prefer `_physics_process` for fixed-step economy ticks) so harvest speed is not framerate-dependent.
- [Time](https://docs.godotengine.org/en/stable/classes/class_time.html) — Persist `Time.get_unix_time_from_system()` for offline gains; do not use `OS.get_ticks_msec()` / uptime for real-world absence math.
- [Saving games](https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html) — Persist inventory counts, depleted-node IDs, and absolute respawn/offline timestamps with the rest of progression data.
- [FileAccess](https://docs.godotengine.org/en/stable/classes/class_fileaccess.html) — Interval autosave writes JSON (or binary) under `user://` via `FileAccess.open` so harvest progress survives crashes between manual saves.
- [Tween](https://docs.godotengine.org/en/stable/classes/class_tween.html) — Hit “juice” shakes use short property tweens on the mesh child without allocating disposable animation players per strike.
- [Singletons (Autoload)](https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html) — Register `HarvestRespawnManager` as an Autoload so scattered harvestables resolve `/root/HarvestRespawnManager` for world-scale depletion persistence.

### Related Skills

#### Prerequisites
- [godot-resource-data-patterns](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md) — Harvest yields, tool stats, and drop scenes are Resource-first; establish composition/duplicate rules before baking economy numbers into nodes.
- [godot-signal-architecture](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md) — `harvested` / `inventory_updated` ownership and safe connects keep gather nodes decoupled from HUD and inventory hubs.
- [godot-physics-3d](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-physics-3d/SKILL.md) — `StaticBody3D` layers/masks and shape setup for interactable world props are prerequisites to reliable hit validation.
- [godot-gdscript-mastery](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md) — Typed Resources, `await` on `create_timer`, and Mutex/`WorkerThreadPool` patterns assume solid GDScript fundamentals.

#### Complements
- [godot-inventory-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-inventory-system/SKILL.md) — Connect `harvested` into a real inventory/stacking pipeline instead of leaving counts in a harvest-only dictionary.
- [godot-save-load-systems](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-save-load-systems/SKILL.md) — Round-trip warehouse totals, tool durability, and depleted-node timers through the project save schema beyond interval JSON dumps.
- [godot-autoload-architecture](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-autoload-architecture/SKILL.md) — Respawn and inventory managers belong in a disciplined Autoload graph with clear init order and signal-bus boundaries.
- [godot-raycasting-queries](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-raycasting-queries/SKILL.md) — Player gather input typically raycasts or shapecasts to the harvestable collider before calling `apply_hit(tool_data)`.
- [godot-tweening](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-tweening/SKILL.md) — Expand hit shakes into polish tweens (squash, flash, camera punch) without cutting VFX short via early `queue_free()`.
- [godot-economy-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-economy-system/SKILL.md) — Wire harvest yields into sinks, crafting costs, and vendor loops so gathering feeds a coherent economy.

#### Downstream / consumers
- [godot-monte-carlo-balancer](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md) — After yields, respawn times, and tool tiers are tunable Resources, Monte Carlo sims validate gather pacing and sink pressure before shipping curves.
- [godot-genre-survival](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-survival/SKILL.md) — Survival loops compose harvesting with hunger, crafting, and world threat systems on top of this gather core.
- [godot-game-loop-collection](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-game-loop-collection/SKILL.md) — Collection/scavenger objectives often consume the same harvest/inventory signals for “gather N of X” quests.
- [godot-procedural-generation](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-procedural-generation/SKILL.md) — Noise-driven resource veins and world placement build on harvest node data once the interaction loop is solid.

#### Master
- [godot-master](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-master/SKILL.md) — Library router and mirrored module entry; use when discovering peer skills or syncing shared script mirrors after Domain Skill edits.
