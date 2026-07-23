---
name: godot-camera-systems
description: "Expert patterns for 2D/3D camera control including smooth following (lerp, position_smoothing), camera shake (trauma system), screen shake with frequency parameters, deadzone/drag for platformers, look-ahead prediction, and camera transitions. Use for player cameras, cinematic sequences, or multi-camera systems. Trigger keywords: Camera2D, Camera3D, SpringArm3D, position_smoothing, camera_shake, trauma_system, look_ahead, drag_margin, camera_limits, camera_transition."
---

## Godot 4.7 Baseline

- Expert patterns in this skill target **Godot 4.7+** (stable, 2026-06-18).
- Consult the [Godot 4.7 migration guide](https://docs.godotengine.org/en/4.7/tutorials/migrating/upgrading_to_godot_4.7.html) when upgrading projects from 4.6.
- **NEVER** assume 4.6 defaults (stretch mode, audio area_mask, RichTextLabel percent flags) without checking 4.7 migration notes.

# Camera Systems

Smooth, stable 2D/3D cameras — scripts first; no Basics/Best-Practices tutorial dump.

## NEVER Do

- **NEVER use `global_position = target.global_position` every frame** — Instant position matching causes jittery movement. Use `lerp()` or `position_smoothing_enabled = true`.
- **NEVER use `offset` for permanent camera positioning** — `offset` is for shake, sway, or temporary recoil effects only. Use `position` for permanent framing.
- **NEVER forget `limit_smoothed = true` for `Camera2D`** — Hard boundaries cause jarring visual stops.
- **NEVER enable multiple `Camera2D` nodes in the same viewport simultaneously** — Only the last enabled camera takes precedence. Explicitly disable inactive cameras.
- **NEVER use `SpringArm3D` without a collision mask** — It will clip through terrain and walls. Set it to the world/environment layer.
- **NEVER implement screen shake by randomizing `position` (or `randf` on `offset` as the whole system)** — Use a dedicated Trauma/Noise system layered on follow ([camera_shake_trauma_pro.gd](scripts/camera_shake_trauma_pro.gd)).
- **NEVER parent the Camera directly to a high-speed physics body as the default rig** — Physics stutter or parent rotation causes motion sickness. Prefer `RemoteTransform2D/3D` / phantom decoupling with rotation sync disabled ([remote_transform_decoupling.gd](scripts/remote_transform_decoupling.gd), [phantom_decoupling.gd](scripts/phantom_decoupling.gd)).
- **NEVER use `look_at()` in 3D without a fallback for the 'Up' vector** — Targets directly above/below flip the camera; use guards or Quaternion math.
- **NEVER rely on `SubViewport` defaults for Mini-maps** — Set `render_target_update_mode` to `UPDATE_WHEN_VISIBLE` or a lower fixed rate.
- **NEVER use linear interpolation for Zoom** — Prefer exponential lerp or Tween `TRANS_CUBIC`.

---

## Parenting / Decoupling (resolved)

| Rig | When | Script |
|-----|------|--------|
| **Default:** RemoteTransform / phantom | Player is CharacterBody / high-speed / rotates | [remote_transform_decoupling.gd](scripts/remote_transform_decoupling.gd), [phantom_decoupling.gd](scripts/phantom_decoupling.gd) |
| Camera as child of player | Slow top-down / locked rotation / prototype only | Explicit caveat: disable if motion sickness or physics jitter appears; never combine with position-overwrite shake |
| SpringArm3D + Camera3D | Third-person occlusion | [spring_lerp_camera_3d.gd](scripts/spring_lerp_camera_3d.gd) — mask required |

## Available Scripts

> **MANDATORY**: Read before implementing the matching behavior. No `randf` shake samples in project code.

- [camera_shake_trauma_pro.gd](scripts/camera_shake_trauma_pro.gd) — **MANDATORY** for any screen shake / impact juice.
- [camera_shake_trauma.gd](scripts/camera_shake_trauma.gd) — Lighter trauma variant.
- [remote_transform_decoupling.gd](scripts/remote_transform_decoupling.gd) — **MANDATORY** default for physics-body follow.
- [phantom_decoupling.gd](scripts/phantom_decoupling.gd) — Alternate stable follow phantom.
- [spring_lerp_camera_3d.gd](scripts/spring_lerp_camera_3d.gd) — **MANDATORY** before custom 3D follow springs.
- [deadzone_drag_margins.gd](scripts/deadzone_drag_margins.gd) — Platformer drag/deadzone.
- [camera_follow_2d.gd](scripts/camera_follow_2d.gd) — Smooth 2D follow helpers.
- [zoom_damping_controller.gd](scripts/zoom_damping_controller.gd) — Non-linear zoom.
- [camera_state_machine.gd](scripts/camera_state_machine.gd) — Follow / Static / Cinematic transitions.
- [cinematic_framing_logic.gd](scripts/cinematic_framing_logic.gd) — Rule of thirds / lead room.
- [minimap_viewport_manager.gd](scripts/minimap_viewport_manager.gd) — SubViewport update modes.
- [split_screen_setup.gd](scripts/split_screen_setup.gd) — Local multi camera viewports.
- [first_person_sway.gd](scripts/first_person_sway.gd) — FPS bob/sway on offset.
- [juice_camera.gd](scripts/juice_camera.gd) — Combined juice helpers.

## Expert Camera Architectures

### 1. Multi-target framing
Compute AABB of targets → lerp camera to center → zoom/distance to fit with margin. Keep juice shake on `offset` only.

### 2. Occlusion (3D)
Prefer `SpringArm3D` with world collision mask; custom rigs use `intersect_ray` between ideal camera pos and target (see peer `godot-raycasting-queries`).

### 3. Trauma audit
Plot trauma decay (debug draw) while tuning [camera_shake_trauma_pro.gd](scripts/camera_shake_trauma_pro.gd) — never validate feel with raw `randf` offset demos.

## Reference

> Progressive disclosure: open Official Documentation links only when researching a specific API; load Related Skills when routing to a peer domain — do not preload the whole lattice.

### Official Documentation
- [Camera2D](https://docs.godotengine.org/en/stable/classes/class_camera2d.html) — Position/drag margins, `limit_*` / `limit_smoothed`, and `position_smoothing_*` that underpin 2D follow, deadzones, and level bounds.
- [Camera3D](https://docs.godotengine.org/en/stable/classes/class_camera3d.html) — Projection, `look_at`, current-camera rules, and environment overrides used by third-person, FPS, and cinematic 3D rigs.
- [Third-person camera with spring arm](https://docs.godotengine.org/en/stable/tutorials/3d/spring_arm.html) — Why parenting a Camera3D alone clips geometry and how SpringArm3D length/shape keep the view clear.
- [SpringArm3D](https://docs.godotengine.org/en/stable/classes/class_springarm3d.html) — Collision mask, margin, and spring length API required before third-person occlusion pulls feel trustworthy.
- [Using Viewports](https://docs.godotengine.org/en/stable/tutorials/rendering/viewports.html) — Multiple cameras, SubViewport architecture, and when split-screen / minimap views share or isolate worlds.
- [SubViewport](https://docs.godotengine.org/en/stable/classes/class_subviewport.html) — `render_target_update_mode` and audio-listener flags that decide minimap and local-coop GPU/audio cost.
- [RemoteTransform2D](https://docs.godotengine.org/en/stable/classes/class_remotetransform2d.html) — Decouple camera position from player rotation/scale without parenting the camera under a physics body.
- [Interpolation](https://docs.godotengine.org/en/stable/tutorials/math/interpolation.html) — Lerp / exponential follow and zoom damping math so custom cameras do not feel robotic or jittery.
- [Physics interpolation (introduction)](https://docs.godotengine.org/en/stable/tutorials/physics/interpolation/physics_interpolation_introduction.html) — Why cameras following CharacterBody motion stutter when render and physics ticks disagree.
- [FastNoiseLite](https://docs.godotengine.org/en/stable/classes/class_fastnoiselite.html) — Coherent noise for trauma/offset shake instead of raw `randf` position thrashing.
- [PathFollow2D](https://docs.godotengine.org/en/stable/classes/class_pathfollow2d.html) — Progress-ratio driven cinematic paths when Tweening a camera along a Path2D.
- [Mouse and input coordinates](https://docs.godotengine.org/en/stable/tutorials/inputs/mouse_and_input_coordinates.html) — Wheel zoom and mouse-look coordinate spaces so FPS pitch/yaw and tactical zoom stay consistent across viewports.

### Related Skills

#### Prerequisites
- [godot-project-foundations](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md) — Stretch mode, default viewport, and input map setup decide how Camera2D limits and SubViewport sizes behave before any follow script runs.
- [godot-gdscript-mastery](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md) — Typed nodes, `_physics_process` vs `_process`, and Tween/await patterns used by state machines and spring follow.
- [godot-input-handling](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-input-handling/SKILL.md) — Captured mouse, look axes, and mouse-wheel events feed FPS look, zoom damping, and camera orbit controls.

#### Complements
- [godot-tweening](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-tweening/SKILL.md) — Camera transitions between Follow/Static/Cinematic should use Tweens (ease/trans), not hard snaps or linear zoom.
- [godot-characterbody-2d](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-characterbody-2d/SKILL.md) — Look-ahead and deadzone cameras need real velocity / floor state from the platformer body they frame.
- [godot-physics-3d](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-physics-3d/SKILL.md) — SpringArm collision layers and CharacterBody3D motion are the 3D counterparts to stable third-person and FPS sway parents.
- [godot-raycasting-queries](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-raycasting-queries/SKILL.md) — Custom occlusion-aware cameras that do not use SpringArm still need correct `intersect_ray` masks and excludes.
- [godot-state-machine-advanced](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-state-machine-advanced/SKILL.md) — Formalize Follow/Static/Cinematic (and cutscene ownership) when camera_state_machine outgrows a simple enum.
- [godot-signal-architecture](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md) — Trauma add, cutscene handoff, and multi-target framing should be signal-driven so gameplay never reaches into camera internals.

#### Downstream / consumers
- [godot-performance-optimization](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md) — Escalate when SubViewport minimaps, split-screen, or always-on secondary cameras still dominate frame time after update-mode tuning.
- [godot-monte-carlo-balancer](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md) — Simulate shake intensity, zoom fairness, and multi-target framing so camera juice never hides hitboxes or competitive information.
- [godot-adapt-single-to-multiplayer](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-adapt-single-to-multiplayer/SKILL.md) — Consumes split-screen SubViewport patterns when local coop needs per-player cameras and listener ownership.
- [godot-debugging-profiling](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md) — Use monitors and visualizers to prove camera jitter sources (physics tick, RemoteTransform, trauma) before rewriting follow math.

#### Master
- [godot-master](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-master/SKILL.md) — Library router and mirrored module entry; open when discovering which Domain Skill owns a cross-cutting camera concern.
