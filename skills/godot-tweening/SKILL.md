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

## Available Scripts

### [safe_tween_interruption.gd](scripts/safe_tween_interruption.gd)
Expert logic for killing active tweens before starting new ones to prevent property conflicts.

### [parallel_popup_animation.gd](scripts/parallel_popup_animation.gd)
Using `set_parallel(true)` and `chain()` for complex multi-property UI transitions.

### [text_counter_method_tween.gd](scripts/text_counter_method_tween.gd)
Animating non-property values (like score strings) using `tween_method`.

### [custom_curve_tween.gd](scripts/custom_curve_tween.gd)
Driving property interpolation using visual `Curve` resources for bespoke easing.

### [camera_shake_tween_logic.gd](scripts/camera_shake_tween_logic.gd)
Implementing procedural screen shake using randomized looping tweens.

### [time_scale_ignored_ui.gd](scripts/time_scale_ignored_ui.gd)
Ensuring menu animations continue playing when `Engine.time_scale` is set to 0.

### [nested_subtween_cutscene.gd](scripts/nested_subtween_cutscene.gd)
Hierarchical cutscene management using `tween_subtween` for composable timelines.

### [relative_recoil_tween.gd](scripts/relative_recoil_tween.gd)
Using `as_relative()` and `from_current()` for dynamic movement offsets (recoil/nudges).

### [staggered_inventory_entry.gd](scripts/staggered_inventory_entry.gd)
Animating collections of items sequentially using a single Tween object.

### [looped_hover_vfx.gd](scripts/looped_hover_vfx.gd)
Creating infinite ping-pong ambient effects to replace heavy AnimationPlayers.

## NEVER Do in Tweening

- **NEVER instantiate a Tween using `Tween.new()`** — Tweens created manually are invalid. Always use `create_tween()` or `get_tree().create_tween()` [3, 4].
- **NEVER attempt to reuse a finished Tween** — Tweens are single-use objects. To replay an animation, you must create a new one [4].
- **NEVER manually instantiate `PropertyTweener` or `CallbackTweener`** — These must be generated only by the parent Tween methods like `tween_property` [5].
- **NEVER create an infinite loop containing only 0-duration animations** — This will freeze the engine. Always include at least one step with duration [10].
- **NEVER use multiple Tweens to animate the same property simultaneously** — The last one created takes priority, causing flicker. Use `kill()` on the old reference first [11, 12].
- **NEVER use linear interpolation for UI/Juice** — `TRANS_LINEAR` feels robotic. Use `EASE_OUT + TRANS_QUAD` or `EASE_IN_OUT + TRANS_CUBIC` for organic motion [22].
- **NEVER create tweens in `_process` without guards** — Creating 60 tweens per second will crash the app. Use a state check or kill the running one.
- **NEVER skip `bind_node(self)` for non-global tweens** — If the node is freed while a tween is running, it can cause errors. Binding ensures it dies with the node [13].
- **NEVER use 0-duration tweens for state changes** — If you want an instant change, just set the property directly (`position = goal`) to save overhead [20].
- **NEVER forget to call `chain()` when returning from `set_parallel(true)`** — If you want a sequence after a parallel block, you must explicitly chain it [15].

---

```gdscript
extends Sprite2D

func _ready() -> void:
    # Create tween
    var tween := create_tween()
    
    # Animate position over 2 seconds
    tween.tween_property(self, "position", Vector2(100, 100), 2.0)
```

## Tween Methods

### Property Animation

```gdscript
# Tween single property
var tween := create_tween()
tween.tween_property($Sprite, "modulate:a", 0.0, 1.0)  # Fade out

# Chain multiple tweens
tween.tween_property($Sprite, "position:x", 200, 1.0)
tween.tween_property($Sprite, "position:y", 100, 0.5)
```

### Callbacks

```gdscript
var tween := create_tween()
tween.tween_property($Sprite, "position", Vector2(100, 0), 1.0)
tween.tween_callback(func(): print("Animation done!"))
tween.tween_callback(queue_free)  # Delete after animation
```

### Intervals

```gdscript
var tween := create_tween()
tween.tween_property($Label, "modulate:a", 0.0, 0.5)
tween.tween_interval(1.0)  # Wait 1 second
tween.tween_property($Label, "modulate:a", 1.0, 0.5)
```

## Easing Functions

```gdscript
var tween := create_tween()
tween.set_ease(Tween.EASE_IN_OUT)  # Smooth start and end
tween.set_trans(Tween.TRANS_CUBIC)  # Cubic curve
tween.tween_property($Sprite, "position:x", 200, 1.0)
```

**Common Combinations:**
- `EASE_IN + TRANS_QUAD`: Accelerating
- `EASE_OUT + TRANS_QUAD`: Decelerating
- `EASE_IN_OUT + TRANS_CUBIC`: Smooth S-curve
- `EASE_OUT + TRANS_BOUNCE`: Bouncy effect

## Advanced Patterns

### Looping Animation

```gdscript
var tween := create_tween()
tween.set_loops()  # Infinite loop
tween.tween_property($Sprite, "rotation", TAU, 2.0)
```

### Parallel Tweens

```gdscript
var tween := create_tween()
tween.set_parallel(true)

# Both happen simultaneously
tween.tween_property($Sprite, "position", Vector2(100, 100), 1.0)
tween.tween_property($Sprite, "scale", Vector2(2, 2), 1.0)
```

