---
name: godot-genre-metroidvania
description: "Expert blueprint for Metroidvanias including ability-gated exploration (locks/keys), interconnected world design (backtracking with shortcuts), persistent state tracking (collectibles, boss defeats), room transitions (seamless loading), map systems (grid-based revelation), and ability versatility (combat + traversal). Use for exploration platformers or action-adventure games. Trigger keywords: metroidvania, ability_gating, interconnected_world, backtracking, map_system, persistent_state, room_transition, soft_locks."
---

## Godot 4.7 Baseline

- Expert patterns in this skill target **Godot 4.7+** (stable, 2026-06-18).
- Consult the [Godot 4.7 migration guide](https://docs.godotengine.org/en/4.7/tutorials/migrating/upgrading_to_godot_4.7.html) when upgrading projects from 4.6.
- **NEVER** assume 4.6 defaults (stretch mode, audio area_mask, RichTextLabel percent flags) without checking 4.7 migration notes.

# Genre: Metroidvania

Expert blueprint for Metroidvanias balancing exploration, progression, and backtracking rewards.

## NEVER Do (Expert Anti-Patterns)

### World Design & Exploration
- NEVER allow "Soft-Locks" where a player is trapped; if they enter via a one-way path ("valve"), they MUST be able to leave using current abilities. Always design **fail-safe escape routes**.
- NEVER create empty dead ends; if a player backtracks to a remote area, they MUST be rewarded with a collectible, lore, or currency. Empty rooms are design failures.
- NEVER make backtracking purely repetitive; as the player gains movement (Dash/Teleport), traversal through old areas MUST become faster. **Open shortcuts** to bypass long, early routes.
- NEVER hide the critical path without "crumbs"; use distinct **Landmarks**, unique lighting, or environmental storytelling to build the player's mental map.
- NEVER design abilities that serve only one purpose; strictly implement dual-use traversal and combat functionality (e.g., a "Dash" that crosses gaps and dodges attacks).

### Persistence & Mapping
- NEVER forget to save **persistent room state**; if a player opens a chest or defeats a boss, that state MUST remain saved when they leave and return.
- NEVER load interconnected rooms synchronously via `load()`; strictly use `ResourceLoader.load_threaded_request()` for seamless transitions.
- NEVER track global progression within localized room scripts; strictly use **Autoload Singletons** for global ability flags and world state.
- NEVER use floating-point types for grid coordinates (minimaps/fog); strictly use `Vector2i` to prevent precision jitter.
- NEVER manipulate the SceneTree directly from a background loading thread; strictly use `call_deferred()`.

### Physics & Controls
- NEVER calculate jump arcs or dashes inside `_process()`; strictly use `_physics_process()` to prevent stutter.
- NEVER multiply `CharacterBody2D` velocity by `delta` before `move_and_slide()`; the engine handles this internally.
- NEVER poll `is_action_just_pressed()` inside `_physics_process()` for buffering; strictly capture events in `_unhandled_input()`.
- NEVER use standard strings for high-frequency ability checks; strictly use `StringName` (&"dashing") for pointer-speed comparisons.
- NEVER iterate through every node to broadcast updates; strictly use `SceneTree.call_group()` for efficient mass communication.
- NEVER delete active room/player nodes via `free()`; strictly use `queue_free()` to avoid segmentation faults.

---

## 🛠 Expert Components (scripts/)

### Golden-path order (MANDATORY reads)
1. Persistence / flags — [metroid_game_state.gd](../scripts/genre_metroidvania_metroid_game_state.gd) + [persistent_progression_system.gd](../scripts/genre_metroidvania_persistent_progression_system.gd)
2. Ability definitions / gates — [ability_unlock_resource.gd](../scripts/genre_metroidvania_ability_unlock_resource.gd) + [progression_gate_manager.gd](../scripts/genre_metroidvania_progression_gate_manager.gd)
3. Room stream / switch — [background_room_streamer.gd](../scripts/genre_metroidvania_background_room_streamer.gd) + [safe_scene_switcher.gd](../scripts/genre_metroidvania_safe_scene_switcher.gd)
4. Map fog — [minimap_fog_manager.gd](../scripts/genre_metroidvania_minimap_fog_manager.gd) (orchestrator) with [minimap_fog.gd](../scripts/genre_metroidvania_minimap_fog.gd) / [minimap_fog_revealer.gd](../scripts/genre_metroidvania_minimap_fog_revealer.gd)

### Original Expert Patterns
- [minimap_fog.gd](../scripts/genre_metroidvania_minimap_fog.gd) - Grid-based fog of war that tracks visited rooms and persists via global save data.
- [progression_gate_manager.gd](../scripts/genre_metroidvania_progression_gate_manager.gd) - Central manager for ability-gated progression (Locks/Keys) and world persistence.
- [metroid_game_state.gd](../scripts/genre_metroidvania_metroid_game_state.gd) - **MANDATORY** Autoload-shaped world/ability/collectible state (do not paste a local game_state tutorial).
- [ability_unlock_resource.gd](../scripts/genre_metroidvania_ability_unlock_resource.gd) - **MANDATORY** Resource definitions for unlockable abilities queried by gates.
- [minimap_fog_manager.gd](../scripts/genre_metroidvania_minimap_fog_manager.gd) - **MANDATORY** Vector2i fog orchestration synced to progression/save.

### Modular Components
- [platformer_jump_buffer.gd](../scripts/genre_metroidvania_platformer_jump_buffer.gd) - Modular coyote time and jump buffering for high-fidelity movement.
- [background_room_streamer.gd](../scripts/genre_metroidvania_background_room_streamer.gd) - Thread-safe background room preloading using `ResourceLoader`.
- [safe_scene_switcher.gd](../scripts/genre_metroidvania_safe_scene_switcher.gd) - Deferred scene transition pattern for stable cross-room world-state switching.
- [minimap_fog_revealer.gd](../scripts/genre_metroidvania_minimap_fog_revealer.gd) - Vector2i-based fog-of-war clearing logic synced to player position.
- [persistent_progression_system.gd](../scripts/genre_metroidvania_persistent_progression_system.gd) - Autoload pattern for tracking global ability/collectible flags.
- [ability_state_machine.gd](../scripts/genre_metroidvania_ability_state_machine.gd) - Optimized `StringName` pattern matching for traversal/combat states.
- [fast_wall_detector.gd](../scripts/genre_metroidvania_fast_wall_detector.gd) - Direct `PhysicsServer` queries for performance-optimized wall detection.
- [save_station_broadcast.gd](../scripts/genre_metroidvania_save_station_broadcast.gd) - Group-based entity resetting and healing logic on save interaction.
- [decoupled_hazard_logic.gd](../scripts/genre_metroidvania_decoupled_hazard_logic.gd) - Interface-style pattern for generic damage interaction.
- [smooth_room_camera_transition.gd](../scripts/genre_metroidvania_smooth_room_camera_transition.gd) - Tween-based camera limit interpolation for seamless room movement.

---

## Core Loop
1. **Exploration** → blocked by a lock
2. **Discovery** → key ability / boss
3. **Acquisition** → new traversal/combat tool
4. **Backtracking** → shortcuts + dual-use abilities
5. **Progression** → new biome opens

## Skill Chain

| Phase | Skills | Purpose |
|-------|--------|---------|
| 1. Character | `godot-characterbody-2d`, `godot-state-machine-advanced` | Tight movement + ability states |
| 2. World | `godot-tilemap-mastery`, `godot-scene-management` | Rooms, biomes, threaded transitions |
| 3. Systems | `godot-save-load-systems`, `godot-ability-system` | Persist gates/collectibles; unlock keys |
| 4. UI | `godot-ui-containers`, `godot-inventory-system` | Map / inventory / HUD |
| 5. Balance | `godot-monte-carlo-balancer` | Soft-lock risk, backtrack length |

---

## Architecture (script-first — no inline recipes)

### 1. Game State & Persistence
**MANDATORY**: [metroid_game_state.gd](../scripts/genre_metroidvania_metroid_game_state.gd) + [persistent_progression_system.gd](../scripts/genre_metroidvania_persistent_progression_system.gd). Rooms never own global ability flags. Room metadata uses `resource_local_to_scene` so instanced rooms do not share collectible state.

### 2. Room Transitions & Fast Travel
**MANDATORY**: [background_room_streamer.gd](../scripts/genre_metroidvania_background_room_streamer.gd) + [safe_scene_switcher.gd](../scripts/genre_metroidvania_safe_scene_switcher.gd).

Fast travel must match NEVER (threaded load + deferred swap) — never `ResourceLoader.load()` / sync `change_scene`:

```gdscript
class_name FastTravelSystem extends Node

var _pending_path: String = ""
var _spawn_id: StringName = &""

func travel_to_room(scene_path: String, spawn_id: StringName) -> void:
    _pending_path = scene_path
    _spawn_id = spawn_id
    var err := ResourceLoader.load_threaded_request(scene_path)
    if err != OK:
        push_error("Fast travel request failed: %s" % scene_path)
        return
    set_process(true)

func _process(_delta: float) -> void:
    var status := ResourceLoader.load_threaded_get_status(_pending_path)
    if status == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
        return
    set_process(false)
    if status != ResourceLoader.THREAD_LOAD_LOADED:
        push_error("Fast travel load failed: %s" % _pending_path)
        return
    var packed := ResourceLoader.load_threaded_get(_pending_path) as PackedScene
    # SceneTree work must be deferred — never from a worker thread
    call_deferred("_swap_room", packed, _spawn_id)

func _swap_room(packed: PackedScene, spawn_id: StringName) -> void:
    GlobalState.target_spawn_id = spawn_id
    get_tree().change_scene_to_packed(packed)
```

### 3. Ability Gating
**MANDATORY**: [ability_unlock_resource.gd](../scripts/genre_metroidvania_ability_unlock_resource.gd) + [progression_gate_manager.gd](../scripts/genre_metroidvania_progression_gate_manager.gd) + [ability_state_machine.gd](../scripts/genre_metroidvania_ability_state_machine.gd). Gates query StringName abilities from the Autoload — do not hardcode ability strings in room scripts.

### 4. Map / Fog
**MANDATORY**: [minimap_fog_manager.gd](../scripts/genre_metroidvania_minimap_fog_manager.gd). Use `Vector2i` cells only.

---

## Design Principles (from Dreamnoid)

- **Ability Versatility** — traversal + combat dual use
- **Practice Rooms** — teach before punish
- **Landmarks** — mental map without explicit markers
- **Item micro-stories** — lore without cutscene walls

## Common Pitfalls

1. Softlocks on one-way valves — always design an escape with current abilities
2. Backtracking tedium — shortcuts + faster movement after unlocks
3. Empty dead ends — every remote path needs a reward
4. Sync room loads — violates NEVER; use threaded request + deferred swap

## Reference

> Progressive disclosure: open Official Documentation links only when researching a specific API; load Related Skills when routing to a peer domain — do not preload the whole lattice.

### Official Documentation
- [Using CharacterBody2D](https://docs.godotengine.org/en/stable/tutorials/physics/using_character_body_2d.html) — `move_and_slide`, floor detection, and velocity rules for coyote/buffer jumps and dash traversal.
- [Idle and Physics Processing](https://docs.godotengine.org/en/stable/tutorials/scripting/idle_and_physics_processing.html) — keep jump arcs, dashes, and wall slides in `_physics_process`; capture buffers in input callbacks.
- [InputEvent](https://docs.godotengine.org/en/stable/tutorials/inputs/inputevent.html) — `_unhandled_input` jump/ability buffering so presses are not lost between physics ticks.
- [Background loading](https://docs.godotengine.org/en/stable/tutorials/io/background_loading.html) — `ResourceLoader.load_threaded_request` for adjacent-room preload without hitch spikes.
- [Change scenes manually](https://docs.godotengine.org/en/stable/tutorials/scripting/change_scenes_manually.html) — deferred room swaps, spawn door IDs, and safe `queue_free` of the outgoing room.
- [Saving games](https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html) — persist abilities, opened gates, collectibles, and visited map cells across sessions.
- [Singletons (Autoload)](https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html) — global progression/game-state ownership so rooms never keep conflicting ability flags.
- [Resources](https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html) — ability unlock definitions and room metadata as `.tres` data with safe duplication.
- [Using Tilemaps](https://docs.godotengine.org/en/stable/tutorials/2d/using_tilemaps.html) — `TileMapLayer` + `Vector2i` cells for minimap fog revelation and grid room tracking.
- [Camera2D](https://docs.godotengine.org/en/stable/classes/class_camera2d.html) — room `limit_*` bounds and tweened limit handoffs for seamless camera room transitions.
- [Using Area2D](https://docs.godotengine.org/en/stable/tutorials/physics/using_area_2d.html) — doors, save stations, and hazard triggers via body_entered without hard scene coupling.
- [Groups](https://docs.godotengine.org/en/stable/tutorials/scripting/groups.html) — `call_group` for save-station heal/respawn broadcasts instead of walking the whole tree.

### Related Skills

#### Prerequisites
- [godot-project-foundations](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md) — autoloads, scene layout, and project settings before stacking room streaming and global progression.
- [godot-characterbody-2d](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-characterbody-2d/SKILL.md) — tight platformer locomotion is the substrate under ability-gated traversal (dash, wall slide, double jump).
- [godot-tilemap-mastery](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-tilemap-mastery/SKILL.md) — layered TileMap/TileMapLayer authorship for gameplay collision, landmarks, and minimap fog grids.
- [godot-autoload-architecture](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-autoload-architecture/SKILL.md) — singleton ownership patterns for ability flags and world persistence that rooms must not duplicate.

#### Complements
- [godot-scene-management](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-scene-management/SKILL.md) — threaded load queues and deferred room switches that keep interconnected maps hitch-free.
- [godot-save-load-systems](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-save-load-systems/SKILL.md) — durable schemas for collectibles, boss flags, and visited cells across long exploration sessions.
- [godot-camera-systems](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-camera-systems/SKILL.md) — room limits, RemoteTransform follow, and transition polish beyond basic Camera2D bounds.
- [godot-ability-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ability-system/SKILL.md) — unlockable traversal/combat abilities that gates and state machines query as the “keys.”
- [godot-state-machine-advanced](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-state-machine-advanced/SKILL.md) — hierarchical player states for dash/wall-slide/double-jump without nested `if/elif` sprawl.
- [godot-2d-physics](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-2d-physics/SKILL.md) — layers, Area2D doors/hazards, and direct space queries for wall detection and soft-lock-safe valves.
- [godot-inventory-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-inventory-system/SKILL.md) — collectible/key item tracking that feeds map rewards and ability acquisition UI.

#### Downstream / consumers
- [godot-monte-carlo-balancer](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md) — simulate ability unlock order, backtrack length, and soft-lock risk once gates and reward density are tunable.
- [godot-genre-platformer](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-platformer/SKILL.md) — pure movement-feel patterns that Metroidvania traversal builds on when stripping ability gating.
- [godot-signal-architecture](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md) — ability_unlocked / gate_opened / map_revealed buses so HUD and rooms observe progression without owning it.

#### Master
- [godot-master](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-master/SKILL.md) — library router and mirrored module entry; use when discovering peer skills or syncing shared script mirrors after Domain Skill edits.
