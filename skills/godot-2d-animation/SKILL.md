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

> **MANDATORY**: Read the appropriate script before implementing the corresponding pattern.

### [animation_sync.gd](scripts/animation_sync.gd)
Method track triggers for frame-perfect logic (SFX/VFX hitboxes), signal-driven async gameplay orchestration, and AnimationTree blend space management. Use when syncing gameplay events to animation frames.

### [animation_state_sync.gd](scripts/animation_state_sync.gd)
Frame-perfect state-driven animation with transition queueing - essential for responsive character animation.

### [shader_hook.gd](scripts/shader_hook.gd)
Animating ShaderMaterial uniforms via AnimationPlayer property tracks. Covers hit flash, dissolve effects, and instance uniforms for batched sprites. Use for visual feedback tied to animation states.

### [procedural_squash_stretch.gd](scripts/procedural_squash_stretch.gd)
Dynamic physics-driven deformation. Provides `lerp` logic for smoothing out sudden impact squashes and directional stretches based on high-velocity movement.

### [skeleton_2d_rig_helper.gd](scripts/skeleton_2d_rig_helper.gd)
Programmatic rig management. Tuning FABRIK/CCDIK modification stacks and updating bone rest poses at runtime for procedural limb goal-reaching.

### [animation_tree_step.gd](scripts/animation_tree_step.gd)
Expert state machine control. Utilizes `AnimationNodeStateMachinePlayback.travel()` to leverage the engine's internal A* pathfinding for multi-state transitions.

### [one_frame_sync_fix.gd](scripts/one_frame_sync_fix.gd)
Eliminates the "One-Frame Glitch" by using `advance(0)` to force the engine to apply animation poses immediately alongside property changes like `flip_h`.

### [gpu_mesh_optimizer.gd](scripts/gpu_mesh_optimizer.gd)
Architectural pattern for bypassing GPU fill-rate bottlenecks. Demonstrates when to convert large sprites into specialized 2D meshes to avoid transparent pixel overhead.

### [multimesh_swarm_anim.gd](scripts/multimesh_swarm_anim.gd)
Optimization for thousands of entities. Offloads animation logic (sine waves, flight patterns) to the GPU vertex shader to eliminate CPU node processing.

### [tween_lifecycle_manager.gd](scripts/tween_lifecycle_manager.gd)
Safe and memory-efficient `Tween` orchestration. Handles interruption cleanup and property-fight prevention in fast-paced gameplay loops.

---

## AnimatedSprite2D Signals (Expert Usage)

### animation_looped vs animation_finished

```gdscript
extends CharacterBody2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
    # ✅ Correct: Use animation_looped for repeating animations
    anim.animation_looped.connect(_on_loop)
    
    # ✅ Correct: Use animation_finished ONLY for one-shots
    anim.animation_finished.connect(_on_finished)
    
    anim.play("run")  # Looping animation

func _on_loop() -> void:
    # Fires every loop iteration
    emit_particle_effect("dust")

func _on_finished() -> void:
    # Only fires for non-looping animations
    anim.play("idle")
```

### frame_changed for Event Triggering

```gdscript
# Frame-perfect event system (attacks, footsteps, etc.)
extends AnimatedSprite2D

signal attack_hit
signal footstep

# Define event frames per animation
const EVENT_FRAMES := {
    "attack": {3: "attack_hit", 7: "attack_hit"},
    "run": {2: "footstep", 5: "footstep"}
}

func _ready() -> void:
    frame_changed.connect(_on_frame_changed)

func _on_frame_changed() -> void:
    var events := EVENT_FRAMES.get(animation, {})
    if frame in events:
        emit_signal(events[frame])
```

---

## Advanced Pattern: Animation State Sync

### Problem: play() Timing Glitch

When updating both animation and sprite properties (e.g., `flip_h` + animation change), `play()` doesn't apply until next frame, causing a 1-frame visual glitch.

