---
name: godot-mechanic-revival
description: "Expert blueprint for player mortality loops: progress-index checkpoints, soul graves, ghost/spirit layers, I-frame restitution, world-progress persistence, and death analytics. Use when implementing respawn, shrine checkpoints, corpse-run retrieval, or second-chance mechanics. Keywords revival, respawn, checkpoint, soul grave, ghost mode, I-frames, death analytics, progress index."
---

## Godot 4.7 Baseline

- Expert patterns in this skill target **Godot 4.7+** (stable, 2026-06-18).
- Consult the [Godot 4.7 migration guide](https://docs.godotengine.org/en/4.7/tutorials/migrating/upgrading_to_godot_4.7.html) when upgrading projects from 4.6.
- **NEVER** assume 4.6 defaults (stretch mode, audio area_mask, RichTextLabel percent flags) without checking 4.7 migration notes.

# Revival & Resurrection Mechanics

## Overview
Mortality beyond Game Over: **progress-index checkpoints**, **soul graves**, **ghost/spirit collision layers**, **I-frame restitution**, **world-progress bitmasks**, and **death analytics** (Sekiro / Hades / Souls-like).

## Golden Path — Death → Fade → Restore → I-frame → World Persist

**MANDATORY script order** (read before improvising):

1. [revival_global_manager.gd](scripts/revival_global_manager.gd) — Autoload owns death → delay → respawn; resolve player via group `Player`.
2. [revival_death_timer.gd](scripts/revival_death_timer.gd) — 1–2s fade / death anim; never snap-respawn.
3. [revival_state_reset_guard.gd](scripts/revival_state_reset_guard.gd) — zero velocity / clear locks before teleport.
4. [revival_health_restitution.gd](scripts/revival_health_restitution.gd) — health restore + **I-frames**.
5. [revival_checkpoint_persistence.gd](scripts/revival_checkpoint_persistence.gd) — write world-progress bitmask to `user://`.
Optional layers: [revival_soul_grave.gd](scripts/revival_soul_grave.gd), [revival_ghost_mode.gd](scripts/revival_ghost_mode.gd), [revival_death_analytics.gd](scripts/revival_death_analytics.gd).

## NEVER Do (Expert Revival Rules)

### Lifecycle & State
- **NEVER respawn the player with existing velocity** — Always zero out `velocity` and `angular_velocity` in `revival_state_reset_guard.gd` or the player will fly into a wall upon respawning.
- **NEVER trust the nearest checkpoint by distance** — Always use a 'Progress Index' (`revival_checkpoint_validator.gd`). Players in non-linear games may wander back to the start area; don't downgrade their respawn point.
- **NEVER skip 'Invincibility Frames' (I-frames)** — Respawning inside a hazard or near an enemy without a 2s invincibility buffer leads to "Death Loops" and player frustration.

### Persistence & Data
- **NEVER save checkpoints solely in RAM** — If the game crashes, the player loses progress. Use `revival_checkpoint_persistence.gd` to write to `user://` immediately.
- **NEVER hardcode checkpoint coordinates** — Use `Marker3D` or `Area3D` nodes in the scene. Hardcoded coords break as soon as level geometry changes.
- **NEVER delete the player node on death** — `queue_free()`ing the player breaks UI refs and references from enemies. Disable processing, hide the mesh, and 'Revive' the existing instance instead.

### UX & Pacing
- **NEVER respawn instantly** — An instant snap is disorienting. Always use a 1-2s delay with a screen fade or death animation to allow the player to process the failure.
- **NEVER reset the entire world on player death** — In modern design, opened doors and collected unique items should stay persisted. Use a bitmask in the checkpoint resource to track 'World Progress'.

---

## Available Scripts

> **MANDATORY**: Read the appropriate script before implementing the corresponding pattern.

### [revival_global_manager.gd](scripts/revival_global_manager.gd)
Expert singleton for the global respawn loop. **Autoload boot**: register as `RevivalGlobalManager` before level scenes. Resolves the living body with `get_tree().get_first_node_in_group("Player")` — put the player in group `Player` (exact name). Owns `player_died` / `player_respawned`; levels and UI must not `queue_free()` the player.

### [revival_checkpoint_persistence.gd](scripts/revival_checkpoint_persistence.gd)
Resource-based system for saving last checkpoint and world state to disk.

### [revival_health_restitution.gd](scripts/revival_health_restitution.gd)
Professional I-frame and health replenishment logic for post-revive stability.

### [revival_soul_grave.gd](scripts/revival_soul_grave.gd)
Expert 'Soul Retrieval' mechanic for spawning graves at death coordinates.

### [revival_checkpoint_validator.gd](scripts/revival_checkpoint_validator.gd)
Progress-aware shrine/`Area3D` gate. Export `progress_index` + `checkpoint_id`; on enter, call `RevivalGlobalManager.set_active_checkpoint(...)` **only if** `progress_index >= RevivalGlobalManager.get_progress()`. Group the detector / player interact area so backtracking cannot downgrade the active shrine. Pair with [revival_checkpoint_persistence.gd](scripts/revival_checkpoint_persistence.gd) for durable writes.

### [revival_death_timer.gd](scripts/revival_death_timer.gd)
Professional respawn delay manager with UI and animation hooks.

### [revival_ghost_mode.gd](scripts/revival_ghost_mode.gd)
Expert 'Spirit World' transition logic involving collision layer swapping.

### [revival_state_reset_guard.gd](scripts/revival_state_reset_guard.gd)
Essential utility for purging velocity and state locks upon player respawn.

### [revival_checkpoint_visuals.gd](scripts/revival_checkpoint_visuals.gd)
Material-swapping logic for providing clear 'Active' feedback to players.

### [revival_auto_save_manager.gd](scripts/revival_auto_save_manager.gd)
Automatic save-trigger logic for ensuring checkpoint persistence.

### [revival_spectral_shader.gdshader](scripts/revival_spectral_shader.gdshader)
Translucent, glowing "ghost" effect for downed players.

### [revival_async_restorer.gd](scripts/revival_async_restorer.gd)
Smooth stat restoration logic using Tweens for organic recovery.

### [revival_death_analytics.gd](scripts/revival_death_analytics.gd)
Persistent logging of death telemetry (cause, location, time) for balancing.

---

## Expert Revival Patterns

### 1. Spectral Visual Feedback
Don't just hide the player. Use a **Spectral Shader** to communicate the "Downed" state.
- **Implementation**: Apply a `ShaderMaterial` with additive blending and a pulsing `ALPHA` to the player mesh.
- **Juice**: Combine with a grayscale `ColorRect` post-process effect to sell the "Spirit Realm" transition.

### 2. Death Analytics Ledger
Use **Death Analytics** to find "Difficulty Spikes".
- **Tracking**: Log `global_position` and `cause_of_death` to a JSON file.
- **Optimization**: Export these logs to a heatmap tool to identify areas where players are struggling.

## Reference

> Progressive disclosure: open Official Documentation links only when researching a specific API; load Related Skills when routing to a peer domain — do not preload the whole lattice.

### Official Documentation
- [Saving games](https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html) — Checkpoint and world-progress persistence must survive crashes; pair Resource/`FileAccess` saves with an immediate write on shrine activation.
- [File paths in Godot](https://docs.godotengine.org/en/stable/tutorials/io/data_paths.html) — Use `user://` for checkpoint and death-analytics files so saves work outside the project folder and across platforms.
- [Resources](https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html) — Model checkpoint payloads (`last_checkpoint_id`, position, triggered events) as `Resource` data with `ResourceSaver`/`ResourceLoader`, not ad-hoc globals.
- [Singletons (Autoload)](https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html) — A revival/respawn manager Autoload owns the death → delay → restore loop so levels and UI never `queue_free()` the player.
- [Using signals](https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html) — Emit `player_died` / `player_respawned` / `true_death` so HUD, graves, and analytics subscribe without coupling into the Character script.
- [Groups](https://docs.godotengine.org/en/stable/tutorials/scripting/groups.html) — Resolve the living player via the `Player` group for respawn teleports and soul-grave pickup without brittle node paths.
- [Physics introduction](https://docs.godotengine.org/en/stable/tutorials/physics/physics_introduction.html) — Ghost/spirit modes swap collision layers/masks; never rely on modulate alone to stop hazard overlaps.
- [CharacterBody3D](https://docs.godotengine.org/en/stable/classes/class_characterbody3d.html) — Zero `velocity` (and clear angular impulse) on revive or residual momentum throws the body into walls.
- [SceneTreeTimer](https://docs.godotengine.org/en/stable/classes/class_scenetreetimer.html) — Death→respawn delay and I-frame windows use `create_timer` / one-shot timers so fades and UI can finish before restore.
- [Tween](https://docs.godotengine.org/en/stable/classes/class_tween.html) — Smooth health restitution and I-frame opacity pulses; kill/recreate tweens if the player dies mid-restore.
- [FileAccess](https://docs.godotengine.org/en/stable/classes/class_fileaccess.html) — Append death telemetry JSON lines under `user://` for heatmaps and balancer input.
- [Spatial shader](https://docs.godotengine.org/en/stable/tutorials/shaders/shader_reference/spatial_shader.html) — Spectral downed visuals use spatial `ALPHA`/`EMISSION` pulses instead of hiding the mesh.

### Related Skills

#### Prerequisites
- [godot-signal-architecture](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md) — Death, revive-available, and true-death events need clear ownership so UI, graves, and analytics stay decoupled from the player node.
- [godot-resource-data-patterns](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md) — Checkpoint state and world-progress bitmasks belong in typed Resources with safe save/load, not mutable singletons alone.
- [godot-save-load-systems](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-save-load-systems/SKILL.md) — Checkpoint activation should trigger a durable auto-save path (`user://`) so progress survives crashes mid-run.
- [godot-composition](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-composition/SKILL.md) — Keep revival charges, I-frames, and grave droppers as components rather than baking mortality into a monolithic Character script.

#### Complements
- [godot-combat-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-combat-system/SKILL.md) — Combat `died` / health-zero signals are the usual entry into revival charges, true death, and corpse-run drops.
- [godot-rpg-stats](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-rpg-stats/SKILL.md) — Post-revive health/mana restitution and invincibility flags should write through the same stats layer combat reads.
- [godot-tweening](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-tweening/SKILL.md) — Async restorers and I-frame modulate loops need interruptible Tween lifecycles, not stacked parallel flashes.
- [godot-shaders-basics](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-shaders-basics/SKILL.md) — Spectral/ghost materials and spirit-realm post-process cues live in the shader skill once the revive state machine exists.
- [godot-economy-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-economy-system/SKILL.md) — Corpse-run currency loss and soul-grave recovery must reconcile with the wallet/ledger so pickups cannot duplicate funds.
- [godot-scene-management](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-scene-management/SKILL.md) — Prefer disabling/hiding the existing player instance over reloading the whole level; graves and world progress must outlive the death transition.

#### Downstream / consumers
- [godot-monte-carlo-balancer](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md) — Feed `revival_death_analytics` cause/position logs into Monte Carlo runs to prove difficulty spikes and I-frame TTK bands before shipping.
- [godot-genre-action-rpg](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-action-rpg/SKILL.md) — Souls-like shrine, ghost, and soul-retrieval loops assemble this skill with combat, stats, and save systems.
- [godot-genre-roguelike](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-roguelike/SKILL.md) — Run-ending deaths, meta penalties, and consequence trackers consume revival/true-death outcomes for permadeath or mercy variants.

#### Master
- [godot-master](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-master/SKILL.md) — Library router and mirrored module entry; use when discovering peer skills or syncing shared script mirrors after Domain Skill edits.

