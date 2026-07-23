---
name: godot-genre-fighting
description: "Expert blueprint for fighting games including frame data (startup/active/recovery frames, advantage on hit/block), hitbox/hurtbox systems, input buffering (5-10 frames), motion input detection (QCF, DP), combo systems (damage scaling, cancel hierarchy), character states (idle/attacking/hitstun/blockstun), and rollback netcode. Based on FGC competitive design. Trigger keywords: fighting_game, frame_data, hitbox_hurtbox, input_buffer, motion_inputs, combo_system, rollback_netcode, cancel_system, advantage_frames."
---

## Godot 4.7 Baseline

- Expert patterns in this skill target **Godot 4.7+** (stable, 2026-06-18).
- Consult the [Godot 4.7 migration guide](https://docs.godotengine.org/en/4.7/tutorials/migrating/upgrading_to_godot_4.7.html) when upgrading projects from 4.6.
- **NEVER** assume 4.6 defaults (stretch mode, audio area_mask, RichTextLabel percent flags) without checking 4.7 migration notes.

# Genre: Fighting Game

Expert blueprint for 2D/3D fighters emphasizing frame-perfect combat and competitive balance.

## NEVER Do (Expert Anti-Patterns)

### Frame-Data & Logic
- NEVER use variable framerates; strictly lock logic to a **Deterministic Fixed Loop** (using `_physics_process` with a frame-counter) and call **`reset_physics_interpolation()`** on teleport.
- NEVER use standard Physics for hit detection; strictly use **`PhysicsDirectSpaceState.intersect_shape()`** to query hitboxes instantly without Area2D signal lag.
- NEVER skip **Damage Scaling**; strictly apply 10% reduction per hit in a combo to prevent infinite matches.
- NEVER make all moves safe on block; strictly ensure high-reward moves have **Recovery Windows** where the attacker is punishable.
- NEVER rely on `Area2D.get_overlapping_areas()`; strictly use **`intersect_shape()`** for immediate, frame-perfect resolution.
- NEVER forget **Hitbox Proximity (Proximity Guard)**; strictly trigger guard states when a hitbox enters a nearby zone, even if it hasn't landed.

### Character & Animation
- NEVER use simple parenting (`scale.x = -1`) for character flip; strictly adjust the dedicated **Visuals node** while managing hitbox offsets programmatically.
- NEVER use string-based animation triggers; strictly use `AnimationMixer` with `ADVANCE_MANUAL` for frame-synced playback.
- NEVER use `yield` or `await` for frame-critical logic; strictly use **Integer Frame Counting** within state machines to manage recovery/startup windows perfectly.
- NEVER store frame data in raw scripts; strictly use **`Resource` files (.tres)** with delegated logic for damage scaling, cancels, and combo-state tracking.
- NEVER use deep node hierarchies for character parts; strictly keep skeletons shallow to reduce transformation overhead.

### Input & Networking
- NEVER skip **Input Buffering**; strictly implement a 5-10 frame buffer to ensure lenient, responsive execution for the player.
- NEVER leave `Input.use_accumulated_input` enabled; strictly disable it to preserve sub-frame timing for precise combo links.
- NEVER use client-side hit detection for netplay; strictly use **rollback netcode** or server validation to prevent desyncs.
- NEVER use standard TCP for multiplayer; strictly use **UDP/ENet** to avoid head-of-line blocking during latency spikes.
- NEVER rely on the SceneTree for fighter transforms in netplay; strictly manage positions in a **serializable data buffer**.

---

## 🛠 Expert Components (scripts/)

> **MANDATORY reads** before implementing the matching system:
> 1. [fighting_input_buffer.gd](scripts/fighting_input_buffer.gd) — buffers + motion (QCF/DP)
> 2. [direct_hitbox_query.gd](scripts/direct_hitbox_query.gd) — **exclusive** hit resolution path (`intersect_shape`)
> 3. [rollback_state_serializer.gd](scripts/rollback_state_serializer.gd) — snapshot/restore for netplay

### Original Expert Patterns
- [fighting_input_buffer.gd](scripts/fighting_input_buffer.gd) - Frame-locked input engine (60fps) with motion command fuzzy matching (QCF/DP).
- [hitbox_component.gd](scripts/hitbox_component.gd) - Hitbox/hurtbox volume helper (layers High/Low/Throw) — resolve hits via **direct_hitbox_query**, not Area signals.

### Modular Components
- [deterministic_physics_loop.gd](scripts/deterministic_physics_loop.gd) - Custom loop pattern for frame-perfect game state progression.
- [direct_hitbox_query.gd](scripts/direct_hitbox_query.gd) - PhysicsServer shape-casting for immediate collision resolution.
- [hit_stop_controller.gd](scripts/hit_stop_controller.gd) - Dynamic time-scale manipulation for "impact" feel.
- [manual_animation_advancer.gd](scripts/manual_animation_advancer.gd) - Frame-synced animation control via manual delta processing.
- [rollback_state_serializer.gd](scripts/rollback_state_serializer.gd) - Serialization logic for managing discrete game state snapshots.
- [bitwise_state_flags.gd](scripts/bitwise_state_flags.gd) - High-performance bitwise flags for fighter state tracking.
- [input_accumulation_control.gd](scripts/input_accumulation_control.gd) - Toggle for disabling Godot's input accumulation for sub-frame timing.
- [raw_byte_network_sync.gd](scripts/raw_byte_network_sync.gd) - UDP-based state synchronization for netplay efficiency.
- [string_name_optimization.gd](scripts/string_name_optimization.gd) - Pattern for using pointer-level `StringName` comparisons in AI states.
- [round_timer_logic.gd](scripts/round_timer_logic.gd) - Logic for frame-synced match timers and timeout triggers.

---

## Core Loop

`Neutral → Confirm Hit → Combo → Advantage → Repeat`

## Decision Trees (no Area2D / inline system dumps)

### Frames & fixed loop
| Need | Action |
|------|--------|
| Attack timing Resource | `.tres` with startup/active/recovery/advantage — not script constants |
| 60fps sim step | [deterministic_physics_loop.gd](scripts/deterministic_physics_loop.gd) |
| Anim sync to frames | [manual_animation_advancer.gd](scripts/manual_animation_advancer.gd) (`ADVANCE_MANUAL`) |

### Input
| Need | Action |
|------|--------|
| 5–10f buffer + QCF/DP | **MANDATORY** [fighting_input_buffer.gd](scripts/fighting_input_buffer.gd) |
| Sub-frame links | [input_accumulation_control.gd](scripts/input_accumulation_control.gd) — disable accumulated input |

### Hitboxes
| Need | Action |
|------|--------|
| Frame-perfect hit | **MANDATORY exclusively** [direct_hitbox_query.gd](scripts/direct_hitbox_query.gd) |
| Volume authoring helper | [hitbox_component.gd](scripts/hitbox_component.gd) for shapes/layers — **never** `area_entered` / `get_overlapping_areas` for resolution |
| Proximity guard | Query expanded shape before active frames land |

### Combos / cancels
| Need | Action |
|------|--------|
| Damage scaling ~10%/hit | Track in combo state; store cancel hierarchy on Attack Resources |
| States | IDLE/ATTACKING/HITSTUN/BLOCKSTUN… with integer `state_frame` — peer [godot-state-machine-advanced](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-state-machine-advanced/SKILL.md) |

### Netcode
| Need | Action |
|------|--------|
| Snapshots | **MANDATORY** [rollback_state_serializer.gd](scripts/rollback_state_serializer.gd) |
| Transport | UDP/ENet via [raw_byte_network_sync.gd](scripts/raw_byte_network_sync.gd); peer [godot-multiplayer-networking](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-multiplayer-networking/SKILL.md) |

---

## Balance Guidelines

| Element | Guideline |
|---------|-----------|
| Health | 10,000-15,000 for ~20 second rounds |
| Combo damage | Max 30-40% of health per touch |
| Fastest moves | 3-5 frames startup (jabs) |
| Slowest moves | 20-40 frames (supers, overheads) |
| Throw range | Short but reliable |
| Meter gain | Full bar in ~2 combos received |

For roster / matchup simulation, use [godot-monte-carlo-balancer](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md).

## Common Pitfalls

| Pitfall | Solution |
|---------|----------|
| Infinite combos | Hitstun decay + gravity scaling |
| Area2D signal hits | Replace with [direct_hitbox_query.gd](scripts/direct_hitbox_query.gd) |
| Lag input drops | Buffer 8+ frames |
| Desync | Deterministic loop + rollback serializer |

## Reference

> Progressive disclosure: open Official Documentation links only when researching a specific API;
> load Related Skills when routing work to a peer domain — do not preload the whole lattice.

### Official Documentation
- [Idle and physics processing](https://docs.godotengine.org/en/stable/tutorials/scripting/idle_and_physics_processing.html) — Fighting logic must run on a fixed physics tick (or custom frame counter), not variable `_process` deltas.
- [Input](https://docs.godotengine.org/en/stable/classes/class_input.html) — Disable `use_accumulated_input` and sample actions per frame so buffers and motion windows stay deterministic.
- [Input examples](https://docs.godotengine.org/en/stable/tutorials/inputs/input_examples.html) — Action maps and event handling patterns behind 5–10 frame buffers and motion detection.
- [Controllers, gamepads, and joysticks](https://docs.godotengine.org/en/stable/tutorials/inputs/controllers_gamepads_joysticks.html) — Stick deadzones and digital gate thresholds for clean QCF/DP direction history.
- [Using Area2D](https://docs.godotengine.org/en/stable/tutorials/physics/using_area_2d.html) — Hitbox/hurtbox volumes, monitoring vs monitorable, and why signal lag is often too late for frame-perfect trades.
- [Physics introduction](https://docs.godotengine.org/en/stable/tutorials/physics/physics_introduction.html) — Collision layers/masks for High/Low/Throw filtering instead of string groups in the hot path.
- [PhysicsDirectSpaceState2D](https://docs.godotengine.org/en/stable/classes/class_physicsdirectspacestate2d.html) — Immediate `intersect_shape` hit resolution without waiting on `Area2D` overlap signals.
- [PhysicsShapeQueryParameters2D](https://docs.godotengine.org/en/stable/classes/class_physicsshapequeryparameters2d.html) — Shape query setup (mask, exclude, collide_with_areas) for direct hitbox checks.
- [AnimationMixer](https://docs.godotengine.org/en/stable/classes/class_animationmixer.html) — `ADVANCE_MANUAL` / callback mode so attack clips advance in lockstep with integer frame data.
- [Resources](https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html) — Store startup/active/recovery, cancels, and balance profiles as `.tres` data—not hardcoded script constants.
- [High-level multiplayer](https://docs.godotengine.org/en/stable/tutorials/networking/high_level_multiplayer.html) — Authority, RPCs, and peer roles when adding netplay around a deterministic fighter sim.
- [ENetMultiplayerPeer](https://docs.godotengine.org/en/stable/classes/class_enetmultiplayerpeer.html) — UDP/ENet transport for rollback-friendly input exchange without TCP head-of-line blocking.

### Related Skills

#### Prerequisites
- [godot-project-foundations](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md) — Physics tick rate, input map, and project defaults must be locked before frame-data systems stay deterministic.
- [godot-input-handling](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-input-handling/SKILL.md) — Action sampling, device mapping, and buffer-friendly input plumbing under motion commands and cancels.
- [godot-2d-physics](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-2d-physics/SKILL.md) — Layers/masks and direct space queries are the substrate for hitbox/hurtbox resolution without Area signal lag.
- [godot-characterbody-2d](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-characterbody-2d/SKILL.md) — Grounded movement, facing, and teleport/`reset_physics_interpolation` contracts fighters still need outside pure hit detection.

#### Complements
- [godot-combat-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-combat-system/SKILL.md) — Shared DamageData / hit confirm patterns that fighting frame data specializes into startup-active-recovery windows.
- [godot-animation-player](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-animation-player/SKILL.md) — Hitbox enable tracks, cancel frames, and recovery locks driven from animation rather than free-running timers.
- [godot-state-machine-advanced](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-state-machine-advanced/SKILL.md) — IDLE/ATTACKING/HITSTUN/BLOCKSTUN FSMs with integer `state_frame` counters instead of `await`-based recovery.
- [godot-resource-data-patterns](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md) — Move lists, cancel tables, and FighterBalanceProfile resources with safe duplication per fighter instance.
- [godot-signal-architecture](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md) — Hit confirm, round end, and HUD events without coupling the sim loop to presentation nodes.
- [godot-multiplayer-networking](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-multiplayer-networking/SKILL.md) — Peer sync, RPC discipline, and authoritative validation around rollback or delayed-input netcode.
- [godot-adapt-single-to-multiplayer](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-adapt-single-to-multiplayer/SKILL.md) — Prediction, reconciliation, and lobby/late-join patterns when a local fighter becomes netplay-ready.

#### Downstream / consumers
- [godot-monte-carlo-balancer](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md) — Simulate matchup matrices, damage scaling, and punish windows across the roster instead of guessing from AFK→pro PvE bands.

#### Master
- [godot-master](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-master/SKILL.md) — Library router and mirrored module entry for discovering fighting peers and syncing shared script mirrors.
