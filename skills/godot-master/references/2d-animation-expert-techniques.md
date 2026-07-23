# Expert Techniques

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
