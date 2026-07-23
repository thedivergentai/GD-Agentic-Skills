# Dimension Reduction

## Node Conversion

### Physics Bodies

```gdscript
# CharacterBody3D → CharacterBody2D
extends CharacterBody3D  # Before

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const GRAVITY = 9.8

func _physics_process(delta: float) -> void:
    velocity.y -= GRAVITY * delta
    var input := Input.get_vector("left", "right", "forward", "back")
    velocity.x = input.x * SPEED
    velocity.z = input.y * SPEED
    move_and_slide()

# ⬇️ Convert to:

extends CharacterBody2D  # After

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const GRAVITY = 980.0  # Pixels per second squared

func _physics_process(delta: float) -> void:
    velocity.y += GRAVITY * delta
    var input := Input.get_vector("left", "right", "up", "down")
    velocity.x = input.x * SPEED
    # Note: No Z-axis. For platformer, use input.y for jump
    move_and_slide()
```

### Camera Conversion

```gdscript
# Camera3D → Camera2D
# Before: Third-person 3D camera
extends SpringArm3D

@onready var camera: Camera3D = $Camera3D

func _process(delta: float) -> void:
    spring_length = 10.0
    rotate_y(Input.get_axis("cam_left", "cam_right") * delta)

# ⬇️ Convert to:

extends Camera2D  # After

@onready var player: CharacterBody2D = $"../Player"

func _process(delta: float) -> void:
    global_position = player.global_position
    zoom = Vector2(2.0, 2.0)  # Adjust to taste
```

---
