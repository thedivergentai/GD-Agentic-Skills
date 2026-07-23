---
name: godot-game-loop-time-trial
description: Expert patterns for racing mechanics, checkpoint tracking, and ghost recording/playback in Godot 4. Use when building racing games, speed-run platformers, or arcade trials.
---

## Godot 4.7 Baseline

- Expert patterns in this skill target **Godot 4.7+** (stable, 2026-06-18).
- Consult the [Godot 4.7 migration guide](https://docs.godotengine.org/en/4.7/tutorials/migrating/upgrading_to_godot_4.7.html) when upgrading projects from 4.6.
- **NEVER** assume 4.6 defaults (stretch mode, audio area_mask, RichTextLabel percent flags) without checking 4.7 migration notes.

# Time Trial Loop: Arcade Precision

> [!NOTE]
> **Resource Context**: This module provides expert patterns for **Time Trial Loops**. Accessed via Godot Master.

## Architectural Thinking: The "Validation-Chain" Pattern

A Master implementation treats Time Trials as a **State-Validated Sequence**. Recording a time is easy; ensuring the player didn't cheat via shortcuts requires a strictly ordered `CheckpointManager`.

### Core Responsibilities
- **TimeTrialManager**: The central clock. Validates checkpoint order and handles "Best Lap" logic.
- **GhostRecorder**: Captures high-frequency transform data. Uses delta-time timestamps for frame-independent playback.
- **Checkpoint**: Spatial triggers that notify the Manager.

## Expert Code Patterns

### 1. Robust Checkpoint Validation
Prevent "Shortcut Cheating" by requiring checkpoints to be cleared in numerical order.

Wire Area `body_entered` (physics) → `TimeTrialManager.pass_checkpoint(index)`. The manager owns usec timing — see script.

### 2. Space-Efficient Ghosting
Sample at a fixed rate (e.g. 10 Hz). Lerp **position**; **slerp Quaternion** rotation (`ghost_recorder.gd` / `ghost_replayer.gd`). Never Euler-lerp ghost heading.

## Master Decision Matrix: Data Storage

| Format | Best For | Implementation |
| :--- | :--- | :--- |
| **Dictionary Array** | Prototyping | Simple `[{t: 0.1, p: pos}, ...]` |
| **Typed Array** | Performance | `PackedVector3Array` for positions. |
| **JSON/Binary** | Saving | `FileAccess.get_var()` to save ghost files. |

## NEVER Do

- **NEVER use OS.get_ticks_msec() for ultra-precise race timing** — Millisecond resolution is too coarse for high-end racing games. Use `Time.get_ticks_usec()` for microsecond precision.
- **NEVER rely exclusively on _process() for finish line triggers** — Visual frames can skip during lag. Always evaluate physical overlaps in `_physics_process()` to guarantee detection within the fixed physics step.
- **NEVER evaluate Area3D overlaps immediately after instantiation** — The physics server requires at least one physics frame to synchronize. `await get_tree().physics_frame` before checking for players.
- **NEVER scale a CollisionShape3D on a checkpoint non-uniformly** — This breaks the underlying SAT collision math. Always scale the internal shape resource (e.g., `BoxShape3D.size`) instead.
- **NEVER use TCP (reliable) for syncing positions in multiplayer racing** — Congestion algorithms cause huge spikes. Use `ENetMultiplayerPeer` with `TRANSFER_MODE_UNRELIABLE` for high-frequency position updates.
- **NEVER trust client-side finish line/lap crossing** — Always validate triggers on the authoritative server using `multiplayer.is_server()` to prevent cheating.
- **NEVER use standard float equality (==) for record lap times** — Use `is_equal_approx()` to account for precision loss in accumulated time variables.
- **NEVER hardcode input checks without flushing the buffer** — For frame-perfect boost/stop responses, call `Input.flush_buffered_events()` to ensure the engine has processed the latest raw input.
- **NEVER allocate new Vector3 arrays inside fast path-following loops** — This triggers the garbage collector. Use `PackedVector3Array` to maintain a contiguous memory block.
- **NEVER use dynamic string paths ($"../Checkpoint") in tight loops** — Lookups are slow. Use `@onready` to cache node references during initialization.
- **NEVER record the whole player object for ghosts** — Only record core transforms (position/rotation). Recording the whole object is memory-intensive and unnecessary for visual ghosts.
- **NEVER give the ghost collision** — It should be a purely visual indicator (e.g., semi-transparent) to avoid disrupting the player's line.
- **NEVER neglect checkpoint sequencing** — Don't just check if the player hit the finish line. Verify they passed every intermediate checkpoint in the correct order.
- **NEVER use Area3D without monitoring optimization** — Checkpoints should only look for the `Player` physics layer to minimize the number of physics overlap calculations.
- **NEVER use standard lerp for ghost rotation** — Use `slerp()` or `Quaternion.slerp()` to avoid gimbal lock and ensure smooth rotation interpolation.

---

## Available Scripts

> **MANDATORY**: Follow the golden path order. Read each listed script before coding that stage.

### Golden path (MANDATORY)
1. `time_trial_manager.gd` — microsecond (`Time.get_ticks_usec`) or physics-frame clock; `pass_checkpoint` only from physics overlaps / Area signals
2. Checkpoint Areas — ordered indices into the manager (physics frame, not `_process`)
3. `ghost_recorder.gd` — samples `{t, p, q}` with **Quaternion** rotation
4. `ghost_replayer.gd` — position `lerp` + Quaternion `slerp` (never Euler lerp)
5. `time_trial_leaderboard_bridge.gd` — integer usec/msec → UI strings

### Script index
### [time_trial_patterns.gd](scripts/time_trial_patterns.gd)
10 Expert patterns: Microsecond timing, server-authoritative validation, rubber-banding AI, and frame-perfect input flushing.

### [time_trial_manager.gd](scripts/time_trial_manager.gd)
Central clock. Accumulates `Time.get_ticks_usec()` (or physics-frame counts). Finish checks must come from physics overlaps.

### [ghost_recorder.gd](scripts/ghost_recorder.gd)
Captures transform samples with Quaternion `"q"` fields for slerp-safe playback.

### [ghost_replayer.gd](scripts/ghost_replayer.gd)
**MANDATORY** with recorder. Replays samples via position lerp + `Quaternion.slerp`.

### [time_trial_playback_buffer.gd](scripts/time_trial_playback_buffer.gd)
Jitter-buffer for smooth ghost playback during network streaming.

### [time_trial_leaderboard_bridge.gd](scripts/time_trial_leaderboard_bridge.gd)
Formatting utility for converting raw time data to human-readable strings.

---

## Expert Time Trial Patterns

### 1. Delta-Compression for Ghosts
Store a keyframe only when position/rotation changes beyond a threshold. Persist with `FileAccess.open_compressed()` + ZSTD; prefer binary floats over JSON.

### 2. The Leaderboard Bridge
Store records as `int` usec/msec. Format with `%02d:%02d.%03d` for stable UI (e.g. `01:24.450`).

## Reference

> Progressive disclosure: open Official Documentation links only when researching a specific API; load Related Skills when routing to a peer domain — do not preload the whole lattice.

### Official Documentation
- [Time](https://docs.godotengine.org/en/stable/classes/class_time.html) — `get_ticks_usec()` for microsecond lap clocks when `OS.get_ticks_msec()` is too coarse for race records.
- [Idle and Physics Processing](https://docs.godotengine.org/en/stable/tutorials/scripting/idle_and_physics_processing.html) — why finish-line and checkpoint overlap must run in `_physics_process`, not visual `_process` frames that can skip under load.
- [Area3D](https://docs.godotengine.org/en/stable/classes/class_area3d.html) — monitoring, collision masks, and `body_entered` for ordered checkpoint gates without scanning every physics body.
- [Collision shapes (3D)](https://docs.godotengine.org/en/stable/tutorials/physics/collision_shapes_3d.html) — scale shape resources (`BoxShape3D.size`) instead of non-uniform `CollisionShape3D` scale so SAT stays valid on gates.
- [Using transforms](https://docs.godotengine.org/en/stable/tutorials/3d/using_transforms.html) — global position/basis capture for ghost samples and why Euler-only storage needs careful replay conversion.
- [Quaternion](https://docs.godotengine.org/en/stable/classes/class_quaternion.html) — `slerp()` between keyframes so ghost heading avoids gimbal lock from naive Euler lerp.
- [Transform3D](https://docs.godotengine.org/en/stable/classes/class_transform3d.html) — `interpolate_with()` for jitter-buffered network ghost playback between ordered frames.
- [Saving games](https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html) — `FileAccess` / `store_var` patterns for persisting ghost runs and best-time dictionaries without float display round-trips.
- [High-level multiplayer](https://docs.godotengine.org/en/stable/tutorials/networking/high_level_multiplayer.html) — server-authoritative RPC validation so clients cannot fake lap/finish crossings.
- [MultiplayerPeer](https://docs.godotengine.org/en/stable/classes/class_multiplayerpeer.html) — `TRANSFER_MODE_UNRELIABLE` for high-frequency racer transforms where TCP-style reliability spikes latency.
- [Input](https://docs.godotengine.org/en/stable/classes/class_input.html) — `flush_buffered_events()` when frame-perfect boost/stop must see the latest raw input before the physics step.
- [Engine](https://docs.godotengine.org/en/stable/classes/class_engine.html) — `physics_ticks_per_second` / `get_physics_frames()` for integer frame-count timing bridges into MM:SS.mmm UI.

### Related Skills

#### Prerequisites
- [godot-project-foundations](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md) — scene tree, autoloads, and resource layout before wiring a `TimeTrialManager` and checkpoint Areas into a track scene.
- [godot-physics-3d](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-physics-3d/SKILL.md) — Area3D/CollisionShape3D layers, RigidBody/CharacterBody vehicles, and physics-frame overlap rules that make checkpoint sequencing trustworthy.
- [godot-signal-architecture](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md) — typed lap/split/finish signals between gates, manager, HUD, and ghost systems without brittle node-path coupling.
- [godot-gdscript-mastery](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md) — typed arrays, Packed* buffers, `await physics_frame`, and RPC annotations used in timing and authority patterns.

#### Complements
- [godot-input-handling](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-input-handling/SKILL.md) — action maps and buffered boost/steer input that time-trial NEVER rules require to flush before physics.
- [godot-save-load-systems](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-save-load-systems/SKILL.md) — compressed binary ghost files and best-time persistence beyond in-memory sample arrays.
- [godot-multiplayer-networking](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-multiplayer-networking/SKILL.md) — ENet peers, authority, and unreliable transform sync for live races and streamed ghost frames.
- [godot-adapt-single-to-multiplayer](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-adapt-single-to-multiplayer/SKILL.md) — lag compensation, snapshots, and interest patterns when elevating a solo time trial into online racing.
- [godot-navigation-pathfinding](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-navigation-pathfinding/SKILL.md) — NavigationServer3D agent max-speed for rubber-band AI that paces against the player without cheating collision.
- [godot-monte-carlo-balancer](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md) — simulate rubber-band factors, checkpoint difficulty, and target clear times before shipping trial parameters.
- [godot-camera-systems](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-camera-systems/SKILL.md) — chase/replay cameras that must track live cars and non-colliding ghost visuals during playback.

#### Downstream / consumers
- [godot-genre-racing](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-racing/SKILL.md) — full racing genre stack that consumes checkpoint clocks, ghosts, and leaderboard formatting as core loop primitives.
- [godot-game-loop-collection](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-game-loop-collection/SKILL.md) — meta inventory/collection loops that can gate unlocks on validated best times from this skill.

#### Master
- [godot-master](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-master/SKILL.md) — library router and mirrored module entry for cross-skill discovery.
