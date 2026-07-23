---
name: godot-genre-racing
description: "Expert blueprint for racing games including vehicle physics (VehicleBody3D, suspension, friction), checkpoint systems (prevent shortcuts), rubber-banding AI (keep races competitive), drifting mechanics (reduce friction, boost on exit), camera feel (FOV increase with speed, motion blur), and UI (speedometer, lap timer, minimap). Use for arcade racers, kart racing, or realistic sims. Trigger keywords: racing_game, vehicle_physics, checkpoint_system, rubber_banding, drifting_mechanics, camera_feel."
---

## Godot 4.7 Baseline

- Expert patterns in this skill target **Godot 4.7+** (stable, 2026-06-18).
- Consult the [Godot 4.7 migration guide](https://docs.godotengine.org/en/4.7/tutorials/migrating/upgrading_to_godot_4.7.html) when upgrading projects from 4.6.
- **NEVER** assume 4.6 defaults (stretch mode, audio area_mask, RichTextLabel percent flags) without checking 4.7 migration notes.

# Genre: Racing

Expert blueprint for racing games balancing physics, competition, and sense of speed.

## NEVER Do (Expert Anti-Patterns)

### Physics & Handling
- NEVER use a rigid camera attachment; strictly use a **Smooth Follow** pattern with `lerp()` to prevent motion sickness.
- NEVER prioritize realism over fun; strictly increase **Gravity Scale** (2x-3x) and keep friction high for responsive arcade feel.
- NEVER use `VehicleBody3D` default settings for karts; strictly rewrite suspension using Raycasts or custom spring/damper models.
- NEVER apply steering torque directly to mass; strictly use a steering curve factored by lateral velocity.
- NEVER calculate suspension without a damper model; strictly include damping to prevent eternal oscillation (bouncing).
- NEVER ignore the **Center of Mass** property; strictly offset it downward to ensure stability during high-speed turns.
- NEVER multiply engine force by `delta`; it is an integrated force in the physics solver.
- NEVER rely on `is_action_pressed()` for manual gear shifting; strictly use `is_action_just_pressed()` for single-tap accuracy.

### AI & Competition
- NEVER use static AI speeds; strictly use **Rubber-Banding** to keep races competitive based on player distance.
- NEVER run AI pathfinding across the entire track every frame; strictly use a "Look-Ahead" point on a spline/path.
- NEVER ignore racing **Checkpoints**; strictly enforce sequential `Area3D` validation to prevent track shortcuts.
- NEVER use standard `Area3D` for slipstreaming without a **Dot Product** check to ensure the player is directly behind.

### Visuals & Audio
- NEVER skip "Sense of Speed" effects; strictly implement dynamic **FOV scaling**, motion blur, and high-speed camera shake.
- NEVER update minimap transforms for static elements in `_process()`; strictly update dynamic racers only.
- NEVER serialize ghost cars as mass transform lists; strictly store positions/quaternions at fixed intervals.
- NEVER use constant pitch for engine sounds; strictly map RPM or engine load to `pitch_scale`.
- NEVER spawn particles for skid marks every frame; strictly use **Trail3D** or procedural strips for low-cost persistence.
- NEVER use standard Strings for surface detection; strictly use `StringName` (e.g., `&"asphalt"`).

---

## 🛠 Expert Components (scripts/)

### Original Expert Patterns
- [arcade_vehicle_physics.gd](../scripts/genre_racing_arcade_vehicle_physics.gd) - High-performance arcade handling with custom gravity, air control, and friction-slip drifting.
- [spline_ai_controller.gd](../scripts/genre_racing_spline_ai_controller.gd) - Professional racing AI using Path3D predictive steering and rubber-banding logic.

### Modular Components
- [arcade_vehicle_controller.gd](../scripts/genre_racing_arcade_vehicle_controller.gd) - Alternative tight, raycast-based vehicle movement model for non-physics karts.
- [raycast_vehicle_controller.gd](../scripts/genre_racing_raycast_vehicle_controller.gd) - RigidBody3D + RayCast suspension for crisp arcade sims.
- [lap_checkpoint_manager.gd](../scripts/genre_racing_lap_checkpoint_manager.gd) - Sequential checkpoint / lap authority.
- [spline_track_spawner.gd](../scripts/genre_racing_spline_track_spawner.gd) - Path3D track scaffolding for AI lines.
- [slipstream_handler.gd](../scripts/genre_racing_slipstream_handler.gd) - Drafting zones with relative dot-product checks for speed boosts.
- [lap_tracker.gd](../scripts/genre_racing_lap_tracker.gd) - High-precision lap management with sequential checkpoint logic.
- [ghost_recorder.gd](../scripts/genre_racing_ghost_recorder.gd) - Binary transform serialization for lightweight ghost car playback.
- [engine_audio_controller.gd](../scripts/genre_racing_engine_audio_controller.gd) - RPM-to-pitch audio synthesis for engine revving and gear shifts.
- [skid_mark_emitter.gd](../scripts/genre_racing_skid_mark_emitter.gd) - Conditional tire-slip trail system for persistent visual feedback.
- [minimap_icon_projector.gd](../scripts/genre_racing_minimap_icon_projector.gd) - 3D-to-2D bridge for projecting racers onto a localized UI.
- [force_feedback_router.gd](../scripts/genre_racing_force_feedback_router.gd) - Haptic and rumble management based on terrain and collisions.
- [raycast_suspension.gd](../scripts/genre_racing_raycast_suspension.gd) - Spring/damper model for raycast wheels with configurable stiffness.
- [racing_checkpoint.gd](../scripts/genre_racing_racing_checkpoint.gd) - Indexed trigger gate for modular track-based lap progression.

---

## Core Loop
1.  **Race**: Player controls a vehicle on a track.
2.  **Compete**: Player overtakes opponents or beats the clock.
3.  **Upgrade**: Player earns currency/points to buy parts/cars.
4.  **Tune**: Player adjusts vehicle stats (grip, acceleration).
5.  **Master**: Player learns track layouts and optimal lines.

## Related Skills (build order)

Use the **Reference → Related Skills** lattice — do not invent skill ids:

1. **Prerequisites** — [godot-project-foundations](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md), [godot-physics-3d](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-physics-3d/SKILL.md), [godot-input-handling](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-input-handling/SKILL.md)
2. **Complements** — [godot-camera-systems](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-camera-systems/SKILL.md), [godot-ai-navigation](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ai-navigation/SKILL.md), [godot-particles](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-particles/SKILL.md), [godot-ui-containers](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md), [godot-raycasting-queries](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-raycasting-queries/SKILL.md)
3. **Downstream** — [godot-save-load-systems](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-save-load-systems/SKILL.md), [godot-economy-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-economy-system/SKILL.md)

## Decision Tree — Vehicle Model

| Feel | Choose | **MANDATORY** |
|------|--------|---------------|
| VehicleBody3D arcade (torque / wheel slip) | Built-in wheels + gravity/friction tweaks | [arcade_vehicle_physics.gd](../scripts/genre_racing_arcade_vehicle_physics.gd) |
| Custom suspension / kart crispness | RigidBody3D + RayCast springs | [raycast_vehicle_controller.gd](../scripts/genre_racing_raycast_vehicle_controller.gd) (+ [raycast_suspension.gd](../scripts/genre_racing_raycast_suspension.gd)) |

Do **not** paste a bare `VehicleBody3D` sample — read the chosen script first. Optional input shim: [arcade_vehicle_controller.gd](../scripts/genre_racing_arcade_vehicle_controller.gd).

## Golden Path (script order)

1. **Vehicle** — pick physics script above.
2. **Checkpoints / laps** — [racing_checkpoint.gd](../scripts/genre_racing_racing_checkpoint.gd) → [lap_checkpoint_manager.gd](../scripts/genre_racing_lap_checkpoint_manager.gd) / [lap_tracker.gd](../scripts/genre_racing_lap_tracker.gd).
3. **AI** — [spline_track_spawner.gd](../scripts/genre_racing_spline_track_spawner.gd) → [spline_ai_controller.gd](../scripts/genre_racing_spline_ai_controller.gd).
4. **Ghost** — [ghost_recorder.gd](../scripts/genre_racing_ghost_recorder.gd).

Also wire as needed: [slipstream_handler.gd](../scripts/genre_racing_slipstream_handler.gd), [skid_mark_emitter.gd](../scripts/genre_racing_skid_mark_emitter.gd), [engine_audio_controller.gd](../scripts/genre_racing_engine_audio_controller.gd), [force_feedback_router.gd](../scripts/genre_racing_force_feedback_router.gd), [minimap_icon_projector.gd](../scripts/genre_racing_minimap_icon_projector.gd).

## Floaty Physics / Feel — Fallback Table

| Symptom | Knob | Where |
|---------|------|-------|
| Car floats / weak stick | Raise `gravity_scale` (≈2–3×); Fun > raw realism | [arcade_vehicle_physics.gd](../scripts/genre_racing_arcade_vehicle_physics.gd) |
| Tips / rolls easily | Lower COM (`center_of_mass_mode` + offset) | VehicleBody3D / RigidBody3D |
| Ice-skating lateral slip | Raise `wheel_friction_slip` / `normal_friction_slip`; lower drift slip only while drifting | [arcade_vehicle_physics.gd](../scripts/genre_racing_arcade_vehicle_physics.gd) |
| Raycast kart too bouncy | Tune `spring_stiffness` / `spring_damping` / `tire_grip` | [raycast_vehicle_controller.gd](../scripts/genre_racing_raycast_vehicle_controller.gd), [raycast_suspension.gd](../scripts/genre_racing_raycast_suspension.gd) |
| Bad / rigid camera | `Marker3D` + lerp follow; never hard-parent to chassis | [godot-camera-systems](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-camera-systems/SKILL.md) |
| Tunnel vision / no speed read | Scale FOV with speed; optional shake, wind lines, motion blur | Camera3D + Environment; FOV tween on boost |

## Advanced Racing Meta-Systems

Do **not** paste inline DriftBoost/Ghost samples — extend the scripts:

1. **Drift-Boost / Mini-Turbo** — **MANDATORY**: use drift hooks in [arcade_vehicle_physics.gd](../scripts/genre_racing_arcade_vehicle_physics.gd) (`is_drifting`, `drift_friction_slip`); charge + `apply_central_impulse` on release; brief Camera FOV tween for boost feel.
2. **Tire-Smoke / skids** — **MANDATORY**: [skid_mark_emitter.gd](../scripts/genre_racing_skid_mark_emitter.gd) gated by `get_skidinfo()`; pair with [godot-particles](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-particles/SKILL.md) — never spawn particles every physics frame.
3. **Replay-Ghost binary** — **MANDATORY**: [ghost_recorder.gd](../scripts/genre_racing_ghost_recorder.gd) for transform serialization; persist via [godot-save-load-systems](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-save-load-systems/SKILL.md).

## Reference

> Progressive disclosure: open Official Documentation links only when researching a specific API; load Related Skills when routing to a peer domain — do not preload the whole lattice.

### Official Documentation
- [VehicleBody3D](https://docs.godotengine.org/en/stable/classes/class_vehiclebody3d.html) — built-in chassis forces, steering, and engine_force integration for arcade/sim hybrids.
- [VehicleWheel3D](https://docs.godotengine.org/en/stable/classes/class_vehiclewheel3d.html) — per-wheel friction_slip, suspension, and skidinfo used by drift and tire-smoke logic.
- [Rigid body](https://docs.godotengine.org/en/stable/tutorials/physics/rigid_body.html) — RigidBody3D force/impulse discipline for custom raycast vehicles and drift-boost impulses.
- [Ray-casting](https://docs.godotengine.org/en/stable/tutorials/physics/ray-casting.html) — RayCast3D suspension, ground contact, and look-ahead probes without full nav mesh queries.
- [Path3D](https://docs.godotengine.org/en/stable/classes/class_path3d.html) — racing-line curves that spline AI and track spawners sample each physics tick.
- [Curve3D](https://docs.godotengine.org/en/stable/classes/class_curve3d.html) — baked samples and up-vectors for banked track props and look-ahead steering points.
- [Area3D](https://docs.godotengine.org/en/stable/classes/class_area3d.html) — checkpoint gates and slipstream draft volumes with body_entered ownership.
- [Camera3D](https://docs.godotengine.org/en/stable/classes/class_camera3d.html) — FOV and follow transforms that sell sense-of-speed without rigid mount sickness.
- [Controllers, gamepads, and joysticks](https://docs.godotengine.org/en/stable/tutorials/inputs/controllers_gamepads_joysticks.html) — analog steer/throttle deadzones and force-feedback routing for racing pads.
- [Audio streams](https://docs.godotengine.org/en/stable/tutorials/audio/audio_streams.html) — pitch_scale / player setup for RPM-mapped engine loops and Doppler pass-bys.
- [Environment and post-processing](https://docs.godotengine.org/en/stable/tutorials/3d/environment_and_post_processing.html) — motion blur and camera attributes that reinforce high-speed FOV ramps.
- [Binary serialization API](https://docs.godotengine.org/en/stable/tutorials/io/binary_serialization_api.html) — compact ghost/replay transform storage via FileAccess store_var.

### Related Skills

#### Prerequisites
- [godot-project-foundations](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md) — scene tree, InputMap actions, and Project Settings physics layers before wiring VehicleBody3D tracks.
- [godot-physics-3d](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-physics-3d/SKILL.md) — RigidBody3D/VehicleBody3D integration, collision layers, and gravity scale patterns racing handling depends on.
- [godot-input-handling](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-input-handling/SKILL.md) — analog axes, just-pressed gear/drift taps, and gamepad deadzone curves for steering authority.

#### Complements
- [godot-camera-systems](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-camera-systems/SKILL.md) — smooth follow, FOV ramps, and shake that sell speed without rigid camera mounts.
- [godot-audio-systems](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-audio-systems/SKILL.md) — bus layout, Doppler, and layered engine/tire loops beyond a single pitch_scale mapping.
- [godot-raycasting-queries](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-raycasting-queries/SKILL.md) — suspension rays, surface probes, and look-ahead casts shared with custom kart controllers.
- [godot-ai-navigation](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ai-navigation/SKILL.md) — when spline rubber-banding is not enough and opponents need NavigationAgent3D detours around blockers.
- [godot-particles](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-particles/SKILL.md) — tire smoke, sparks, and trail meshes gated by skidinfo instead of per-frame GPUParticles spam.
- [godot-signal-architecture](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md) — lap_completed, checkpoint, and race-state signals without cross-scene ownership loops.
- [godot-ui-containers](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md) — speedometer, lap timer, and minimap HUD layout that stays readable at race pace.

#### Downstream / consumers
- [godot-monte-carlo-balancer](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md) — sample rubber-band curves, drift-boost windows, and AI look-ahead knobs for competitive fairness.
- [godot-economy-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-economy-system/SKILL.md) — post-race currency and part upgrades that consume lap/placement outcomes from this genre loop.
- [godot-save-load-systems](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-save-load-systems/SKILL.md) — persist ghost binaries, best laps, and unlock state built on race recordings.

#### Master
- [godot-master](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-master/SKILL.md) — library router and mirrored module entry for cross-skill discovery.
