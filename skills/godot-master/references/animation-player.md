---
name: godot-animation-player
description: "Expert patterns for AnimationPlayer including track types (Value, Method, Audio, Bezier), root motion extraction, animation callbacks, procedural animation generation, call mode optimization, and RESET tracks. Use for timeline-based animations, cutscenes, or UI transitions. Trigger keywords: AnimationPlayer, Animation, track_insert_key, root_motion, animation_finished, RESET_track, call_mode, animation_set_next, queue, blend_times."
---

# AnimationPlayer

Timeline-based keyframe animation: track choice, RESET, root motion, libraries — scripts own recipes.

## NEVER Do

- **NEVER forget RESET tracks** — Animated properties otherwise stick across scene changes.
- **NEVER use `Animation.CALL_MODE_CONTINUOUS` for one-shot logic** — Use `CALL_MODE_DISCRETE`.
- **NEVER animate embedded resource properties directly** — Prefer instance uniforms / owned materials.
- **NEVER use `animation_finished` for looping clips** — Use `animation_looped` or poll `current_animation`.
- **NEVER hardcode animation name strings at scale** — Constants / `StringName`.
- **NEVER `seek()` without `update=true` when same-frame reads matter**.
- **NEVER leave off-screen visual-only players `active`** — Cull with notifiers.
- **NEVER mutate a playing `AnimationLibrary`** — Stop / wait for finished first.
- **NEVER rely on `speed_scale` for long sync** — Prefer `seek()` against a shared clock.

---

## Godot 4.7: Animation

- Animation editor tracks can be **collapsed** for dense timelines.
- `Animation.length` metadata is **double** precision (was float).

## Available Scripts (MANDATORY triggers)

> Open the matching script **before** implementing that pattern. Edge-case recipes live in [references/edge-cases.md](animation-player-edge-cases.md) — keep this body lean.

| Need | Script |
|---|---|
| Method-track hit/state keys | [method_track_logic.gd](../scripts/animation_player_method_track_logic.gd) |
| Stance/weapon library swap | [runtime_anim_lib_swapper.gd](../scripts/animation_player_runtime_anim_lib_swapper.gd) |
| Shader uniform timelines | [dynamic_shader_animation.gd](../scripts/animation_player_dynamic_shader_animation.gd) |
| Runtime track tweak | [procedural_track_modifier.gd](../scripts/animation_player_procedural_track_modifier.gd) |
| Forced RESET orchestration | [reset_track_orchestrator.gd](../scripts/animation_player_reset_track_orchestrator.gd) |
| Bezier → procedural drive | [bezier_curve_extraction.gd](../scripts/animation_player_bezier_curve_extraction.gd) |
| Off-screen `active` cull | [active_animation_culler.gd](../scripts/animation_player_active_animation_culler.gd) |
| Root motion ↔ physics | [root_motion_physics_sync.gd](../scripts/animation_player_root_motion_physics_sync.gd) |
| Part/equipment tracks | [character_part_swapper_tracks.gd](../scripts/animation_player_character_part_swapper_tracks.gd) |
| TYPE_AUDIO footstep sync | [precise_audio_sync.gd](../scripts/animation_player_precise_audio_sync.gd) |
| Queue/branch sequences | [animation_sequencer.gd](../scripts/animation_player_animation_sequencer.gd) |
| Code-built Animation resources | [programmatic_anim.gd](../scripts/animation_player_programmatic_anim.gd) |
| Alt audio-track setup notes | [audio_sync_tracks.gd](../scripts/animation_player_audio_sync_tracks.gd) |

## Track decision matrix

| Track | Use when | Avoid when |
|---|---|---|
| **Value** | Animate properties (pos, modulate, uniforms) | One-off runtime juice → Tween |
| **Method** | Hitboxes, SFX hooks, state flips at timestamps | CONTINUOUS call mode / missing method on path |
| **Audio** | Footsteps / VO locked to frames | Loose `AudioStreamPlayer.play()` drift |
| **Bezier** | Custom easing curves sampled at runtime | Simple linear fades |

## Root motion (physics)

`CharacterBody3D` + `Skeleton3D` + `AnimationPlayer`: extract with `get_root_motion_position()` / rotation on the physics tick — see [root_motion_physics_sync.gd](../scripts/animation_player_root_motion_physics_sync.gd). Do not leave walk displacement only on bones.

## Sequences, blends, RESET

- Chain: `animation_set_next` / `queue` / [animation_sequencer.gd](../scripts/animation_player_animation_sequencer.gd).
- Blend times for walk↔run polish; default blend on the player when shared.
- Always author a **RESET** clip with defaults; enable Reset on Save when editing.

## AnimationPlayer vs Tween

| Need | Prefer |
|---|---|
| Timeline / many properties / reusable | **AnimationPlayer** |
| One-shot runtime / interruptible | **Tween** ([godot-tweening](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-tweening/SKILL.md)) |

