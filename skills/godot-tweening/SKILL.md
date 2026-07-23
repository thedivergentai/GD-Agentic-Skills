---
name: godot-tweening
description: "Expert blueprint for programmatic animation using Tween for smooth property transitions, UI effects, camera movements, and juice. Covers easing functions, parallel tweens, chaining, and lifecycle management. Use when implementing UI animations OR procedural movement. Keywords Tween, easing, interpolation, EASE_IN_OUT, TRANS_CUBIC, tween_property, tween_callback."
---

## Godot 4.7 Baseline

- Expert patterns in this skill target **Godot 4.7+** (stable, 2026-06-18).
- Consult the [Godot 4.7 migration guide](https://docs.godotengine.org/en/4.7/tutorials/migrating/upgrading_to_godot_4.7.html) when upgrading projects from 4.6.
- **NEVER** assume 4.6 defaults (stretch mode, audio area_mask, RichTextLabel percent flags) without checking 4.7 migration notes.

# Tweening

Tween property animation, easing curves, chaining, and lifecycle management define smooth programmatic motion.

## Decision Tree — Tween vs AnimationPlayer

| Situation | Choose |
|-----------|--------|
| One-off UI juice, hover, popup, score count, recoil | **Tween** (`create_tween`) |
| Authored multi-track clips, scrubbable timelines, blend trees | **AnimationPlayer** / AnimationTree |
| Camera continuous follow behind a moving target | **Camera2D.position_smoothing** / spring follow — **not** a new Tween every `_process` |
| Menu motion while `Engine.time_scale == 0` | Tween with `set_ignore_time_scale(true)` — **MANDATORY** [time_scale_ignored_ui.gd](scripts/time_scale_ignored_ui.gd) |
| Retriggerable property (button spam, dodge cancel) | Kill-before-recreate — **MANDATORY** [safe_tween_interruption.gd](scripts/safe_tween_interruption.gd) |
| Physics body / net correction motion | `TWEEN_PROCESS_PHYSICS` + `reset_physics_interpolation` |

## Available Scripts

> **MANDATORY**: Read the script for the case above before writing tween glue.

### [safe_tween_interruption.gd](scripts/safe_tween_interruption.gd)
**MANDATORY** for any retriggerable tween — kill active tweens before starting new ones.

### [time_scale_ignored_ui.gd](scripts/time_scale_ignored_ui.gd)
**MANDATORY** for pause-menu / `time_scale == 0` UI motion.

### [nested_subtween_cutscene.gd](scripts/nested_subtween_cutscene.gd)
**MANDATORY** for composable cutscene timelines via `tween_subtween`.

### [parallel_popup_animation.gd](scripts/parallel_popup_animation.gd)
`set_parallel(true)` + `chain()` for multi-property UI transitions.

### [text_counter_method_tween.gd](scripts/text_counter_method_tween.gd)
`tween_method` for non-property values (score strings).

### [custom_curve_tween.gd](scripts/custom_curve_tween.gd)
`Curve` resources for bespoke easing.

### [camera_shake_tween_logic.gd](scripts/camera_shake_tween_logic.gd)
Procedural screen shake with looping tweens (offset, not follow).

### [relative_recoil_tween.gd](scripts/relative_recoil_tween.gd)
`as_relative()` / `from_current()` for recoil nudges.

### [staggered_inventory_entry.gd](scripts/staggered_inventory_entry.gd)
Sequential collection entry on one Tween.

### [looped_hover_vfx.gd](scripts/looped_hover_vfx.gd)
Infinite ping-pong ambient juice.

### [juice_manager.gd](scripts/juice_manager.gd) / [tween_builder.gd](scripts/tween_builder.gd)
Central juice dispatch / builder helpers when many systems share feel presets.

## NEVER Do in Tweening

- **NEVER instantiate a Tween using `Tween.new()`** — Always use `create_tween()` or `get_tree().create_tween()` [3, 4].
- **NEVER attempt to reuse a finished Tween** — Single-use; recreate to replay [4].
- **NEVER manually instantiate `PropertyTweener` or `CallbackTweener`** — Only via parent Tween methods [5].
- **NEVER create an infinite loop containing only 0-duration animations** — Freezes the engine [10].
- **NEVER use multiple Tweens to animate the same property simultaneously** — `kill()` the old reference first [11, 12].
- **NEVER use linear interpolation for UI/Juice** — Prefer `EASE_OUT + TRANS_QUAD` or `EASE_IN_OUT + TRANS_CUBIC` [22].
- **NEVER create tweens in `_process` without guards** — Creating 60 tweens per second will crash the app.
- **NEVER skip `bind_node(self)` for non-global tweens** — Binding ensures death with the node [13].
- **NEVER use 0-duration tweens for state changes** — Set the property directly [20].
- **NEVER forget to call `chain()` when returning from `set_parallel(true)`** [15].

---

## Lifecycle Golden Path

```gdscript
var _tween: Tween

func animate_to(pos: Vector2) -> void:
    if _tween and _tween.is_valid():
        _tween.kill()
    _tween = create_tween().bind_node(self)
    _tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
    _tween.tween_property(self, "position", pos, 0.35)
```

**MANDATORY pattern source:** [safe_tween_interruption.gd](scripts/safe_tween_interruption.gd).

## Camera Follow (Correct)

Continuous follow is **not** a Tween job:

```gdscript
extends Camera2D
@export var target: Node2D

func _ready() -> void:
    position_smoothing_enabled = true
    position_smoothing_speed = 5.0

func _physics_process(_delta: float) -> void:
    if target:
        global_position = target.global_position
```

If you must tween a one-shot camera punch/return, keep **one** Tween reference and kill before recreate — never `create_tween()` inside unguarded `_process`.

## Expert Patterns (keep)

### Physics-Sync-Tweening
```gdscript
func apply_physics_tween(target: Node3D, start_pos: Vector3, goal: Vector3) -> void:
    target.global_position = start_pos
    target.reset_physics_interpolation()
    var tween := create_tween().bind_node(target)
    tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
    tween.tween_property(target, "global_position", goal, 0.5)
```

### Juice-Config-Resource
Store duration/trans/ease in a `Resource` (see juice scripts) so feel is data-driven.

### Tween-Event-Sequencing
Parallel block → `chain()` → interval/callback → exit. Prefer [nested_subtween_cutscene.gd](scripts/nested_subtween_cutscene.gd) for nested modules.

### Bezier-Path-Tween
Tween `PathFollow2D.progress_ratio` instead of hand-rolled Bezier math.

## Reference

> Progressive disclosure: open Official Documentation links only when researching a specific API; load Related Skills when routing to a peer domain — do not preload the whole lattice.

### Official Documentation
- [Tween](https://docs.godotengine.org/en/stable/classes/class_tween.html) — create_tween, parallel/chain, loops, process mode, ignore_time_scale, and kill/lifecycle rules.
- [PropertyTweener](https://docs.godotengine.org/en/stable/classes/class_propertytweener.html) — tween_property details: as_relative, from_current, custom interpolators, and per-step ease/trans.
- [MethodTweener](https://docs.godotengine.org/en/stable/classes/class_methodtweener.html) — tween_method for non-property values (score counters, shader params, Curve-sampled motion).
- [CallbackTweener](https://docs.godotengine.org/en/stable/classes/class_callbacktweener.html) — tween_callback for sequenced side effects without inventing fake 0-duration property steps.
- [IntervalTweener](https://docs.godotengine.org/en/stable/classes/class_intervaltweener.html) — tween_interval delays inside a single Tween timeline.
- [SubtweenTweener](https://docs.godotengine.org/en/stable/classes/class_subtweentweener.html) — tween_subtween for nested cutscene modules under one parent timeline.
- [Interpolation](https://docs.godotengine.org/en/stable/tutorials/math/interpolation.html) — lerp/smoothstep foundations behind easing choices and custom interpolators.
- [Beziers, curves and paths](https://docs.godotengine.org/en/stable/tutorials/math/beziers_and_curves.html) — Curve/PathFollow patterns used when property tweens alone cannot describe the path.
- [Introduction to the animation features](https://docs.godotengine.org/en/stable/tutorials/animation/introduction.html) — when Tween juice is enough versus AnimationPlayer/AnimationTree authored tracks.
- [Using SceneTree](https://docs.godotengine.org/en/stable/tutorials/scripting/scene_tree.html) — SceneTree.create_tween and node lifetime when bind_node is not enough.
- [Idle and Physics Processing](https://docs.godotengine.org/en/stable/tutorials/scripting/idle_and_physics_processing.html) — idle vs physics process modes for TWEEN_PROCESS_PHYSICS sync.
- [Physics interpolation quick start guide](https://docs.godotengine.org/en/stable/tutorials/physics/interpolation/physics_interpolation_quick_start_guide.html) — reset_physics_interpolation when tweening transforms on interpolated bodies.

### Related Skills

#### Prerequisites
- [godot-project-foundations](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md) — scene tree, Node ownership, and resource basics before create_tween/bind_node lifecycle patterns.
- [godot-gdscript-mastery](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md) — typed callables, lambdas, and await/signal idioms used in tween_method and finished handlers.

#### Complements
- [godot-2d-animation](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-2d-animation/SKILL.md) — sprite/skeleton motion that often coexists with Tween juice and needs shared kill/lifecycle discipline.
- [godot-animation-player](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-animation-player/SKILL.md) — authored clips for complex timelines; Tweens stay for runtime/procedural UI and one-off juice.
- [godot-ui-containers](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md) — Control size/pivot/layout context for popup scale-fade and staggered inventory entry tweens.
- [godot-signal-architecture](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md) — finished/callback wiring without dangling connections when Tweens are killed and recreated.
- [godot-camera-systems](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-camera-systems/SKILL.md) — camera follow, shake offsets, and look targets driven by procedural Tweens.
- [godot-resource-data-patterns](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md) — JuiceConfig-style Resources that store duration/trans/ease outside gameplay scripts.
- [godot-particles](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-particles/SKILL.md) — burst timing and one-shot VFX that should start from tween_callback steps, not parallel ad-hoc timers.
- [godot-shaders-basics](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-shaders-basics/SKILL.md) — shader params animated via tween_method / set when property paths are not enough.

#### Downstream / consumers
- [godot-inventory-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-inventory-system/SKILL.md) — slot/item entry, drag feedback, and equip juice built on staggered and interruptible Tweens.
- [godot-genre-card-game](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-card-game/SKILL.md) — hand arcs, draw/discard flights, and resolve polish that depend on Tween chaining.
- [godot-ui-theming](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-theming/SKILL.md) — theme-driven hover/focus motion that still needs safe Tween interruption under the same Control.

#### Master
- [godot-master](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-master/SKILL.md) — library router and mirrored module entry for cross-skill discovery.
