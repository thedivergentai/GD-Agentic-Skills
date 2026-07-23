---
name: godot-genre-platformer
description: "Expert blueprint for platformer games including precision movement (coyote time, jump buffering, variable jump height), game feel polish (squash/stretch, particle trails, camera shake), level design principles (difficulty curves, checkpoint placement), collectible systems (progression rewards), and accessibility options (assist mode, remappable controls). Based on Celeste/Hollow Knight design research. Trigger keywords: platformer, coyote_time, jump_buffer, game_feel, level_design, precision_movement."
---

## Godot 4.7 Baseline

- Expert patterns in this skill target **Godot 4.7+** (stable, 2026-06-18).
- Consult the [Godot 4.7 migration guide](https://docs.godotengine.org/en/4.7/tutorials/migrating/upgrading_to_godot_4.7.html) when upgrading projects from 4.6.
- **NEVER** assume 4.6 defaults (stretch mode, audio area_mask, RichTextLabel percent flags) without checking 4.7 migration notes.

# Genre: Platformer

Expert blueprint for platformers emphasizing movement feel, level design, and player satisfaction.

## NEVER Do (Expert Anti-Patterns)

### Physics & Movement Feel
- NEVER multiply velocity by `delta` before `move_and_slide()`; the method internalizes the timestep.
- NEVER skip **Coyote Time** (approx 0.1s); without this grace period, jumps will feel unresponsive when walking off ledges.
- NEVER ignore **Jump Buffering** (approx 0.15s); players expect to jump the instant they touch the ground if they pressed the button early.
- NEVER use a fixed jump height; strictly implement **Variable Jump Height** (cut velocity on release) for player expression.
- NEVER forget to scale gravity by `delta` before adding to velocity; gravity is an acceleration and must be frame-rate independent.
- NEVER rely on discrete collision for high-speed movement; strictly use `CCD_MODE_CAST_RAY` to prevent tunneling through geometry.
- NEVER use `move_and_collide()` for standard traversal; it lacks the slope/stair handling of `move_and_slide()`.
- NEVER check coyote or buffer timers using exact equality (== 0.0); strictly use `is_equal_approx()` or `>= 0.0`.

### Polish & Level Design
- NEVER use linear camera snapping; strictly use **Camera Smoothing** or `lerp()` to prevent motion sickness.
- NEVER skip **Squash and Stretch** on jump/land; movement feels weightless without these subtle visual "juice" cues.
- NEVER create **Blind Jumps**; strictly use camera look-ahead or zoom triggers to reveal landing zones.
- NEVER use individual `Sprite2D` nodes for level geometry; strictly use **TileMapLayer** for optimized collision and rendering.
- NEVER use complex/concave `CollisionShape2D` for the player; strictly favor primitive shapes (Capsule/Rectangle) for stability.

### Architecture & Performance
- NEVER use `CharacterBody2D` for simple moving platforms; strictly use **AnimatableBody2D** and enable `sync_to_physics`.
- NEVER ignore `platform_on_leave` for descending platforms; use `PLATFORM_ON_LEAVE_ADD_UPWARD_VELOCITY` to preserve jump impulse.
- NEVER disable `recovery_as_collision` on the player character; it is required for correct floor snapping reports.
- NEVER use the `!` (NOT) operator in AnimationTree expressions; strictly use `is_walking == false`.
- NEVER use standard Strings for high-frequency state checks; strictly use `StringName` (e.g., `&"jumping"`).
- NEVER load heavy level chunks synchronously; strictly use `ResourceLoader.load_threaded_request()` to prevent frame stutters.

---

## Godot 4.7: Platformer

- One-way collision **direction** is shape-relative — tune `CollisionShape2D` direction for angled platforms.

## Available Scripts

> **MANDATORY**: For movement feel, read the controller + modules — do not re-implement coyote/buffer/variable-jump inline.

### Controllers (golden path)
- [advanced_platformer_controller.gd](scripts/advanced_platformer_controller.gd) — **MANDATORY** before any precision jump/run controller.
- [platformer_controller_2d.gd](scripts/platformer_controller_2d.gd) — Leaner CharacterBody2D baseline when the advanced stack is overkill.
- [player_ground_controller.gd](scripts/player_ground_controller.gd) — Floor constant speed + slope snap refinements.

### Movement modules
- [coyote_timer.gd](scripts/coyote_timer.gd) — **MANDATORY** with jump feel work (or use the integrated advanced controller).
- [jump_buffer.gd](scripts/jump_buffer.gd) — **MANDATORY** with coyote for landing responsiveness.
- [variable_jump.gd](scripts/variable_jump.gd) — **MANDATORY** for release-cutoff height expression.
- [wall_slide_sensor.gd](scripts/wall_slide_sensor.gd) — Nodeless wall detection.
- [ledge_grab_sensor.gd](scripts/ledge_grab_sensor.gd) — Shape-query ledge grabs.
- [one_way_drop_handler.gd](scripts/one_way_drop_handler.gd) — **MANDATORY** before drop-through / one-way platform input.
- [custom_collision_slider.gd](scripts/custom_collision_slider.gd) — High-speed inter-frame slide response.

### World / camera / polish
- [synchronized_platform.gd](scripts/synchronized_platform.gd) — AnimatableBody2D `sync_to_physics` platforms.
- [fast_projectile_ccd.gd](scripts/fast_projectile_ccd.gd) — CCD to stop tunneling.
- [platformer_animation_sync.gd](scripts/platformer_animation_sync.gd) — Boolean-safe AnimationTree sync.
- [platformer_camera.gd](scripts/platformer_camera.gd) — Look-ahead / smoothing (pair with `godot-camera-systems`).

---

## Core Loop

`Jump → Navigate Obstacles → Reach Goal → Next Level`

## Skill Chain

`godot-project-foundations`, `godot-characterbody-2d`, `godot-input-handling`, `godot-2d-animation`, `godot-audio-systems`, `godot-tilemap-mastery`, `godot-camera-systems`, `godot-monte-carlo-balancer`

---

## Movement Feel — Decision Knobs (not tutorials)

> **MANDATORY read**: [advanced_platformer_controller.gd](scripts/advanced_platformer_controller.gd) plus [coyote_timer.gd](scripts/coyote_timer.gd) / [jump_buffer.gd](scripts/jump_buffer.gd) / [variable_jump.gd](scripts/variable_jump.gd). Copy those modules; do not paste coyote/buffer recipes here.

Tune only these knobs in project code after reading the scripts:

| Knob | Expert default / note |
|------|------------------------|
| Coyote window | ~0.1s — without it, ledge jumps feel broken |
| Jump buffer | ~0.15s — early press must land as jump |
| Variable jump | Cut upward velocity on release |
| Apex / fall gravity | Higher fall multiplier after apex = snappier landings |
| CCD | Enable cast-ray CCD for fast projectiles / dashes |
| Moving platforms | `AnimatableBody2D` + `sync_to_physics`; set `platform_on_leave` |
| One-ways | [one_way_drop_handler.gd](scripts/one_way_drop_handler.gd) — mask/layers, not ad-hoc disable |

Ground: instant direction response. Air: slightly reduced accel. Gravity scaled by `delta`; never `velocity *= delta` before `move_and_slide()`.

---

## Level Design Principles

### The "Teaching Trilogy"
1. **Introduction** — safe learn → 2. **Challenge** — moderate risk → 3. **Twist** — combine / time pressure

### Flow and Pacing
`Easy → Easy → Medium → CHECKPOINT → Medium → Hard → CHECKPOINT → Boss`

### Camera
Use [platformer_camera.gd](scripts/platformer_camera.gd) / peer `godot-camera-systems` for look-ahead — never blind jumps.

---

## Platformer Sub-Genres

- **Precision** (Celeste / Super Meat Boy) — instant respawn, tight controls, frequent checkpoints
- **Collectathon** — hub worlds, ability unlocks, backtracking
- **Puzzle** — slow pacing, environmental physics
- **Metroidvania** — route to `godot-genre-metroidvania`

---

## Common Pitfalls

| Pitfall | Solution |
|---------|----------|
| Floaty jumps | Increase fall gravity after apex |
| Imprecise landings | Coyote + buffer modules + land juice |
| Unfair deaths | Hazards telegraphed before contact |
| Blind jumps | Look-ahead camera / zoom triggers |
| Boring mid-game | New mechanic every 2–3 levels |

---

## Polish Checklist

- [ ] Dust particles on land/run
- [ ] Screen shake on heavy landings (`godot-camera-systems` trauma)
- [ ] Squash/stretch on jump/land (visual pivot at feet)
- [ ] SFX for jump/land/wall-slide
- [ ] Checkpoint visual/audio feedback
- [ ] Assist mode / remappable controls

## Reference

> Progressive disclosure: open Official Documentation links only when researching a specific API; load Related Skills when routing to a peer domain — do not preload the whole lattice.

### Official Documentation
- [Using CharacterBody2D](https://docs.godotengine.org/en/stable/tutorials/physics/using_character_body_2d.html) — move_and_slide floor/wall/ceiling reports, slope snap, and platform_on_leave behavior that platformer feel depends on.
- [CharacterBody2D](https://docs.godotengine.org/en/stable/classes/class_characterbody2d.html) — floor_constant_speed, floor_snap_length, recovery_as_collision, and motion-mode knobs for precision controllers.
- [Physics introduction](https://docs.godotengine.org/en/stable/tutorials/physics/physics_introduction.html) — collision layers/masks for player, one-ways, hazards, and projectiles without accidental overlaps.
- [Collision shapes (2D)](https://docs.godotengine.org/en/stable/tutorials/physics/collision_shapes_2d.html) — why capsule/rectangle player shapes stay stable vs concave geometry.
- [2D movement overview](https://docs.godotengine.org/en/stable/tutorials/2d/2d_movement.html) — CharacterBody vs RigidBody tradeoffs and common input→velocity patterns.
- [Using TileMaps](https://docs.godotengine.org/en/stable/tutorials/2d/using_tilemaps.html) — TileMapLayer collision for level geometry instead of per-sprite StaticBodies.
- [Using TileSets](https://docs.godotengine.org/en/stable/tutorials/2d/using_tilesets.html) — one-way collision and physics layers authored in the tileset for drop-through platforms.
- [AnimatableBody2D](https://docs.godotengine.org/en/stable/classes/class_animatablebody2d.html) — sync_to_physics moving platforms that riders must stick to without jitter.
- [Camera2D](https://docs.godotengine.org/en/stable/classes/class_camera2d.html) — position smoothing, drag margins, and look-ahead offsets that prevent blind jumps and motion sickness.
- [Using AnimationTree](https://docs.godotengine.org/en/stable/tutorials/animation/animation_tree.html) — boolean advance conditions for idle/run/air states without unsafe expression negation.
- [Ray-casting](https://docs.godotengine.org/en/stable/tutorials/physics/ray-casting.html) — nodeless wall-slide and ledge queries via PhysicsDirectSpaceState2D.
- [Input examples](https://docs.godotengine.org/en/stable/tutorials/inputs/input_examples.html) — action just-pressed/released patterns behind jump buffer and variable jump cutoff.

### Related Skills

#### Prerequisites
- [godot-project-foundations](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md) — project settings, input map actions, and scene structure before wiring coyote/buffer timers.
- [godot-characterbody-2d](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-characterbody-2d/SKILL.md) — move_and_slide grounding, slopes, and wall normals that every precision jump builds on.
- [godot-input-handling](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-input-handling/SKILL.md) — remappable jump/move actions and unhandled-input buffering for assist-mode accessibility.

#### Complements
- [godot-2d-physics](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-2d-physics/SKILL.md) — layers, CCD, Area2D hazards, and AnimatableBody platforms beyond the controller core.
- [godot-tilemap-mastery](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-tilemap-mastery/SKILL.md) — TileMapLayer/TileSet one-ways and collision painting for teachable level geometry.
- [godot-camera-systems](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-camera-systems/SKILL.md) — look-ahead, room cameras, and smoothing that reveal landings without blind jumps.
- [godot-animation-tree-mastery](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-animation-tree-mastery/SKILL.md) — AnimationTree conditions synced from is_on_floor / velocity for juice-safe state graphs.
- [godot-2d-animation](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-2d-animation/SKILL.md) — squash/stretch and land/run cycles that sell weight after physics resolves.
- [godot-particles](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-particles/SKILL.md) — dust trails and land puffs called from jump/land events.
- [godot-audio-systems](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-audio-systems/SKILL.md) — jump/land/wall-slide SFX timing that reinforces responsive feel.
- [godot-monte-carlo-balancer](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md) — sample coyote/buffer/gravity/jump knobs and level difficulty curves before shipping assist defaults.

#### Downstream / consumers
- [godot-genre-metroidvania](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-metroidvania/SKILL.md) — ability-gated exploration that reuses precision movement and TileMap rooms.
- [godot-save-load-systems](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-save-load-systems/SKILL.md) — checkpoint position persistence across deaths and scene reloads.

#### Master
- [godot-master](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-master/SKILL.md) — library router and mirrored module entry for cross-skill discovery.