## Expert pointers (scripts, not dumps)

- Shared libraries: [runtime_anim_lib_swapper.gd](../scripts/animation_player_runtime_anim_lib_swapper.gd) — `add_animation_library` + `library/anim` play paths.
- Decoupled timeline events: method track → small signaler node → gameplay listeners ([method_track_logic.gd](../scripts/animation_player_method_track_logic.gd)).
- Budget: [active_animation_culler.gd](../scripts/animation_player_active_animation_culler.gd) or manual `advance()` when off-screen.

## Reference

> Progressive disclosure: open Official Documentation links only when researching a specific API;
> load Related Skills when routing work to a peer domain — do not preload the whole lattice.

### Official Documentation
- [Introduction to the animation features](https://docs.godotengine.org/en/stable/tutorials/animation/introduction.html) — When AnimationPlayer owns timelines vs Tweens/sprites, and how libraries, RESET, and the editor fit together.
- [Animation track types](https://docs.godotengine.org/en/stable/tutorials/animation/animation_track_types.html) — Value, Method, Bezier, and Audio tracks plus call-mode and keying rules this skill’s patterns depend on.
- [AnimationPlayer](https://docs.godotengine.org/en/stable/classes/class_animationplayer.html) — `play`/`queue`/`seek`, blend times, `animation_finished` vs `animation_looped`, and `active` culling.
- [Animation](https://docs.godotengine.org/en/stable/classes/class_animation.html) — Track APIs (`track_insert_key`, call modes, audio/bezier helpers) and length/loop metadata.
- [AnimationLibrary](https://docs.godotengine.org/en/stable/classes/class_animationlibrary.html) — Shared stance/weapon clip packs added via `add_animation_library` without duplicating tracks per model.
- [AnimationMixer](https://docs.godotengine.org/en/stable/classes/class_animationmixer.html) — Root-motion getters, callback process modes, and `advance()` used by physics sync and budget managers.
- [Using AnimationTree](https://docs.godotengine.org/en/stable/tutorials/animation/animation_tree.html) — When blends/state machines should drive an underlying AnimationPlayer instead of manual `queue`.
- [Tween](https://docs.godotengine.org/en/stable/classes/class_tween.html) — Runtime one-shot motion counterpart for the AnimationPlayer-vs-Tween decision matrix.
- [Adding animations (Your first 3D game)](https://docs.godotengine.org/en/stable/getting_started/first_3d_game/09.adding_animations.html) — Practical import → AnimationPlayer play loop before advanced track authoring.
- [VisibleOnScreenNotifier3D](https://docs.godotengine.org/en/stable/classes/class_visibleonscreennotifier3d.html) — Screen enter/exit signals used to toggle `AnimationPlayer.active` for off-screen CPU savings.

### Related Skills

#### Prerequisites
- [godot-signal-architecture](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md) — Safe `animation_finished` / `animation_looped` / custom method-track signaling without lifecycle leaks.
- [godot-resource-data-patterns](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md) — Shared `.tres` AnimationLibrary ownership so runtime swaps do not duplicate or mutate playing resources unsafely.
- [godot-gdscript-mastery](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md) — Typed programmatic track generation, path strings, and Dictionary method-track payloads.

#### Complements
- [godot-animation-tree-mastery](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-animation-tree-mastery/SKILL.md) — Blend trees, OneShot layers, and `travel()` when locomotion outgrows AnimationPlayer `queue`/`set_next`.
- [godot-2d-animation](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-2d-animation/SKILL.md) — AnimatedSprite2D / Skeleton2D presentation that still relies on AnimationPlayer method and property tracks.
- [godot-tweening](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-tweening/SKILL.md) — Interruptible runtime tweens when baking a full Animation resource would be overkill.
- [godot-shaders-basics](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-shaders-basics/SKILL.md) — ShaderMaterial uniforms driven by value tracks (`shader_parameter/*`) without embedding materials.
- [godot-audio-systems](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-audio-systems/SKILL.md) — Bus/voice pooling around TYPE_AUDIO tracks and footstep/SFX timing on the timeline.
- [godot-physics-3d](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-physics-3d/SKILL.md) — CharacterBody3D integration for root-motion position/rotation extraction on the physics tick.

#### Downstream / consumers
- [godot-genre-fighting](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-fighting/SKILL.md) — Frame-perfect hitbox windows and discrete method tracks for cancel windows.
- [godot-genre-platformer](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-platformer/SKILL.md) — Jump/land/run clips, RESET hygiene, and blend times on 2D/3D movers.
- [godot-combat-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-combat-system/SKILL.md) — Attack timelines that emit damage/VFX events from AnimationPlayer method tracks.

#### Master
- [godot-master](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-master/SKILL.md) — Library router and mirrored module entry for cross-skill discovery.
