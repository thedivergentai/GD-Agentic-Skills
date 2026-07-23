---
name: godot-game-loop-collection
description: "Expert collection-loop systems for collectible IDs, scavenger hunts, completion archives, nearest-item compass UI, hidden spawners, and persistent find-all-X progress. Use when implementing collectibles, scavenger hunts, completion% archives, or compass-guided item hunts. Keywords: collectible_id, scavenger_hunt, collection_manager, collection_compass, completion_archive, hidden_item_spawner, find_all, collectible_item."
---

## Godot 4.7 Baseline

- Expert patterns in this skill target **Godot 4.7+** (stable, 2026-06-18).
- Consult the [Godot 4.7 migration guide](https://docs.godotengine.org/en/4.7/tutorials/migrating/upgrading_to_godot_4.7.html) when upgrading projects from 4.6.
- **NEVER** assume 4.6 defaults (stretch mode, audio area_mask, RichTextLabel percent flags) without checking 4.7 migration notes.

# Collection Game Loops

Stable collectible IDs → manager → compass → save. Not generic game-loop boilerplate.

## NEVER Do (collection landmines)

- **NEVER reuse or omit stable collectible IDs** — Duplicate IDs double-count or overwrite; missing IDs break completion % and saves.
- **NEVER count the same Area overlap twice** — `body_entered` can re-fire on re-entry; gate with "already collected" / one-shot disable of monitoring.
- **NEVER persist NodePaths as the identity of collectibles** — Paths break on scene moves; save **IDs** (StringName / int), not `get_path()`.
- **NEVER soft-lock the last item** — If compass / spawn logic depends on "remaining > 1", the final pickup becomes unfindable.
- **NEVER store hunt progress only in scene-local nodes** — Level reload wipes progress; keep collected set in [collection_manager.gd](../scripts/game_loop_collection_collection_manager.gd) + save.
- **NEVER `queue_free()` collectibles with zero juice and no ID commit** — Commit ID first (signal), then VFX, then free.
- **NEVER scale collectible collision shapes non-uniformly** — Breaks overlap math; edit shape resources.
- **NEVER hardcode spawn positions in code** — Use Marker3D / designer points with [hidden_item_spawner.gd](../scripts/game_loop_collection_hidden_item_spawner.gd).
- **NEVER drive collection truth from UI silhouettes** — Archive UI mirrors manager state; manager is authoritative.

---

## Golden Path (MANDATORY)

1. [collectible_item.gd](../scripts/game_loop_collection_collectible_item.gd) — `item_id` (unique) + `collection_id` (hunt), one-shot Area pickup
2. [collection_manager.gd](../scripts/game_loop_collection_collection_manager.gd) — authoritative collected-ID set via `register_item()` + `get_remaining_ids()`
3. [collection_compass.gd](../scripts/game_loop_collection_collection_compass.gd) — nearest node whose `item_id` is still in manager remainders
4. Persist collected IDs via [godot-save-load-systems](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-save-load-systems/SKILL.md)

Optional: [hidden_item_spawner.gd](../scripts/game_loop_collection_hidden_item_spawner.gd) for randomized hunts; [collection_loop_patterns.gd](../scripts/game_loop_collection_collection_loop_patterns.gd) for advanced loop/MainLoop helpers.

## Available Scripts (full set)

- [collectible_item.gd](../scripts/game_loop_collection_collectible_item.gd) — **MANDATORY** pickup actor; export stable `item_id` per instance and hunt `collection_id`
- [collection_manager.gd](../scripts/game_loop_collection_collection_manager.gd) — **MANDATORY** progress brain; `start_collection(id, item_ids)` then `register_item(id, item_id)`
- [collection_compass.gd](../scripts/game_loop_collection_collection_compass.gd) — **MANDATORY** when guiding players; wire `collection_manager` and query `get_remaining_ids()`
- [hidden_item_spawner.gd](../scripts/game_loop_collection_hidden_item_spawner.gd) — designer markers / chance spawns (Do NOT Load for fixed placed-only hunts)
- [collection_loop_patterns.gd](../scripts/game_loop_collection_collection_loop_patterns.gd) — advanced loop patterns (Do NOT Load for simple ID hunts)

## Expert Collection Patterns

### 1. Persistent Collection (Save/Load)
Serialize the manager’s collected `item_id` set per `collection_id` (`PackedStringArray` via `get_collected_ids()` / `restore_collected_ids()`), not node paths. Reload: manager restores set → collectibles self-disable if `item_id` already owned.

### 2. Collection Archive UI (Silhouettes)
Grid of icons: uncollected `modulate` silhouette; reveal when manager signals that ID. UI never invents collected state.

## Reference

> Progressive disclosure: open Official Documentation links only when researching a specific API; load Related Skills when routing to a peer domain — do not preload the whole lattice.

### Official Documentation
- [Area3D](https://docs.godotengine.org/en/stable/classes/class_area3d.html) — `body_entered` pickup volumes for 3D collectibles and layer/mask setup so only the player triggers collection.
- [Using Area2D](https://docs.godotengine.org/en/stable/tutorials/physics/using_area_2d.html) — 2D overlap patterns when adapting the same collectible loop to Area2D/Sprite2D radar UIs.
- [Groups](https://docs.godotengine.org/en/stable/tutorials/scripting/groups.html) — register collectibles and broadcast resets via `get_nodes_in_group` / `call_group` without hard-coded node paths.
- [Idle and physics processing](https://docs.godotengine.org/en/stable/tutorials/scripting/idle_and_physics_processing.html) — keep collision-driven progress in `_physics_process` / physics frames; throttle compass/UI work in `_process`.
- [SceneTree](https://docs.godotengine.org/en/stable/classes/class_scenetree.html) — pause flags, groups, `physics_frame`, and `current_scene` ownership used by collection state transitions.
- [Change scenes manually](https://docs.godotengine.org/en/stable/tutorials/scripting/change_scenes_manually.html) — deferred free + instantiate handoff when finishing a hunt and loading the next level.
- [Background loading](https://docs.godotengine.org/en/stable/tutorials/io/background_loading.html) — `ResourceLoader.load_threaded_request` / status polling so large collectible levels do not hitch the main thread.
- [Saving games](https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html) — persist collected IDs and progress dictionaries with `FileAccess` under `user://`.
- [Vector math](https://docs.godotengine.org/en/stable/tutorials/math/vector_math.html) — `direction_to` / `get_angle_to` for nearest-collectible compass pointing.
- [Marker3D](https://docs.godotengine.org/en/stable/classes/class_marker3d.html) — designer-placed spawn anchors for hidden-item hunts instead of hard-coded coordinates.
- [Using signals](https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html) — typed `item_collected` / `collection_updated` wiring from pickups into the manager and UI.
- [MainLoop](https://docs.godotengine.org/en/stable/classes/class_mainloop.html) — custom loop extension surface referenced by advanced collection_loop_patterns (rarely needed over SceneTree).

### Related Skills

#### Prerequisites
- [godot-project-foundations](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md) — scene tree, `@onready`, and resource basics before wiring managers, markers, and collectible scenes.
- [godot-gdscript-mastery](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md) — typed signals, `match`, `await`, and deferred calls used throughout collection managers and loop patterns.
- [godot-physics-3d](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-physics-3d/SKILL.md) — Area3D/CollisionShape3D layers and non-uniform scale pitfalls that break pickup detection.

#### Complements
- [godot-signal-architecture](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md) — safe dynamic connections and event-bus patterns when many collectibles notify one manager.
- [godot-scene-management](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-scene-management/SKILL.md) — threaded scene swaps and ownership rules for end-of-hunt level transitions.
- [godot-save-load-systems](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-save-load-systems/SKILL.md) — durable save schemas for which items remain collected across sessions.
- [godot-ui-containers](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md) — silhouette archive grids and progress HUD layouts driven by `collection_updated`.
- [godot-particles](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-particles/SKILL.md) — spawn juice VFX before `queue_free` so pickups feel responsive.
- [godot-audio-systems](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-audio-systems/SKILL.md) — one-shot pickup SFX and bus routing tied to collect events.
- [godot-monte-carlo-balancer](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md) — tune spawn_chance, target counts, and hunt length against completion-time distributions.

#### Downstream / consumers
- [godot-quest-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-quest-system/SKILL.md) — wraps collection progress as quest objectives with rewards and branching.
- [godot-inventory-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-inventory-system/SKILL.md) — turns collected pickups into inventory grants when items are kept rather than consumed.
- [godot-theme-easter](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-theme-easter/SKILL.md) — seasonal egg-hunt presentation layered on the same collection loop.

#### Master
- [godot-master](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-master/SKILL.md) — library router and mirrored module entry for cross-skill discovery.
