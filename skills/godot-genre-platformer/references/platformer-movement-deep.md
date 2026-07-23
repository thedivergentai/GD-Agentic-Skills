# Platformer Movement & Juice Deep-Dive (load on demand)

> **LLM-ignorance keep rule:** content here is expert Godot/genre knowledge a general agent would not know without reading — never delete, only relocate.

> **MANDATORY** when implementing systems beyond the `scripts/` catalog. Peer skills own full tutorials — route after this reference.

---

## Movement Feel ("Game Feel")

The most critical aspect of platformers. Players should feel **precise, responsive, and in control**.

### Input Responsiveness

```gdscript
# Instant direction changes - no acceleration on ground
func _physics_process(delta: float) -> void:
    var input_dir := Input.get_axis("move_left", "move_right")
    
    # Ground movement: instant response
    if is_on_floor():
        velocity.x = input_dir * MOVE_SPEED
    else:
        # Air movement: slightly reduced control
        velocity.x = move_toward(velocity.x, input_dir * MOVE_SPEED, AIR_ACCEL * delta)
```

### Coyote Time (Grace Period)

Allow jumping briefly after leaving a platform:

```gdscript
var coyote_timer: float = 0.0
const COYOTE_TIME := 0.1  # 100ms grace period

func _physics_process(delta: float) -> void:
    if is_on_floor():
        coyote_timer = COYOTE_TIME
    else:
        coyote_timer = max(0, coyote_timer - delta)
    
    # Can jump if on floor OR within coyote time
    if Input.is_action_just_pressed("jump") and coyote_timer > 0:
        velocity.y = JUMP_VELOCITY
        coyote_timer = 0
```

### Jump Buffering

Register jumps pressed slightly before landing:

```gdscript
var jump_buffer: float = 0.0
const JUMP_BUFFER_TIME := 0.15

func _physics_process(delta: float) -> void:
    if Input.is_action_just_pressed("jump"):
        jump_buffer = JUMP_BUFFER_TIME
    else:
        jump_buffer = max(0, jump_buffer - delta)
    
    if is_on_floor() and jump_buffer > 0:
        velocity.y = JUMP_VELOCITY
        jump_buffer = 0
```

### Variable Jump Height

```gdscript
const JUMP_VELOCITY := -400.0
const JUMP_RELEASE_MULTIPLIER := 0.5

func _physics_process(delta: float) -> void:
    # Cut jump short when button released
    if Input.is_action_just_released("jump") and velocity.y < 0:
        velocity.y *= JUMP_RELEASE_MULTIPLIER
```

### Gravity Tuning

```gdscript
const GRAVITY := 980.0
const FALL_GRAVITY_MULTIPLIER := 1.5  # Faster falls feel better
const MAX_FALL_SPEED := 600.0

func apply_gravity(delta: float) -> void:
    var grav := GRAVITY
    if velocity.y > 0:  # Falling
        grav *= FALL_GRAVITY_MULTIPLIER
    velocity.y = min(velocity.y + grav * delta, MAX_FALL_SPEED)
```

---

---

## Godot-Specific Tips

1. **CharacterBody2D vs RigidBody2D**: Always use `CharacterBody2D` for platformer characters - precise control is essential
2. **Physics tick rate**: Consider 120Hz physics for smoother movement
3. **One-way platforms**: Use `set_collision_mask_value()` or dedicated collision layers
4. **Wall detection**: Use `is_on_wall()` and `get_wall_normal()` for wall jumps

---

---

## Example Games for Reference

- **Celeste** - Perfect game feel, assist mode accessibility
- **Hollow Knight** - Combat + platforming integration
- **Super Mario Bros. Wonder** - Visual polish and surprises
- **Shovel Knight** - Retro mechanics with modern feel

---

## Advanced Platformer Mechanics

Elite implementation of competitive features, procedural world-building, and specialized physics.

### 1. Squash and Stretch Helper (Visual Juice)
To apply high-fidelity visual juice, modify the scale of the character's visual node using `Tween`. This provides non-linear interpolation for bouncy, responsive movement that makes actions like jumping and landing feel physically grounded.

```gdscript
class_name GameFeelHelper extends Node

func apply_squash_and_stretch(visual_node: Node2D, target_scale: Vector2, duration: float) -> void:
    var tween := visual_node.create_tween()
    tween.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
    # Squash
    tween.tween_property(visual_node, "scale", target_scale, duration)
    # Return to normal
    tween.tween_property(visual_node, "scale", Vector2.ONE, duration)
```

### 2. Particle-Trails
Enable 3D or 2D particle trails by configuring `GPUParticles3D` with the `trail_enabled` property. This creates a procedural trail of meshes or sprites that follows the player, enhancing the sense of speed and direction.

```gdscript
class_name SpeedTrail extends GPUParticles3D

func toggle_trail(active: bool) -> void:
    emitting = active
    trail_enabled = true
    trail_lifetime = 0.5
    # Configure via shader or process_material for color fading
```

### 3. Checkpoint-System
Implement a reliable checkpoint system by recording the player's `global_position` upon entering a designated `Area2D` trigger. Store the checkpoint as a `Resource` to ensure it persists across scene transitions and game restarts.

```gdscript
class_name Checkpoint extends Area2D

@export var checkpoint_id: StringName

func _on_body_entered(body: Node2D) -> void:
    if body.is_in_group("player"):
        SaveManager.current_checkpoint_pos = global_position
        SaveManager.last_checkpoint_id = checkpoint_id
        # Play visual/audio feedback
        play_activation_effects()
```

**Expert Tip**: For the "Squash and Stretch" effect, ensure the visual node's pivot point is at the character's feet (bottom center) so the scaling happens from the ground up.