### UI Button Hover Effect

```gdscript
extends Button

func _ready() -> void:
    mouse_entered.connect(_on_mouse_entered)
    mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered() -> void:
    var tween := create_tween()
    tween.tween_property(self, "scale", Vector2(1.1, 1.1), 0.2)

func _on_mouse_exited() -> void:
    var tween := create_tween()
    tween.tween_property(self, "scale", Vector2.ONE, 0.2)
```

### Number Counter

```gdscript
extends Label

func count_to(target: int, duration: float = 1.0) -> void:
    var current := int(text)
    var tween := create_tween()
    
    tween.tween_method(
        func(value: int): text = str(value),
        current,
        target,
        duration
    )
```

### Camera Smooth Follow

```gdscript
extends Camera2D

@export var follow_speed := 5.0
var target: Node2D

func _process(delta: float) -> void:
    if target:
        var tween := create_tween()
        tween.tween_property(
            self,
            "global_position",
            target.global_position,
            1.0 / follow_speed
        )
```

## Best Practices

### 1. Kill Previous Tweens

```gdscript
var current_tween: Tween = null

func animate_to(pos: Vector2) -> void:
    if current_tween:
        current_tween.kill()  # Stop previous animation
    
    current_tween = create_tween()
    current_tween.tween_property(self, "position", pos, 1.0)
```

### 2. Use Signals for Completion

```gdscript
var tween := create_tween()
tween.tween_property($Sprite, "position", Vector2(100, 0), 1.0)
tween.finished.connect(_on_tween_finished)

func _on_tween_finished() -> void:
    print("Animation complete!")
```

### 3. Chaining for Sequences

```gdscript
var tween := create_tween()

# Fade out
tween.tween_property($Sprite, "modulate:a", 0.0, 0.5)
# Move while invisible
tween.tween_property($Sprite, "position", Vector2(200, 0), 0.0)
# Fade in at new position
tween.tween_property($Sprite, "modulate:a", 1.0, 0.5)
```

## Common Gotchas

**Issue**: Tween stops when node is removed
```gdscript
# Solution: Bind tween to SceneTree
var tween := get_tree().create_tween()
tween.tween_property($Sprite, "position", Vector2(100, 0), 1.0)
```

**Issue**: Multiple conflicting tweens
```gdscript
# Solution: Use single tween or kill previous
# Always store reference to kill old tween
```

---

## Expert Pattern: Bezier-Path-Tween

Animate objects along complex, curved trajectories using `Path2D` and `PathFollow2D` instead of calculating math manually.

```gdscript
func play_curved_motion(follow_node: PathFollow2D, duration: float):
    # 1. Ensure path starts at 0
    follow_node.progress_ratio = 0.0
    
    # 2. Tween the sampler progress
    var tween := create_tween().bind_node(follow_node)
    tween.tween_property(follow_node, "progress_ratio", 1.0, duration) \
        .set_trans(Tween.TRANS_CUBIC) \
        .set_ease(Tween.EASE_IN_OUT)
```

---

## Expert Pattern: Physics-Sync-Tweening

Prevent jitter and visual "streaking" when animating physics bodies or handling network corrections.

```gdscript
func apply_physics_tween(target: Node3D, goal: Vector3):
    # 1. Prevent 'visual streak' if teleporting to a start position
    target.global_position = start_pos
    target.reset_physics_interpolation()
    
    # 2. Sync tween steps with physics frames
    var tween := create_tween().bind_node(target)
    tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
    
    tween.tween_property(target, "global_position", goal, 0.5)
```

---

## Expert Pattern: Juice-Config-Resource

Decouple animation "feel" from logic by storing tween parameters in external resources for global balancing.

```gdscript
# juice_config.gd
class_name JuiceConfig extends Resource
@export var duration: float = 0.3
@export var trans: Tween.TransitionType = Tween.TRANS_ELASTIC
@export var ease: Tween.EaseType = Tween.EASE_OUT

# gameplay_object.gd
@export var juice: JuiceConfig

func play_bounce():
    var tween := create_tween()
    tween.set_trans(juice.trans)
    tween.set_ease(juice.ease)
    tween.tween_property(self, "scale", Vector2(1.2, 1.2), juice.duration)
```

---

## Expert Pattern: Tween-Event-Sequencing

Orchestrate complex mini-cutscenes by chaining property interpolations, delays, and callbacks into a single controlled sequence.

```gdscript
func play_mini_cutscene(actor: Sprite2D):
    var tween := create_tween().bind_node(self)
    
    # 1. Step 1: Move and fade in (Parallel)
    tween.set_parallel(true)
    tween.tween_property(actor, "position:x", 500.0, 1.0)
    tween.tween_property(actor, "modulate:a", 1.0, 0.5)
    
    # 2. Step 2: Wait then call logic (Chained)
    tween.chain().tween_interval(0.5)
    tween.tween_callback(func(): _play_vfx(actor.position))
    
    # 3. Step 3: Shrink and exit
    tween.tween_property(actor, "scale", Vector2.ZERO, 0.5).set_trans(Tween.TRANS_BACK)
    tween.tween_callback(actor.queue_free)
```

## Reference
- [Godot Docs: Tween](https://docs.godotengine.org/en/stable/classes/class_tween.html)


### Related
- Master Skill: [godot-master](../godot-master/SKILL.md)
