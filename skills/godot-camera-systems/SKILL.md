---
name: godot-camera-systems
description: "Expert patterns for 2D/3D camera control including smooth following (lerp, position_smoothing), camera shake (trauma system), screen shake with frequency parameters, deadzone/drag for platformers, look-ahead prediction, and camera transitions. Use for player cameras, cinematic sequences, or multi-camera systems. Trigger keywords: Camera2D, Camera3D, SpringArm3D, position_smoothing, camera_shake, trauma_system, look_ahead, drag_margin, camera_limits, camera_transition."
---

## Godot 4.7 Baseline

- Expert patterns in this skill target **Godot 4.7+** (stable, 2026-06-18).
- Consult the [Godot 4.7 migration guide](https://docs.godotengine.org/en/4.7/tutorials/migrating/upgrading_to_godot_4.7.html) when upgrading projects from 4.6.
- **NEVER** assume 4.6 defaults (stretch mode, audio area_mask, RichTextLabel percent flags) without checking 4.7 migration notes.

# Camera Systems

Expert guidance for creating smooth, responsive cameras in 2D and 3D games.

## NEVER Do

- **NEVER use `global_position = target.global_position` every frame** — Instant position matching causes jittery movement. Use `lerp()` or `position_smoothing_enabled = true` [12].
- **NEVER use `offset` for permanent camera positioning** — `offset` is for shake, sway, or temporary recoil effects only. Use `position` for permanent framing to avoid logic conflicts [14].
- **NEVER forget `limit_smoothed = true` for `Camera2D`** — Hard boundaries cause jarring visual stops. Smoothing against limits ensures a professional feel [13].
- **NEVER enable multiple `Camera2D` nodes in the same viewport simultaneously** — Only the last enabled camera takes precedence. Explicitly disable inactive cameras [15].
- **NEVER use `SpringArm3D` without a collision mask** — It will clip through terrain and walls. Set it to the world/environment layer [16].
- **NEVER implement screen shake by randomizing `position` directly** — This overwrites follow-logic. Use `offset` or a dedicated Trauma/Noise system to Layer shake over the follow-position [27, 28].
- **NEVER parent the Camera directly to a high-speed physics body** — Physics stutter or parent rotation will cause motion sickness. Use `RemoteTransform2D/3D` with rotation sync disabled for a stable view [30].
- **NEVER use `look_at()` in 3D without a fallback for the 'Up' vector** — If the target is directly above/below, the camera will flip wildly. Use guards or `Quaternion` math for vertical tracking.
- **NEVER rely on `SubViewport` defaults for Mini-maps** — Viewports are expensive; explicitly set `render_target_update_mode` to `UPDATE_WHEN_VISIBLE` or a fixed lower framerate to save GPU [156].
- **NEVER use linear interpolation for Zoom** — It feels 'robotic'. Use exponential lerp or a `Tween` with `TRANS_CUBIC` for a more natural tactical feel.

---

## Available Scripts

> **MANDATORY**: Read before implementing camera behaviors.

### [camera_shake_trauma_pro.gd](scripts/camera_shake_trauma_pro.gd)
Advanced noise-based screenshake (Trauma system) for organic, non-jittery explosions and impacts.

### [cinematic_framing_logic.gd](scripts/cinematic_framing_logic.gd)
Rule of Thirds and Lead Room management in code, ensuring high-quality cinematic composition.

### [camera_state_machine.gd](scripts/camera_state_machine.gd)
Managing transitions between 'Follow', 'Static', and 'Cinematic' camera states with Tweens.

### [minimap_viewport_manager.gd](scripts/minimap_viewport_manager.gd)
SubViewport optimization for Mini-maps and UI overlays. Reduces render updates for better FPS.

### [split_screen_setup.gd](scripts/split_screen_setup.gd)
Dynamic split-screen architecture for local multiplayer, handling viewport stretching and audio listeners.

### [remote_transform_decoupling.gd](scripts/remote_transform_decoupling.gd)
Decoupling camera position from player rotation/scale using `RemoteTransform2D` for high-speed stability.

### [zoom_damping_controller.gd](scripts/zoom_damping_controller.gd)
Non-linear, smooth zoom logic with tactical overview bounds and mouse-wheel support.

### [spring_lerp_camera_3d.gd](scripts/spring_lerp_camera_3d.gd)
Physics-stable 3D follow camera using spring-mass interpolation to reduce follow-latency jitter.

### [first_person_sway.gd](scripts/first_person_sway.gd)
Procedural 8-figure head bob and weapon sway logic for immersive First-Person systems.

### [deadzone_drag_margins.gd](scripts/deadzone_drag_margins.gd)
Platformer-specific deadzone management using code to control follow-margins and drag-center behavior.

---

## Camera2D Basics

```gdscript
extends Camera2D

@export var target: Node2D
@export var follow_speed := 5.0

func _process(delta: float) -> void:
    if target:
        global_position = global_position.lerp(
            target.global_position,
            follow_speed * delta
        )
```

## Position Smoothing

```gdscript
extends Camera2D

func _ready() -> void:
    # Built-in smoothing
    position_smoothing_enabled = true
    position_smoothing_speed = 5.0
```

## Camera Limits

```gdscript
extends Camera2D

func _ready() -> void:
    # Constrain camera to level bounds
    limit_left = 0
    limit_top = 0
    limit_right = 1920
    limit_bottom = 1080
    
    # Smooth against limits
    limit_smoothed = true
```

## Camera Shake

```gdscript
extends Camera2D

var shake_amount := 0.0
var shake_decay := 5.0

func _process(delta: float) -> void:
    if shake_amount > 0:
        shake_amount = max(shake_amount - shake_decay * delta, 0)
        offset = Vector2(
            randf_range(-shake_amount, shake_amount),
            randf_range(-shake_amount, shake_amount)
        )
    else:
        offset = Vector2.ZERO

func shake(intensity: float) -> void:
    shake_amount = intensity

# Usage:
$Camera2D.shake(10.0)  # Screen shake on explosion
```

## Zoom Controls

```gdscript
extends Camera2D

@export var zoom_speed := 0.1
@export var min_zoom := 0.5
@export var max_zoom := 2.0

func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventMouseButton:
        if event.button_index == MOUSE_BUTTON_WHEEL_UP:
            zoom_in()
        elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
            zoom_out()

func zoom_in() -> void:
    zoom = zoom.move_toward(
        Vector2.ONE * max_zoom,
        zoom_speed
    )

func zoom_out() -> void:
    zoom = zoom.move_toward(
        Vector2.ONE * min_zoom,
        zoom_speed
    )
```

## Look-Ahead Camera

```gdscript
extends Camera2D

@export var look_ahead_distance := 50.0
@export var target: CharacterBody2D

func _process(delta: float) -> void:
    if target:
        var look_ahead := target.velocity.normalized() * look_ahead_distance
        global_position = target.global_position + look_ahead
```

## Split-Screen (Multiple Cameras)

```gdscript
# Player 1 Camera
@onready var cam1: Camera2D = $Player1/Camera2D

# Player 2 Camera
@onready var cam2: Camera2D = $Player2/Camera2D

func _ready() -> void:
    # Split viewport
    cam1.anchor_mode = Camera2D.ANCHOR_MODE_DRAG_CENTER
    cam2.anchor_mode = Camera2D.ANCHOR_MODE_DRAG_CENTER
```

## Camera3D Patterns

### Third-Person Camera

```gdscript
extends Camera3D

@export var target: Node3D
@export var distance := 5.0
@export var height := 2.0
@export var rotation_speed := 3.0

var rotation_angle := 0.0

func _process(delta: float) -> void:
    if not target:
        return
    
    # Rotate around target
    rotation_angle += Input.get_axis("camera_left", "camera_right") * rotation_speed * delta
    
    # Calculate position
    var offset := Vector3(
        sin(rotation_angle) * distance,
        height,
        cos(rotation_angle) * distance
    )
    
    global_position = target.global_position + offset
    look_at(target.global_position, Vector3.UP)
```

### First-Person Camera

```gdscript
extends Camera3D

@export var mouse_sensitivity := 0.002
@export var max_pitch := deg_to_rad(80)

var pitch := 0.0

func _ready() -> void:
    Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event: InputEvent) -> void:
    if event is InputEventMouseMotion:
        # Yaw (horizontal)
        get_parent().rotate_y(-event.relative.x * mouse_sensitivity)
        
        # Pitch (vertical)
        pitch -= event.relative.y * mouse_sensitivity
        pitch = clamp(pitch, -max_pitch, max_pitch)
        rotation.x = pitch
```

## Camera Transitions

```gdscript
# Smooth camera position change
func move_to_position(target_pos: Vector2, duration: float = 1.0) -> void:
    var tween := create_tween()
    tween.tween_property(self, "global_position", target_pos, duration)
    tween.set_ease(Tween.EASE_IN_OUT)
    tween.set_trans(Tween.TRANS_CUBIC)
```

## Cinematic Cameras

```gdscript
# Camera path following
extends Path2D

@onready var path_follow: PathFollow2D = $PathFollow2D
@onready var camera: Camera2D = $PathFollow2D/Camera2D

func play_cutscene(duration: float) -> void:
    var tween := create_tween()
    tween.tween_property(path_follow, "progress_ratio", 1.0, duration)
    await tween.finished
```

## Best Practices

### 1. One Active Camera

```gdscript
# Only one Camera2D should be enabled at a time
# Others should have enabled = false
```

### 2. Parent Camera to Player

```gdscript
# Scene structure:
# Player (CharacterBody2D)
#   └─ Camera2D
```

### 3. Use Anchors for UI

```gdscript
# Camera doesn't affect UI positioned with anchors
# UI stays in screen space
```

### 4. Deadzone for Platformers

```gdscript
extends Camera2D

func _ready() -> void:
    drag_horizontal_enabled = true
    drag_vertical_enabled = true
    drag_left_margin = 0.3
    drag_right_margin = 0.3
```

## Expert Camera Architectures

### 1. Camera Framing Box (Multi-Target Framing)
To handle multiple targets in a single frame (e.g., Smash Bros or Local-Coop), calculate the AABB (Axis-Aligned Bounding Box) of all targets. Interpolate the camera's `global_position` to the center of the box and adjust the `zoom` (2D) or `distance` (3D) to encapsulate the entire box with a padding margin.

```gdscript
class_name FramingBoxCamera2D extends Camera2D
## Dynamically zooms and pans to frame multiple targets.

@export var targets: Array[Node2D] = []
@export var margin: float = 100.0
@export var min_zoom: float = 0.5
@export var max_zoom: float = 2.0

func _physics_process(_delta: float) -> void:
    if targets.is_empty(): return
    
    # 1. Calculate the bounding box of all targets.
    var rect := Rect2(targets[0].global_position, Vector2.ZERO)
    for target in targets:
        rect = rect.expand(target.global_position)
    
    # 2. Add padding.
    rect = rect.grow(margin)
    
    # 3. Position the camera at the center.
    global_position = rect.get_center()
    
    # 4. Calculate required zoom level to fit the box.
    var screen_size := get_viewport_rect().size
    var zoom_x := screen_size.x / rect.size.x
    var zoom_y := screen_size.y / rect.size.y
    var target_zoom := clampf(min(zoom_x, zoom_y), min_zoom, max_zoom)
    
    zoom = Vector2.ONE * target_zoom
```

### 2. Camera Raycasting (SpringArm3D / RayCast3D)
To prevent the camera from clipping through terrain in 3D, use a `SpringArm3D` node. For custom camera logic, query the physics space directly using `intersect_ray()`. This allows you to smoothly interpolate the camera closer to the player when an obstruction (e.g., a wall) is detected between the camera's desired position and the target.

```gdscript
class_name OcclusionAwareCamera3D extends Camera3D
## Prevents camera clipping via manual physics space raycasting.

@export var target: Node3D
@export var ideal_distance: float = 5.0

func _physics_process(_delta: float) -> void:
    if not target: return
    
    var space_state := get_world_3d().direct_space_state
    var desired_pos := target.global_position + (Vector3.BACK * ideal_distance)
    
    # Query for obstructions between the target and the desired camera position.
    var query := PhysicsRayQueryParameters3D.create(target.global_position, desired_pos)
    query.exclude = [target.get_rid()]
    
    var result: Dictionary = space_state.intersect_ray(query)
    
    if not result.is_empty():
        # Move the camera to the hit position (with a small offset to prevent clipping).
        global_position = result.position + result.normal * 0.2
    else:
        global_position = desired_pos
        
    look_at(target.global_position)
```

### 3. Screenshake Audit (Trauma Decay Profiler)
A "Screenshake Audit" involves visualizing the trauma-decay curve over time. By plotting the `current_trauma` value to a graph using the `CanvasItem._draw()` API, you can precisely tune the "punchiness" and "decay duration" of impacts to ensure they feel intentional rather than random noise.

```gdscript
class_name TraumaDebugger extends Node2D
## Visualizes the decay curve of a trauma-based shake system.

@export var camera: ProceduralScreenShake
var _history: PackedFloat32Array = []

func _process(_delta: float) -> void:
    if not camera: return
    
    _history.append(camera.get_current_trauma())
    if _history.size() > 200: _history.remove_at(0)
    queue_redraw()

func _draw() -> void:
    var width := 400.0
    var height := 100.0
    var step := width / 200.0
    
    for i in range(1, _history.size()):
        var p1 := Vector2(i * step, height - (_history[i-1] * height))
        var p2 := Vector2((i+1) * step, height - (_history[i] * height))
        draw_line(p1, p2, Color.YELLOW, 2.0)
```

## Reference
- [Godot Docs: Camera2D](https://docs.godotengine.org/en/stable/classes/class_camera2d.html)
- [Godot Docs: Camera3D](https://docs.godotengine.org/en/stable/classes/class_camera3d.html)


### Related
- Master Skill: [godot-master](../godot-master/SKILL.md)
