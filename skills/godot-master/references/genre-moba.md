---
name: godot-genre-moba
description: "Expert blueprint for MOBA games including lane logic (minion wave spawning every 30s), tower aggro priority (hero attacking ally over minion over hero), click-to-move controls (RTS-style raycasting), hero ability systems (QWER cooldowns, mana cost), fog of war (SubViewport projections), and authoritative networking (server validates damage). Use for competitive 5v5 or arena games. Trigger keywords: MOBA, lane_manager, minion_waves, tower_aggro, click_to_move, ability_cooldowns, fog_of_war, comeback_mechanics."
---

## Godot 4.7 Baseline

- Expert patterns in this skill target **Godot 4.7+** (stable, 2026-06-18).
- Consult the [Godot 4.7 migration guide](https://docs.godotengine.org/en/4.7/tutorials/migrating/upgrading_to_godot_4.7.html) when upgrading projects from 4.6.
- **NEVER** assume 4.6 defaults (stretch mode, audio area_mask, RichTextLabel percent flags) without checking 4.7 migration notes.

# Genre: MOBA (Multiplayer Online Battle Arena)

Expert blueprint for MOBAs emphasizing competitive balance and strategic depth.

## NEVER Do (Expert Anti-Patterns)

### Networking & Authority
- NEVER trust the client for damage calculation or resource costs; strictly validate mana, ranges, and hit detection on the **authoritative server** using `multiplayer.is_server()`.
- NEVER use `TRANSFER_MODE_RELIABLE` for continuous movement; strictly use `UNRELIABLE` or `UNRELIABLE_ORDERED` for position/velocity to prevent network congestion.
- NEVER sync units at 60Hz; strictly use a lower tick rate (10-20Hz) via `MultiplayerSynchronizer` and implement **Interp/Client-Side Prediction** for visual smoothness.
- NEVER attach individual synchronizers to hundreds of minions; strictly batch state updates into compressed byte arrays via a central manager.
- NEVER synchronize complex Engine objects directly; strictly serialize state into primitive properties or Dictionaries for reliable peer-to-peer sync.

### AI & Pathfinding
- NEVER use expensive pathfinding for all minions every frame; strictly use **Time Slicing** to spread `get_next_path_position()` calls across multiple frames.
- NEVER query `NavigationAgent` paths inside `_process()`; strictly use `_physics_process()` to interact with the navigation server and avoidance systems.
- NEVER use complex visual geometry for NavMesh baking; parse simple primitives to avoid stalling the `RenderingServer` or crashing the engine.
- NEVER set `path_search_max_polygons` too low in large maps; agents will stop or walk incorrectly if the limit is reached before the destination.
- NEVER use `Area2D` for high-performance Fog of War LOS; strictly use nodeless physics queries (`intersect_ray`) to bypass node overhead.

### Gameplay & Balancing
- NEVER forget Tower "Dive" protection; towers MUST switch targets immediately if an enemy Hero damages an allied Hero within range (Priority: Hero attacking Ally > Minion > Hero).
- NEVER allow "Snowballing" without counter-play; strictly implement **Comeback Mechanisms** (Kill Bounties, Catch-up XP) to maintain competitive tension.
- NEVER manage hero stats as standard Node variables; strictly use custom `Resource` scripts for data separation and memory efficiency.
- NEVER forget to call `duplicate(true)` on shared ability Resources; modifying a buff on a shared resource will affect all heroes globally.

### Technical & Performance
- NEVER use standard strings for status checks (e.g., "stunned"); strictly use `StringName` (&"stunned") for pointer-speed comparisons.
- NEVER loop over massive Fog of War grids with floats; strictly use `Vector2i` and `TileMapLayer` to prevent precision jitter.
- NEVER execute heavy world/minimap logic on the main thread; strictly offload complex array math to `WorkerThreadPool` to maintain 60+ FPS.
- NEVER rigidly couple UI cooldowns to Hero scripts; strictly use a Signal Bus or `Callable` bindings for decoupled architecture.
- NEVER evaluate exact floating-point equality (==); strictly use `is_equal_approx()` for range, cooldown, and mana validations.

---

## Decision Tree: Solo prototype vs authoritative 5v5

| Goal | Load first | Skip / defer |
|------|------------|--------------|
| **Solo lane prototype** (1 hero, local waves, no peers) | [tower_priority_aggro.gd](../scripts/genre_moba_tower_priority_aggro.gd), [weighted_target_selector.gd](../scripts/genre_moba_weighted_target_selector.gd), [skill_shot_indicator.gd](../scripts/genre_moba_skill_shot_indicator.gd), [hero_state_machine.gd](../scripts/genre_moba_hero_state_machine.gd) | `server_minion_sync`, full fog grid, prediction |
| **Authoritative 5v5** (dedicated/listen server) | [server_minion_sync.gd](../scripts/genre_moba_server_minion_sync.gd), [synced_ability_controller.gd](../scripts/genre_moba_synced_ability_controller.gd), [fog_visibility_check.gd](../scripts/genre_moba_fog_visibility_check.gd) + [fog_grid_mask.gd](../scripts/genre_moba_fog_grid_mask.gd), [minion_worker_pathfinder.gd](../scripts/genre_moba_minion_worker_pathfinder.gd) | Client-trusted damage, per-minion `MultiplayerSynchronizer` |
| **Peer skill** | `godot-multiplayer-networking`, `godot-navigation-pathfinding`, `godot-ability-system` | Inventing a second networking stack inside this genre skill |

## 🛠 Expert Components (scripts/)

### Original Expert Patterns
- [skill_shot_indicator.gd](../scripts/genre_moba_skill_shot_indicator.gd) - Mouse-driven targeting system for range, width, and direction visualization.
- [tower_priority_aggro.gd](../scripts/genre_moba_tower_priority_aggro.gd) - Advanced AI for defensive towers following competitive priority rules. **MANDATORY** for tower dive/priority.

### Modular Components
- [server_minion_sync.gd](../scripts/genre_moba_server_minion_sync.gd) - Authoritative sync for high-count units using compressed byte arrays. **MANDATORY** for 5v5 waves (not one synchronizer per minion).
- [fog_visibility_check.gd](../scripts/genre_moba_fog_visibility_check.gd) - Physics raycasting for high-performance Line-of-Sight checks. **MANDATORY** before fog mask painting.
- [fog_grid_mask.gd](../scripts/genre_moba_fog_grid_mask.gd) - TileMap-driven visibility masking system using Vector2i grid logic.
- [minion_worker_pathfinder.gd](../scripts/genre_moba_minion_worker_pathfinder.gd) - **When to load:** WorkerThreadPool path batches when wave size leaves `_physics_process` pathfinding. Prefer over per-minion full A* every frame.
- [weighted_target_selector.gd](../scripts/genre_moba_weighted_target_selector.gd) - **When to load:** hero/minion/tower acquisition with group-weighted priority (AA and simple aggro). Pair with tower_priority for dive rules.
- [synced_ability_controller.gd](../scripts/genre_moba_synced_ability_controller.gd) - **When to load:** QWER casts under authority — client predicts cooldown UI, server validates. Skip for offline prototypes.
- [status_effect_data.gd](../scripts/genre_moba_status_effect_data.gd) - Lightweight Resource container for defining buffs, debuffs, and stuns.
- [status_effect_manager.gd](../scripts/genre_moba_status_effect_manager.gd) - Modular logic for applying and managing unique status effect instances.
- [decoupled_ability_damage.gd](../scripts/genre_moba_decoupled_ability_damage.gd) - Inter-hero combat interaction using safe duck-typing patterns.
- [hero_state_machine.gd](../scripts/genre_moba_hero_state_machine.gd) - Optimized StringName-based state machine for hero logic.
- [async_arena_baker.gd](../scripts/genre_moba_async_arena_baker.gd) - Background thread-safe navigation mesh updates for dynamic arenas.
- [ability_ui_binder.gd](../scripts/genre_moba_ability_ui_binder.gd) - Signal-based UI decoupling for ability cooldown tracking.
- [minion_flow_calculator.gd](../scripts/genre_moba_minion_flow_calculator.gd) - Parallelized pathing and intelligence using WorkerThreadPool.

---

## Core Loop
1.  **Lane**: Player farms minions for gold/XP in a designated lane.
2.  **Trade**: Player exchanges damage with opponent hero.
3.  **Gank**: Player roams to other lanes to surprise enemies.
4.  **Push**: Team destroys towers to open the map.
5.  **End**: Destroy the enemy Core/Nexus.

## Skill Chain

| Phase | Skills | Purpose |
|-------|--------|---------|
| 1. Control | `rts-controls` | Right-click to move, A-move, Stop |
| 2. AI | `godot-navigation-pathfinding` | Minion waves, Tower aggro logic |
| 3. Combat | `godot-ability-system`, `godot-rpg-stats` | QWER abilities, cooldowns, scaling |
| 4. Network | `godot-multiplayer-networking` | Authority, lag compensation, prediction |
| 5. Map | `godot-3d-world-building` | Lanes, Jungle, River, Bases |
| 6. Balance | `godot-monte-carlo-balancer` | Hero/asymmetry matrix (not sole AFK→pro) |

## Architecture Overview

### 1. Lane / Minion Waves (authoritative)
Do **not** invent inline `lane_manager` / `minion_ai` samples.

> **MANDATORY reads**: [server_minion_sync.gd](../scripts/genre_moba_server_minion_sync.gd) for batched wave state; [minion_worker_pathfinder.gd](../scripts/genre_moba_minion_worker_pathfinder.gd) when agent count needs WorkerThreadPool; [weighted_target_selector.gd](../scripts/genre_moba_weighted_target_selector.gd) for march→combat target picks. Spawn cadence stays data/timer-driven on the server; clients render from sync arrays.

### 2. Tower Aggro Logic
Priority: Hero attacking Ally > unit attacking Ally Hero > closest minion > closest hero.

> **MANDATORY read**: [tower_priority_aggro.gd](../scripts/genre_moba_tower_priority_aggro.gd). Compose with [weighted_target_selector.gd](../scripts/genre_moba_weighted_target_selector.gd) for group ranks.

### 3. Fog of War
> **MANDATORY read**: [fog_visibility_check.gd](../scripts/genre_moba_fog_visibility_check.gd) for nodeless LoS; paint results into [fog_grid_mask.gd](../scripts/genre_moba_fog_grid_mask.gd). Never use `Area2D` overlap as the fog oracle.

### 4. Skill-Shot Ability Cycle
Implementation pattern for "QWER" targeting:
1. **Idle**: Waiting for input.
2. **Telegraphed**: Show indicator ([skill_shot_indicator.gd](../scripts/genre_moba_skill_shot_indicator.gd)) while mouse is held.
3. **Active**: Spawn hitbox/projectile on release — under multiplayer, route through [synced_ability_controller.gd](../scripts/genre_moba_synced_ability_controller.gd).
4. **Recovery**: Brief backswing animation where movement/casting is locked.

## Key Mechanics Implementation

### Click-to-Move (RTS Style)
Raycasting from camera to terrain.

```gdscript
func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("move"):
        var result = raycast_from_mouse()
        if result:
            nav_agent.target_position = result.position
```

### Ability System (Data Driven)
Defining "Fireball" or "Hook" without unique scripts for everything.

```gdscript
# ability_data.gd
class_name Ability extends Resource
@export var cooldown: float
@export var mana_cost: float
@export var damage: float
@export var effect_scene: PackedScene
```

## Godot-Specific Tips

*   **NavigationAgent3D**: Use `avoidance_enabled` for minions so they flow around each other like water, rather than stacking.
*   **MultiplayerSynchronizer**: Sync Health, Mana, and Cooldowns. Do NOT sync position every frame if using Client-Side Prediction (advanced).
*   **Fog of War**: Use a `SubViewport` with a fog texture. Paint "holes" in the texture where allies are. Project this texture onto the terrain shader.

## Common Pitfalls

1.  **Snowballing**: Winning team gets too strong too fast. **Fix**: Implement "Comeback XP/Gold" mechanisms (bounties).
2.  **Pathfinding Lag**: 100 minions pathing every frame. **Fix**: Distribute pathfinding updates over multiple frames (Time Slicing).
3.  **Hacking**: Client says "I dealt 1000 damage". **Fix**: Client says "I cast Spell Q at Direction V". Server calculates damage.


## Advanced MOBA Meta-Systems

Professional implementation of match playback, network smoothing, and advanced jungle AI.

### 1. Match Replay System (Binary Serialization)
For high-performance match recording, use `var_to_bytes()` to serialize state dictionaries into a compressed binary format. Avoid JSON for replays to minimize disk I/O and file size.

```gdscript
class_name ReplayManager extends Node

var frame_history: Array[PackedByteArray] = []

func record_frame(state: Dictionary) -> void:
    # Efficiently convert data to bytes
    frame_history.append(var_to_bytes(state))

func save_replay(match_id: String) -> void:
    var file := FileAccess.open("user://replays/" + match_id + ".dat", FileAccess.WRITE)
    if file:
        file.store_var(frame_history) # Stores the whole array as a variant
        file.close()

func play_frame(frame_index: int) -> Dictionary:
    return bytes_to_var(frame_history[frame_index])
```

### 2. Networked Interpolated Sync
Use Godot 4.x's built-in physics interpolation to mask network jitter. Combined with `MultiplayerSynchronizer`, this provides smooth hero movement even at low tick rates (15-20Hz).

```gdscript
class_name HeroNetSync extends CharacterBody3D

func _ready() -> void:
    # Enable native engine interpolation for visual smoothness
    physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_ON
    
    if is_multiplayer_authority():
        setup_synchronizer()

func setup_synchronizer() -> void:
    var sync := $MultiplayerSynchronizer
    var config := SceneReplicationConfig.new()
    # Sync position/rotation via unreliable ordered packets
    config.add_property(NodePath(".:global_position"))
    sync.replication_config = config
```

### 3. Jungle-AI (Camp Leashing)
Implement a state machine for jungle monsters that monitors distance from their spawn point. If a hero draws them too far, they enter a "Leashing" state, becoming invulnerable and returning home.

```gdscript
class_name JungleCreep extends CharacterBody3D

@export var leash_radius: float = 12.0
@onready var spawn_pos := global_position

func _physics_process(_delta: float) -> void:
    var dist_from_home := global_position.distance_to(spawn_pos)
    
    match state:
        State.CHASING:
            if dist_from_home > leash_radius:
                state = State.LEASHING
        State.LEASHING:
            # Move back to spawn_pos using NavigationAgent3D
            nav_agent.target_position = spawn_pos
            if global_position.distance_to(spawn_pos) < 1.0:
                state = State.IDLE
                health = max_health # Reset health on return
```

**Expert Tip**: Always use `NavigationServer3D.map_get_iteration_id()` to ensure the navigation map is fully synced before allowing AI to pathfind after spawning.


## Reference

> Progressive disclosure: open Official Documentation links only when researching a specific API;
> load Related Skills when routing work to a peer domain — do not preload the whole lattice.

### Official Documentation
- [High-level multiplayer](https://docs.godotengine.org/en/stable/tutorials/networking/high_level_multiplayer.html) — Authority, RPCs, and transfer modes for server-validated casts and unreliable movement.
- [MultiplayerSynchronizer](https://docs.godotengine.org/en/stable/classes/class_multiplayersynchronizer.html) — Property replication for hero health/mana/cooldowns without per-minion synchronizer spam.
- [SceneReplicationConfig](https://docs.godotengine.org/en/stable/classes/class_scenereplicationconfig.html) — Which properties replicate and how often when pairing with low tick-rate hero sync.
- [Using NavigationAgents](https://docs.godotengine.org/en/stable/tutorials/navigation/navigation_using_navigationagents.html) — Click-to-move, minion march, and avoidance for lane flow without stacking.
- [Using navigation meshes](https://docs.godotengine.org/en/stable/tutorials/navigation/navigation_using_navigationmeshes.html) — Baking lanes/jungle/bases and async rebake when arena geometry changes.
- [Optimizing navigation performance](https://docs.godotengine.org/en/stable/tutorials/navigation/navigation_optimizing_performance.html) — Time-slicing and agent budgets when hundreds of minions path each wave.
- [Ray-casting](https://docs.godotengine.org/en/stable/tutorials/physics/ray-casting.html) — Click-to-ground picking and nodeless fog LOS via direct space-state rays.
- [Physics interpolation introduction](https://docs.godotengine.org/en/stable/tutorials/physics/interpolation/physics_interpolation_introduction.html) — Smooth hero visuals when network sync runs at 10–20 Hz.
- [Using Viewports](https://docs.godotengine.org/en/stable/tutorials/rendering/viewports.html) — SubViewport fog masks and minimap projections painted from allied vision.
- [Using multiple threads](https://docs.godotengine.org/en/stable/tutorials/performance/using_multiple_threads.html) — WorkerThreadPool patterns for minion batch logic off the main thread.
- [Resources](https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html) — Ability/status `Resource` data with `duplicate(true)` so buffs never mutate shared templates.
- [Mouse and input coordinates](https://docs.godotengine.org/en/stable/tutorials/inputs/mouse_and_input_coordinates.html) — Screen→world mapping for skill-shot indicators and RTS-style move orders.

### Related Skills

#### Prerequisites
- [godot-project-foundations](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md) — Physics ticks, layer names, and input map setup before lanes, towers, and fog queries stay consistent.
- [godot-multiplayer-networking](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-multiplayer-networking/SKILL.md) — Authority, RPC hygiene, and sync budgets that MOBA minion/hero networking builds on.
- [godot-navigation-pathfinding](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-navigation-pathfinding/SKILL.md) — NavigationAgent avoidance, baking, and performance contracts for waves and jungle camps.
- [godot-input-handling](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-input-handling/SKILL.md) — Action maps and physics-step input sampling for click-to-move and QWER cast telegraphs.

#### Complements
- [godot-ability-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ability-system/SKILL.md) — Data-driven QWER cooldowns, costs, and effect scenes wired into authoritative cast validation.
- [godot-rpg-stats](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-rpg-stats/SKILL.md) — Hero growth, armor/MR-style modifiers, and Resource-backed stats towers and abilities read.
- [godot-combat-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-combat-system/SKILL.md) — Hit/hurt contracts for skill-shots, AA, and tower shots without hard class coupling.
- [godot-raycasting-queries](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-raycasting-queries/SKILL.md) — Deeper space-state recipes for fog LOS, dive checks, and click picking under load.
- [godot-signal-architecture](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md) — Decoupled ability UI binders and cast buses so cooldowns never live inside hero combat scripts.
- [godot-3d-world-building](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-world-building/SKILL.md) — Lane corridors, jungle geometry, and collision that match the navmesh bake surface.
- [godot-performance-optimization](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md) — Profiling and batching when minion sync arrays or fog grids threaten frame time.
- [godot-genre-rts](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-rts/SKILL.md) — Shared click-to-move, selection, and fog-mask patterns when borrowing RTS control UX for MOBA heroes.

#### Downstream / consumers
- [godot-adapt-single-to-multiplayer](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-adapt-single-to-multiplayer/SKILL.md) — Lifts a solo lane prototype into lobby/authority/prediction flows this genre assumes.
- [godot-monte-carlo-balancer](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md) — Hero asymmetry, kill-bounty, and catch-up XP matrices — simulate matchup win% instead of AFK→pro PvE bands alone.

#### Master
- [godot-master](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-master/SKILL.md) — Library router and mirrored entry for discovering MOBA patterns beside sibling domains.
