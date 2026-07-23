---
name: godot-2d-animation
description: "Expert patterns for 2D animation in Godot using AnimatedSprite2D and skeletal cutout rigs. Use when implementing sprite frame animations, procedural animation (squash/stretch), cutout bone hierarchies, or frame-perfect timing systems. Trigger keywords: AnimatedSprite2D, SpriteFrames, animation_finished, animation_looped, frame_changed, frame_progress, set_frame_and_progress, cutout animation, skeletal 2D, Bone2D, procedural animation, animation state machine, advance(0)."
---

## Godot 4.7 Baseline

- Expert patterns in this skill target **Godot 4.7+** (stable, 2026-06-18).
- Consult the [Godot 4.7 migration guide](https://docs.godotengine.org/en/4.7/tutorials/migrating/upgrading_to_godot_4.7.html) when upgrading projects from 4.6.
- **NEVER** assume 4.6 defaults (stretch mode, audio area_mask, RichTextLabel percent flags) without checking 4.7 migration notes.

# 2D Animation

Expert-level guidance for frame-based and skeletal 2D animation in Godot.

## NEVER Do

- **NEVER use AnimatedTexture** — This class is deprecated, highly inefficient in modern renderers, and may be removed in future Godot versions. Use AnimatedSprite2D or AnimationPlayer instead.
- **NEVER allow Tweens to fight over the same property** — If multiple Tweens animate the same property, the last one created forcibly takes priority. Always assign your Tween to a variable and call `kill()` on the previous instance before creating a new one.
- **NEVER process kinematic movement outside the physics tick** — If your AnimationPlayer moves a CharacterBody2D, ensure the AnimationPlayer's callback mode is set to Physics. Animating physics bodies during the Idle (render) frame breaks fixed timestep physics interpolation and causes stutter.
- **NEVER use `animation_finished` for looping animations** — The signal only fires on non-looping animations. Use `animation_looped` instead for loop detection.
- **NEVER call `play()` and expect instant state changes** — AnimatedSprite2D applies `play()` on the next process frame. Call `advance(0)` immediately after `play()` if you need synchronous property updates (e.g., when changing animation + flip_h simultaneously).
- **NEVER set `frame` directly when preserving animation progress** — Setting `frame` resets `frame_progress` to 0.0. Use `set_frame_and_progress(frame, progress)` to maintain smooth transitions when swapping animations mid-frame.
- **NEVER forget to cache `@onready var anim_sprite`** — The node lookup getter is surprisingly slow in hot paths like `_physics_process()`. Always use `@onready`.
- **NEVER mix AnimationPlayer tracks with code-driven AnimatedSprite2D** — Choose one animation authority per sprite. Mixing causes flickering and state conflicts.
- **NEVER use paper-thin skeletons for deformation** — 2D meshes require balanced vertex density. If your mesh deforms poorly, increase the vertex count near joints in the Mesh2D editor.

---

## Available Scripts

> **MANDATORY**: Read the script for the pattern you are implementing. Inline recipes that duplicated these scripts were removed — the script is the source of truth.

### Do NOT Load (by scenario)
| Scenario | Load | Do NOT Load |
|----------|------|-------------|
| Single character / player | `one_frame_sync_fix.gd`, `animation_state_sync.gd`, optional `animation_tree_step.gd` / `tween_lifecycle_manager.gd` | `multimesh_swarm_anim.gd`, `gpu_mesh_optimizer.gd` (unless fill-rate profiling demands it) |
| Frame events / hitboxes / SFX sync | `animation_sync.gd` (+ AnimationPlayer method tracks) | Swarm/MultiMesh scripts |
| Squash/stretch game-feel | **MANDATORY** `procedural_squash_stretch.gd` | Inline landing-condition snippets in this skill |
| Cutout / IK limbs | `skeleton_2d_rig_helper.gd` | MultiMesh swarm scripts |
| Shader flash / dissolve on anim | `shader_hook.gd` | — |
| Thousands of bats/fish/props | `multimesh_swarm_anim.gd` (+ docs fish tutorial) | Per-entity AnimatedSprite2D / Tween managers |

### Script index
- [one_frame_sync_fix.gd](scripts/one_frame_sync_fix.gd) — **Golden sync path**: `play()` + `advance(0)` with `flip_h` / property changes.
- [animation_state_sync.gd](scripts/animation_state_sync.gd) — State-driven animation + transition queue.
- [animation_sync.gd](scripts/animation_sync.gd) — Method tracks, signal orchestration, blend-space hooks.
- [animation_tree_step.gd](scripts/animation_tree_step.gd) — `AnimationNodeStateMachinePlayback.travel()`.
- [procedural_squash_stretch.gd](scripts/procedural_squash_stretch.gd) — **Sole source** for physics-driven squash/stretch (do not re-implement landing checks here).
- [tween_lifecycle_manager.gd](scripts/tween_lifecycle_manager.gd) — Kill/reuse Tweens; property-fight prevention.
- [skeleton_2d_rig_helper.gd](scripts/skeleton_2d_rig_helper.gd) — FABRIK/CCDIK stacks, rest poses.
- [shader_hook.gd](scripts/shader_hook.gd) — AnimationPlayer → ShaderMaterial uniforms.
- [gpu_mesh_optimizer.gd](scripts/gpu_mesh_optimizer.gd) — Sprite → tight 2D mesh for fill-rate.
- [multimesh_swarm_anim.gd](scripts/multimesh_swarm_anim.gd) — GPU swarm motion only.

---

## Expert Decision Tree: Choosing the Right Animation Tool

| Scenario | Recommended Node | Expert Insight |
|----------|------------------|----------------|
| Isolated, pure frame-by-frame spritesheets | **AnimatedSprite2D** | Cannot animate non-visual properties or method tracks — escalate to AnimationPlayer when you need those. |
| Cutout animations, non-visual sync, audio/particles | **AnimationPlayer** | Owns transforms, mesh deformation, method/value tracks. |
| Complex state machines, blending, locomotion | **AnimationTree** | Logic graph over an AnimationPlayer; use `travel()` via `animation_tree_step.gd`. |
| Procedural, dynamic, fire-and-forget UI/fx | **Tween** | Runtime targets; always go through `tween_lifecycle_manager.gd`. |
| Swarms of thousands of entities | **MultiMeshInstance2D + Shader** | Load `multimesh_swarm_anim.gd` only; skip character sync scripts. |

---

## Golden Path: One-Frame Sync (`play` + `advance(0)`)

When changing animation **and** sprite properties in the same frame, `play()` alone applies next process tick — one-frame glitch.

**MANDATORY**: Read [one_frame_sync_fix.gd](scripts/one_frame_sync_fix.gd). Minimal contract:

```gdscript
# After any play() that must match flip/modulate/etc. this frame:
anim.flip_h = dir < 0
anim.play(&"run")
anim.advance(0)  # force pose now
```

Related: `animation_looped` (loops) vs `animation_finished` (one-shots); use `set_frame_and_progress` when swapping skins mid-clip (see AnimatedSprite2D class docs).

---

## Procedural Squash & Stretch

**Do NOT** paste landing snippets into agents. A prior body used an impossible condition (`not is_on_floor() and is_on_floor()`).

**MANDATORY sole source**: [procedural_squash_stretch.gd](scripts/procedural_squash_stretch.gd) — impact squash, velocity stretch, lerp recovery. Pair with `godot-characterbody-2d` / `godot-2d-physics` for floor/velocity authority.

---

## Quick routing (scripts own the recipes)

- **Tween interrupt / flash loops** → `tween_lifecycle_manager.gd` (never race two Tweens on one property).
- **AnimationTree travel** → `animation_tree_step.gd` (`start` then `travel`).
- **IK foot plant** → `skeleton_2d_rig_helper.gd` + SkeletonModification2DTwoBoneIK docs.
- **Fill-rate / swarms** → `gpu_mesh_optimizer.gd` / `multimesh_swarm_anim.gd` per Do-NOT-Load table.
- **Pixel filter / shared SpriteFrames** → Official Documentation (2D sprite animation, SpriteFrames); keep resources shared via preload.

## Reference

> Progressive disclosure: open Official Documentation links only when researching a specific API;
> load Related Skills when routing work to a peer domain — do not preload the whole lattice.

### Official Documentation
- [2D sprite animation](https://docs.godotengine.org/en/stable/tutorials/2d/2d_sprite_animation.html) — Canonical AnimatedSprite2D + SpriteFrames workflow for frame-based sheets and signal timing.
- [Introduction to the animation features](https://docs.godotengine.org/en/stable/tutorials/animation/introduction.html) — When to graduate from spritesheets to AnimationPlayer for tracks, methods, and non-visual properties.
- [Cutout animation](https://docs.godotengine.org/en/stable/tutorials/animation/cutout_animation.html) — Paper-doll hierarchies and hybrid cutout/cel setups before full skeletal IK.
- [2D skeletons](https://docs.godotengine.org/en/stable/tutorials/animation/2d_skeletons.html) — Skeleton2D / Bone2D rigging, rest poses, and deformation expectations for cutout meshes.
- [Using AnimationTree](https://docs.godotengine.org/en/stable/tutorials/animation/animation_tree.html) — Blend spaces and state-machine graphs that drive an underlying AnimationPlayer.
- [Animation track types](https://docs.godotengine.org/en/stable/tutorials/animation/animation_track_types.html) — Method/value/property tracks for frame-perfect SFX, hitboxes, and shader uniform hooks.
- [AnimatedSprite2D](https://docs.godotengine.org/en/stable/classes/class_animatedsprite2d.html) — `play()`, `advance()`, `set_frame_and_progress()`, and `animation_looped` vs `animation_finished` contracts.
- [SpriteFrames](https://docs.godotengine.org/en/stable/classes/class_spriteframes.html) — Shared frame resources, loop flags, and per-animation timing used by AnimatedSprite2D.
- [Tween](https://docs.godotengine.org/en/stable/classes/class_tween.html) — Runtime squash/stretch and interruptible one-shot motion without baking AnimationPlayer clips.
- [Animating thousands of fish](https://docs.godotengine.org/en/stable/tutorials/performance/vertex_animation/animating_thousands_of_fish.html) — GPU vertex / MultiMesh patterns for swarm motion that must leave the node tree.
- [SkeletonModification2DTwoBoneIK](https://docs.godotengine.org/en/stable/classes/class_skeletonmodification2dtwoboneik.html) — Lightweight two-bone IK for procedural foot/hand planting on Skeleton2D stacks.

### Related Skills

#### Prerequisites
- [godot-animation-player](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-animation-player/SKILL.md) — AnimationPlayer ownership, callback modes, and track authoring that this skill’s hybrid/cutout patterns assume.
- [godot-characterbody-2d](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-characterbody-2d/SKILL.md) — Physics-tick movement so animated CharacterBody2D motion stays on the fixed timestep.
- [godot-signal-architecture](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md) — Safe wiring for `animation_finished` / `animation_looped` / `frame_changed` without lifecycle leaks.

#### Complements
- [godot-animation-tree-mastery](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-animation-tree-mastery/SKILL.md) — Deepen blend trees, OneShot layers, and `travel()` pathfinding beyond the 2D locomotion basics here.
- [godot-tweening](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-tweening/SKILL.md) — Broader Tween composition when squash/stretch or UI pops outgrow inline `create_tween()` snippets.
- [godot-shaders-basics](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-shaders-basics/SKILL.md) — CanvasItem shader uniforms driven by AnimationPlayer tracks or MultiMesh swarm materials.
- [godot-2d-physics](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-2d-physics/SKILL.md) — Impact velocity, raycasts for IK targets, and interpolation rules that feed procedural deformation.
- [godot-state-machine-advanced](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-state-machine-advanced/SKILL.md) — Gameplay FSMs that should own intent while AnimationTree/AnimatedSprite2D own presentation.
- [godot-particles](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-particles/SKILL.md) — Dust, hit sparks, and trails spawned from method tracks or frame events.
- [godot-adapt-3d-to-2d](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-adapt-3d-to-2d/SKILL.md) — Directional sheets, billboards, and fake-depth sorting that still use 2D animation nodes.

#### Downstream / consumers
- [godot-genre-platformer](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-platformer/SKILL.md) — Jump/land/run presentation stacks consume sync, squash/stretch, and state-machine travel patterns.
- [godot-genre-fighting](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-fighting/SKILL.md) — Frame-perfect hitboxes and method tracks depend on AnimationPlayer + AnimatedSprite2D discipline here.
- [godot-resource-data-patterns](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md) — Shared `.tres` SpriteFrames and skin packs for memory-safe multi-instance characters.

#### Master
- [godot-master](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-master/SKILL.md) — Library router and mirrored module entry for cross-skill discovery.