```gdscript
# ❌ BAD: Glitches for 1 frame
func change_direction(dir: int) -> void:
    anim.flip_h = (dir < 0)
    anim.play("run")  # Applied NEXT frame
    # Result: 1 frame of wrong animation with correct flip

# ✅ GOOD: Force immediate sync
func change_direction(dir: int) -> void:
    anim.flip_h = (dir < 0)
    anim.play("run")
    anim.advance(0)  # Force immediate update
```

---

## set_frame_and_progress() for Smooth Transitions

Use when changing animations mid-animation without visual stutter:

```gdscript
# Example: Skin swapping without animation reset
func swap_skin(new_skin: String) -> void:
    var current_frame := anim.frame
    var current_progress := anim.frame_progress
    
    # Load new SpriteFrames resource
    anim.sprite_frames = load("res://skins/%s.tres" % new_skin)
    
    # ✅ Preserve exact animation state
    anim.play(anim.animation)  # Re-apply animation
    anim.set_frame_and_progress(current_frame, current_progress)
    # Result: Seamless skin swap mid-animation
```

---

## Expert Decision Tree: Choosing the Right Animation Tool

| Scenario | Recommended Node | Expert Insight |
|----------|------------------|----------------|
| Isolated, pure frame-by-frame spritesheets | **AnimatedSprite2D** | Simple and effective, but cannot animate non-visual properties, manipulate transforms, or trigger external methods. |
| Cutout animations, non-visual sync, audio/particles | **AnimationPlayer** | Required when manipulating transforms of many child sprites, driving 2D mesh deformations, or syncing methods/particles to visual frames. |
| Complex state machines, blending, locomotion | **AnimationTree** | Essential for blending movement directions. Does not hold animations itself; it's a logic graph driving an underlying AnimationPlayer. |
| Procedural, dynamic, fire-and-forget UI/fx | **Tween** | Target values calculated at runtime. Far more lightweight than AnimationPlayer; designed to be created and discarded via script. |
| Swarms of thousands of entities (bats, fish) | **MultiMeshInstance2D + Shader** | Bypasses the node system entirely. Calculate sine waves/movement on the GPU vertex shader to avoid massive CPU bottlenecks. |

---

## Expert Pattern: Procedural Squash & Stretch

```gdscript
# Physics-driven squash/stretch for game feel
extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D
var _base_scale := Vector2.ONE

func _physics_process(delta: float) -> void:
    var prev_velocity := velocity
    move_and_slide()
    
    # Squash on landing
    if not is_on_floor() and is_on_floor():
        var impact_strength := clamp(abs(prev_velocity.y) / 800.0, 0.0, 1.0)
        _squash_and_stretch(Vector2(1.0 + impact_strength * 0.3, 1.0 - impact_strength * 0.3))
    
    # Stretch during jump
    elif velocity.y < -200:
        sprite.scale = _base_scale.lerp(Vector2(0.9, 1.1), delta * 5.0)
    else:
        sprite.scale = sprite.scale.lerp(_base_scale, delta * 10.0)

func _squash_and_stretch(target_scale: Vector2) -> void:
    var tween := create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
    tween.tween_property(sprite, "scale", target_scale, 0.08)
    tween.tween_property(sprite, "scale", _base_scale, 0.12)
```

---

## Cutout Animation (Bone2D Skeleton)

For complex skeletal animation, use Bone2D instead of manual Sprite2D parenting:

### Skeleton Setup

```
Player (Node2D)
  └─ Skeleton2D
      ├─ Bone2D (Root - Torso)
      │   ├─ Sprite2D (Body)
      │   └─ Bone2D (Head)
      │       └─ Sprite2D (Head)
      ├─ Bone2D (ArmLeft)
      │   └─ Sprite2D (Arm)
      └─ Bone2D (ArmRight)
          └─ Sprite2D (Arm)
```

### AnimationPlayer Tracks

```gdscript
# Key bone rotations in AnimationPlayer
# Tracks:
# - "Skeleton2D/Bone2D:rotation"
# - "Skeleton2D/Bone2D/Bone2D2:rotation" (head)
# - "Skeleton2D/Bone2D3:rotation" (arm left)
```

**Why Bone2D over manual parenting?**
- Forward Kinematics (FK) and Inverse Kinematics (IK) support
- Easier to rig and weight paint
- Better integration with animation retargeting

