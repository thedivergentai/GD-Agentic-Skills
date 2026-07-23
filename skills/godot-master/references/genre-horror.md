---
name: godot-genre-horror
description: "Expert blueprint for horror games: sawtooth tension pacing, Director macro-AI, sensory predator AI, sanity/stress FX, and scarcity loops. Use when building psychological/survival horror, dual-brain stalker AI (cheating Director + honest LoS/sound), flashlight/fog atmosphere, or safe-room saves. Keywords: horror_game, tension_pacing, director_system, sensory_perception, sanity_system, volumetric_fog, AI_reaction_time."
---

## Godot 4.7 Baseline

- Expert patterns in this skill target **Godot 4.7+** (stable, 2026-06-18).
- Consult the [Godot 4.7 migration guide](https://docs.godotengine.org/en/4.7/tutorials/migrating/upgrading_to_godot_4.7.html) when upgrading projects from 4.6.
- **NEVER** assume 4.6 defaults (stretch mode, audio area_mask, RichTextLabel percent flags) without checking 4.7 migration notes.

# Genre: Horror

Expert blueprint for horror games balancing tension, atmosphere, and player agency.

**Use when:**
- You need a **Director** that drives buildup → peak → relief (not constant jump-scares).
- A predator must feel unfair at the *macro* level but honest at the *sense* level (dual brain).
- Sanity, scarcity, volumetric fog, or threaded scare loads are core to the fantasy.

## NEVER Do (Expert Anti-Patterns)

### Atmosphere & Tension
- NEVER maintain 100% tension at all times; strictly use a **Sawtooth Pacing** model (buildup → peak/scare → dedicated relief period) to prevent player "numbing" and exhaustion.
- NEVER rely on jump-scares as the primary source of horror; focus on atmosphere, spatial audio cues, and the *anticipation* of a threat to build genuine dread.
- NEVER make environments pitch black to the point of frustrating navigation; darkness should obscure *threats* (details), not the *floor*. Use rim lighting or a limited-battery flashlight.
- NEVER grant the player unlimited resources; survival horror relies on **Scarcity**. Limited battery, rare ammo, and slow animations are mandatory to force stressful decision-making.

### AI & Senses
- NEVER allow AI to detect the player instantly; implement a **Suspicion Meter** or a 1-3s reaction window before the AI enters full aggression to avoid "unfair cheating" feel.
- NEVER use predictable AI paths; an enemy on a perfect loop is a puzzle, not a predator. Use the **Director** to periodically "hint" a new destination near the player.
- NEVER use Area3D overlap signals for instant, frame-perfect Line-of-Sight (LoS) checks; use nodeless raycasting via `PhysicsDirectSpaceState3D.intersect_ray()` for fixed-physics sync.
- NEVER calculate complex AI vision or pathfinding for monsters far outside the camera's frustum; use `VisibleOnScreenNotifier3D` to disable processing logic.
- NEVER leave navigation avoidance layers unconfigured on chasing monsters; explicitly assign avoidance masks to prevent visual "stacking" in tight corridors.

### Technical & Scarcity
- NEVER use the visual SceneTree (like GridContainer children) as the source of truth for inventory; strictly maintain a typed memory structure like `Dictionary[StringName, Resource]`.
- NEVER rely on instantiating standard Nodes to store base item stats/definitions; use custom `Resource` scripts to reduce memory overhead and allow direct Inspector editing.
- NEVER forget to call `duplicate(true)` on an item's Resource when adding to inventory; if items have mutable states (ammo/durability), you will overwrite the global resource otherwise.
- NEVER parse massive JSON save files synchronously; strictly offload heavy parsing to the `WorkerThreadPool` to prevent auto-save freezes.
- NEVER use standard strings for hot-path IDs (states, item types); strictly use `StringName` (&"chasing") for pointer-speed comparisons.
- NEVER evaluate exact floating-point equality (sanity == 0.0); strictly use `is_equal_approx()` or threshold checks for deterministic triggers.
- NEVER write screen-reading shaders expecting Godot 3 `SCREEN_TEXTURE`; strictly use `sampler2D` with `hint_screen_texture`.
- NEVER instantiate detailed monster meshes or lights without culling; strictly configure `visibility_range` for automatic HLOD efficiency.
- NEVER rely on AnimationPlayer for random flickering; use `Tween` for programmatic, clean energy manipulation.
- NEVER load heavy scare scenes or 4K textures synchronously via `load()`; strictly use `ResourceLoader.load_threaded_request()` to prevent frame stalls.
- NEVER scale CollisionShape3D non-uniformly; strictly adjust internal shape resource parameters (radius, height) to prevent erratic physics.
- NEVER perform synchronous, heavy file I/O in a Safe Room; strictly use **`Thread` and `Mutex`** to handle background saving without stalling the main game thread.
- NEVER check for hiding spot types by casting; strictly use **`Object` metadata (`set_meta`)** for performant, decoupled AI queries.

---

## Godot 4.7: Horror Lighting

- **AreaLight3D** for flickering panels, TV glow, and rectangular soft shadows without GI hacks.

## 🛠 Expert Components (scripts/)

### Original Expert Patterns (MANDATORY at architecture steps)
- [director_pacing.gd](../scripts/genre_horror_director_pacing.gd) - Invisible orchestrator managing the "Sawtooth" tension wave and relief periods. **MANDATORY** before wiring any pacing/Director.
- [predator_stalking_ai.gd](../scripts/genre_horror_predator_stalking_ai.gd) - Dual-brain stalker (Director hints + honest senses) with view-cone avoidance. **MANDATORY** before implementing predator AI.

### Modular Components
- [monster_los_check.gd](../scripts/genre_horror_monster_los_check.gd) - Physics-synced raycasting for high-performance visibility checks.
- [flashlight_flicker.gd](../scripts/genre_horror_flashlight_flicker.gd) - Procedural light interference for atmospheric tension.
- [inventory_data_storage.gd](../scripts/genre_horror_inventory_data_storage.gd) - Typed data structure for sparse resource management.
- [async_scare_loader.gd](../scripts/genre_horror_async_scare_loader.gd) - Threaded resource loading for hitch-free jump-scares.
- [spatial_noise_emitter.gd](../scripts/genre_horror_spatial_noise_emitter.gd) - Shape-based sound sensing for sensory AI.
- [item_state_duplicator.gd](../scripts/genre_horror_item_state_duplicator.gd) - Deep duplication for managing unique weapon/item states.
- [fog_claus_intensifier.gd](../scripts/genre_horror_fog_claus_intensifier.gd) - Volumetric fog manipulation for dread buildup.
- [offscreen_logic_suspender.gd](../scripts/genre_horror_offscreen_logic_suspender.gd) - Culling logic for AI processing outside camera view.
- [sanity_shader_manager.gd](../scripts/genre_horror_sanity_shader_manager.gd) - Instance-uniform driven distortion effects.
- [sanity_manager.gd](../scripts/genre_horror_sanity_manager.gd) - Stress/sanity value pipeline feeding shake and audio buses.
- [optimized_horror_state_machine.gd](../scripts/genre_horror_optimized_horror_state_machine.gd) - High-speed predator behavior logic.

---

## Core Loop
1.  **Explore**: Player navigates a threatening environment.
2.  **Sense**: Player hears/sees signs of danger.
3.  **React**: Player hides, runs, or fights (disempowered combat).
4.  **Survive**: Player reaches safety or solves a puzzle.
5.  **Relief**: Brief moment of calm before tension builds again.

## Skill Chain

| Phase | Skills | Purpose |
|-------|--------|---------|
| 1. Atmosphere | `godot-3d-lighting`, `godot-audio-systems` | Volumetric fog, dynamic shadows, spatial audio |
| 2. AI | `godot-state-machine-advanced`, `godot-navigation-pathfinding`, `godot-raycasting-queries` | Hunter AI, honest LoS/sound |
| 3. Player | `godot-camera-systems`, `godot-genre-stealth`, `godot-physics-3d` | Lean/shake, hiding, CharacterBody3D movement |
| 4. Scarcity | `godot-inventory-system` | Limited battery, ammo, health |
| 5. Logic / saves | this skill's Director scripts + `godot-save-load-systems` | Sawtooth pacing + threaded safe-room saves |


## Do-NOT-Load (by fantasy)

| Fantasy focus | Load | Do NOT load |
|---------------|------|-------------|
| Atmosphere / fog / flashlight only | `fog_claus_intensifier.gd`, `flashlight_flicker.gd` | Predator AI, LoS, noise, state machine |
| Stalker / dual-brain AI | `director_pacing.gd`, `predator_stalking_ai.gd`, `monster_los_check.gd`, `spatial_noise_emitter.gd` | Sanity shaders, inventory duplicator, scare loader |
| Sanity / stress FX | `sanity_manager.gd`, `sanity_shader_manager.gd` | Inventory scarcity scripts, async scare loader |
| Scarcity / inventory truth | `inventory_data_storage.gd`, `item_state_duplicator.gd` | Fog intensifier, sanity shaders |
| Hitch-free scare assets | `async_scare_loader.gd` | Full Director + sanity stack |

## Architecture Overview

### 1. The Director System (Macro AI)
Controls pacing so players never stay at 100% tension.

> **MANDATORY read**: [director_pacing.gd](../scripts/genre_horror_director_pacing.gd) — do not paste a one-off tension enum. Wire Director events to *near-player* investigation targets, never instant on-player teleports during quiet phases.

### 2. Sensory Perception (Micro AI)
Honest monster senses (vision + sound) that the Director may only *hint*, never hard-cheat.

> **MANDATORY reads**: [predator_stalking_ai.gd](../scripts/genre_horror_predator_stalking_ai.gd) for dual-brain orchestration; [monster_los_check.gd](../scripts/genre_horror_monster_los_check.gd) + [spatial_noise_emitter.gd](../scripts/genre_horror_spatial_noise_emitter.gd) for LoS/sound. Prefer `PhysicsDirectSpaceState3D.intersect_ray()` over Area overlap for vision.

### 3. Sanity / Stress System
Distorting the world based on fear.

> Load [sanity_manager.gd](../scripts/genre_horror_sanity_manager.gd) + [sanity_shader_manager.gd](../scripts/genre_horror_sanity_shader_manager.gd) for value → shake/bus/shader pipelines. Keep thresholds on `is_equal_approx` / bands, never `sanity == 0.0`.

## Key Mechanics Implementation

### Pacing (The Sawtooth Wave)
Horror needs peaks and valleys.
1.  **Safety**: Save room.
2.  **Unease**: Strange noise, lights flicker.
3.  **Dread**: Monster is known to be close.
4.  **Terror**: Chase sequence / Combat.
5.  **Relief**: Escape to Safety.

### The "Dual Brain" AI
*   **Director (All-knowing)**: Cheats to keep the alien relevant (teleports it closer if far away, guides it to player's general area).
*   **Alien (Senses only)**: Honest AI. Must actually see/hear the player to attack.

### 3. Hiding-Spot Metadata System
Use `set_meta` / groups — **MANDATORY**: [predator_stalking_ai.gd](../scripts/genre_horror_predator_stalking_ai.gd) + peer [godot-genre-stealth](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-stealth/SKILL.md). Do not paste hiding-spot tutorials inline.

### 4. Adaptive Audio (Stress Muffling)
Bus LPF / volume from fear — **MANDATORY**: [sanity_manager.gd](../scripts/genre_horror_sanity_manager.gd) + peer [godot-audio-systems](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-audio-systems/SKILL.md).

### 5. Safe-Room Multithreaded Save
Threaded checkpoint I/O — **MANDATORY**: peer [godot-save-load-systems](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-save-load-systems/SKILL.md) (Thread/Mutex / WorkerThreadPool). Never sync `FileAccess` on the main thread in a safe room.

## Reference

> Progressive disclosure: open Official Documentation links only when researching a specific API; load Related Skills when routing to a peer domain — do not preload the whole lattice.

### Official Documentation
- [Volumetric fog and fog volumes](https://docs.godotengine.org/en/stable/tutorials/3d/volumetric_fog.html) — density/albedo and light-dependent scattering for dread atmosphere.
- [Environment and post-processing](https://docs.godotengine.org/en/stable/tutorials/3d/environment_and_post_processing.html) — WorldEnvironment tonemap, glow, and fog modes that carry horror looks.
- [Lights and shadows](https://docs.godotengine.org/en/stable/tutorials/3d/lights_and_shadows.html) — SpotLight3D flashlight cones, soft shadows, and bias for dark interiors.
- [Audio buses](https://docs.godotengine.org/en/stable/tutorials/audio/audio_buses.html) — LowPass/Reverb bus effects for stress muffling and spatial dread.
- [Ray-casting](https://docs.godotengine.org/en/stable/tutorials/physics/ray-casting.html) — PhysicsDirectSpaceState intersect_ray for honest monster LoS (not Area overlap).
- [Navigation introduction (3D)](https://docs.godotengine.org/en/stable/tutorials/navigation/navigation_introduction_3d.html) — predator chase paths and avoidance masks in tight corridors.
- [Background loading](https://docs.godotengine.org/en/stable/tutorials/io/background_loading.html) — ResourceLoader threaded requests so jump-scare assets never hitch.
- [Screen-reading shaders](https://docs.godotengine.org/en/stable/tutorials/shaders/screen-reading_shaders.html) — hint_screen_texture sanity distortion (not Godot 3 SCREEN_TEXTURE).
- [Visibility ranges](https://docs.godotengine.org/en/stable/tutorials/3d/visibility_ranges.html) — GeometryInstance3D HLOD/culling for expensive monster meshes and lights.
- [Saving games](https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html) — FileAccess patterns for safe-room checkpoints without inventing a format.
- [Using threads](https://docs.godotengine.org/en/stable/tutorials/performance/using_multiple_threads.html) — Thread/Mutex and WorkerThreadPool for background saves and heavy parse work.
- [Resources](https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html) — Resource definitions and `duplicate(true)` so mutable item state never aliases globals.

### Related Skills

#### Prerequisites
- [godot-project-foundations](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md) — scene tree, autoloads, and import basics before Director/WorldEnvironment wiring.
- [godot-3d-lighting](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-lighting/SKILL.md) — volumetric fog, SpotLight3D flashlights, and shadow budgets that define horror atmosphere.
- [godot-audio-systems](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-audio-systems/SKILL.md) — buses, spatial emitters, and effect stacks the sanity/stress systems modulate.

#### Complements
- [godot-navigation-pathfinding](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-navigation-pathfinding/SKILL.md) — NavigationAgent chase/search paths and avoidance so predators do not stack in corridors.
- [godot-state-machine-advanced](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-state-machine-advanced/SKILL.md) — StringName-driven patrol/chase/search machines for predator micro-AI.
- [godot-raycasting-queries](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-raycasting-queries/SKILL.md) — physics-synced LoS and shape queries for sensory perception without Area cheating.
- [godot-shaders-basics](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-shaders-basics/SKILL.md) — instance uniforms and screen-reading distortion for sanity FX.
- [godot-inventory-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-inventory-system/SKILL.md) — typed Resource inventory and scarcity (battery/ammo) separate from visual UI trees.
- [godot-camera-systems](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-camera-systems/SKILL.md) — shake, lean, and frustum-driven offscreen AI suspend via VisibleOnScreenNotifier3D.
- [godot-tweening](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-tweening/SKILL.md) — procedural flashlight flicker and fog density ramps without AnimationPlayer spam.
- [godot-monte-carlo-balancer](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md) — simulate Director sawtooth peaks/relief and scarcity budgets before shipping.
- [godot-genre-stealth](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-stealth/SKILL.md) — suspicion meters, hiding spots, and view-cone stalker patterns that share sensory AI.

#### Downstream / consumers
- [godot-genre-survival](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-survival/SKILL.md) — scarcity loops and safe-room checkpoints that reuse horror resource pressure.
- [godot-save-load-systems](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-save-load-systems/SKILL.md) — threaded/async save pipelines for safe rooms without main-thread freezes.

#### Master
- [godot-master](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-master/SKILL.md) — library router and mirrored module entry for cross-skill discovery.