---

## Performance: SpriteFrames Optimization

```gdscript
# ✅ GOOD: Share SpriteFrames resource across instances
const SHARED_FRAMES := preload("res://characters/player_frames.tres")

func _ready() -> void:
    anim_sprite.sprite_frames = SHARED_FRAMES
    # All player instances share same resource in memory

# ❌ BAD: Each instance loads separately
func _ready() -> void:
    anim_sprite.sprite_frames = load("res://characters/player_frames.tres")
    # Duplicates resource in memory per instance
```

---

## Edge Case: Pixel Art Centering

```gdscript
# Pixel art textures can appear blurry when centered between pixels
# Solution 1: Disable centering
anim_sprite.centered = false
anim_sprite.offset = Vector2.ZERO

# Solution 2: Enable global pixel snapping (Project Settings)
# rendering/2d/snap/snap_2d_vertices_to_pixel = true
# rendering/2d/snap/snap_2d_transforms_to_pixel = true
```

### SpriteFrames Texture Filtering

```gdscript
# Problem: SpriteFrames uses bilinear filtering (blurry for pixel art)
# Solution: In Import tab for each texture:
# - Filter: Nearest (for pixel art)
# - Mipmaps: Off (prevents blending at distance)

# Or set globally in Project Settings:
# rendering/textures/canvas_textures/default_texture_filter = Nearest
```



---

## Expert Techniques & Optimizations

### 1. Hybrid Cutout and Cel Animation
Do not limit yourself to just one style. Use `AnimationPlayer` to rig a 2D skeleton and animate the bones (Cutout animation), while simultaneously keyframing the `texture` or `frame` properties of specific child sprites. This allows highly efficient transform-based animation for the body, while selectively swapping hand shapes or facial expressions using traditional hand-drawn cel animation.

### 2. Optimizing GPU Fill Rate with 2D Meshes
Sprites with large transparent areas (like tree leaves) waste GPU fill rate. Convert a `Sprite2D` into a `MeshInstance2D` in Godot. This generates a 2D polygon that tightly hugs the opaque pixels, bypassing transparent areas. While this slightly increases vertex processing time, it massively improves GPU fill rate on complex 2D scenes.

### 3. Safe Tween Interruption and Looping
Game states change rapidly. Ensure Tweens are properly cleaned up before starting new ones to avoid memory leaks and conflicting animations.

```gdscript
extends Node2D

var _tween: Tween

func animate_damage_flash() -> void:
    # Anti-pattern prevention: Always kill the existing tween before overwriting it.
    if _tween:
        _tween.kill()
        
    _tween = create_tween()
    
    # Chain tweeners and use loops for rapid, predictable animation
    _tween.set_loops(3)
    _tween.tween_property($Sprite2D, "modulate", Color.RED, 0.1).set_trans(Tween.TRANS_SINE)
    _tween.tween_property($Sprite2D, "modulate", Color.WHITE, 0.1).set_trans(Tween.TRANS_SINE)
```

### 4. Advanced State Machine Travel via AnimationTree
When using an `AnimationNodeStateMachine` within an `AnimationTree`, you do not directly "play" animations. You command the state machine to compute the shortest path (using A*) to a new state.

```gdscript
extends CharacterBody2D

@onready var animation_tree: AnimationTree = $AnimationTree
# Retrieve the playback object from the AnimationTree properties
@onready var state_machine: AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")

func _ready() -> void:
    # The state machine must be started before traveling
    state_machine.start("idle")

func _physics_process(delta: float) -> void:
    if velocity.length() > 0:
        # Travel to the run state. Internal A* will seamlessly play intermediate transitions.
        state_machine.travel("run")
    else:
        state_machine.travel("idle")
```

---

## Expert Pattern: Animation-Frame-Data-Extractor

To extract custom per-frame metadata (e.g., spawn offsets, hitbox sizes), use an `AnimationPlayer` in conjunction with `AnimatedSprite2D`. `SpriteFrames` is strictly a visual container; `AnimationPlayer` allows you to decouple visual data from logical metadata using **Value Tracks** or **Call Method Tracks**.

```gdscript
class_name AnimationDataExtractor extends CharacterBody2D

# 1. Define the metadata property (Value Track target)
@export var current_spawn_offset: Vector2 = Vector2.ZERO:
    set(value):
        current_spawn_offset = value
        _update_spawn_point()

@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var spawn_marker: Marker2D = $SpawnMarker

func _ready() -> void:
    # Playing via AnimationPlayer updates 'current_spawn_offset' on keyed frames
    anim_player.play("attack_shoot")

func _update_spawn_point() -> void:
    spawn_marker.position = current_spawn_offset

# 2. Call Method Track Implementation
# Use this to pass complex arguments directly to a function on a specific frame
func spawn_projectile(damage: int, specific_offset: Vector2) -> void:
    var projectile = PROJECTILE_SCENE.instantiate()
    projectile.damage = damage
    projectile.position = global_position + specific_offset
    get_parent().add_child(projectile)
```

---

## Expert Pattern: Skeletal-IK-2D (Procedural Foot Placement)

For procedural limb positioning (e.g., planting feet on slopes), use Godot's built-in 2D skeletal modification system. The `SkeletonModification2DTwoBoneIK` is the elite choice for limbs as it is more lightweight than full FABRIK solvers.

### Setup
1. Add a `SkeletonModificationStack2D` to your `Skeleton2D`.
2. Add a `SkeletonModification2DTwoBoneIK` to the stack.
3. Assign the target bones (e.g., UpperLeg and LowerLeg).
4. Point the `target_nodepath` to a `Marker2D` (IK Target).

```gdscript
class_name ProceduralWalker2D extends Node2D

@onready var skeleton: Skeleton2D = $Skeleton2D
@onready var ik_target_left_foot: Marker2D = $IKTargets/LeftFootTarget
@onready var floor_raycast: RayCast2D = $RayCasts/LeftFootRay

func _ready() -> void:
    # Ensure modification stack is enabled
    var mod_stack: SkeletonModificationStack2D = skeleton.get_modification_stack()
    if mod_stack:
        mod_stack.enabled = true
        mod_stack.enable_all_modifications(true)

func _physics_process(_delta: float) -> void:
    floor_raycast.force_raycast_update()
    
    if floor_raycast.is_colliding():
        # Move IK target to the exact collision point
        ik_target_left_foot.global_position = floor_raycast.get_collision_point()
    else:
        # Fallback to resting position
        ik_target_left_foot.position = Vector2(0, 50)
```

---

## Expert Pattern: Sprite-Sheet-Memory-Manager

Dynamically load and unload high-resolution textures to optimize VRAM usage. Leverage `ResourceLoader` for asynchronous loading and `RefCounted` for automatic memory purging.

```gdscript
class_name SpriteSheetMemoryManager extends Node

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
var _pending_path: String = ""
var _target_anim: StringName = &"heavy_attack"

func load_high_res_anim(path: String) -> void:
    _pending_path = path
    # 1. Start background loading to prevent frame stutter
    ResourceLoader.load_threaded_request(_pending_path)
    set_process(true)

func _process(_delta: float) -> void:
    # 2. Check loading status
    var status = ResourceLoader.load_threaded_get_status(_pending_path)
    if status == ResourceLoader.THREAD_LOAD_LOADED:
        var tex: Texture2D = ResourceLoader.load_threaded_get(_pending_path)
        _apply_to_frames(tex)
        set_process(false)

func _apply_to_frames(tex: Texture2D) -> void:
    var frames: SpriteFrames = animated_sprite.sprite_frames
    if not frames.has_animation(_target_anim):
        frames.add_animation(_target_anim)
    
    # 3. Inject frame dynamically
    frames.add_frame(_target_anim, tex)
    animated_sprite.play(_target_anim)

func unload_high_res_anim() -> void:
    var frames: SpriteFrames = animated_sprite.sprite_frames
    if frames.has_animation(_target_anim):
        # 4. Breaking the reference to the Texture2D frees it from RAM
        frames.clear(_target_anim)
```

## Reference
- Master Skill: [godot-master](../godot-master/SKILL.md)
