# Migration Recipes

## Migration Steps

### Step 1: Physics Layer Reconfiguration

```gdscript
# 2D collision layers are SEPARATE from 3D
# You must reconfigure in Project Settings → Layer Names → 3D Physics

# Before (2D):
# Layer 1: Player
# Layer 2: Enemies
# Layer 3: World

# After (3D) - same names, but different system
# In code, update all collision layer references:

# 2D version:
# collision_layer = 0b0001

# 3D version (same logic, different node):
var character_3d := CharacterBody3D.new()
character_3d.collision_layer = 0b0001  # Layer 1: Player
character_3d.collision_mask = 0b0110   # Detect Enemies + World
```

### Step 2: Camera Conversion

```gdscript
# ❌ BAD: Direct 2D follow logic
extends Camera3D

@onready var player: Node3D = $"../Player"

func _process(delta: float) -> void:
    global_position = player.global_position  # Clipping, disorienting!

# ✅ GOOD: Third-person camera with SpringArm3D
# Scene structure:
# Player (CharacterBody3D)
#   └─ SpringArm3D
#       └─ Camera3D

# player.gd
extends CharacterBody3D

@onready var spring_arm: SpringArm3D = $SpringArm3D
@onready var camera: Camera3D = $SpringArm3D/Camera3D

func _ready() -> void:
    spring_arm.spring_length = 10.0  # Distance from player
    spring_arm.position = Vector3(0, 2, 0)  # Above player

func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventMouseMotion:
        spring_arm.rotate_y(-event.relative.x * 0.005)  # Horizontal rotation
        spring_arm.rotate_object_local(Vector3.RIGHT, -event.relative.y * 0.005)  # Vertical
        
        # Clamp vertical rotation
        spring_arm.rotation.x = clamp(spring_arm.rotation.x, -PI/3, PI/6)
```

### Step 3: Movement Conversion

```gdscript
# 2D platformer movement
extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

func _physics_process(delta: float) -> void:
    if not is_on_floor():
        velocity.y += gravity * delta
    
    if Input.is_action_just_pressed("jump") and is_on_floor():
        velocity.y = JUMP_VELOCITY
    
    var direction := Input.get_axis("left", "right")
    velocity.x = direction * SPEED
    
    move_and_slide()

# ✅ 3D equivalent (third-person platformer)
extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const GRAVITY = 9.8

@onready var spring_arm: SpringArm3D = $SpringArm3D

func _physics_process(delta: float) -> void:
    if not is_on_floor():
        velocity.y -= GRAVITY * delta
    
    if Input.is_action_just_pressed("jump") and is_on_floor():
        velocity.y = JUMP_VELOCITY
    
    # Movement relative to camera direction
    var input_dir := Input.get_vector("left", "right", "forward", "back")
    var camera_basis := spring_arm.global_transform.basis
    var direction := (camera_basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
    
    if direction:
        velocity.x = direction.x * SPEED
        velocity.z = direction.z * SPEED
        
        # Rotate player to face movement direction
        rotation.y = lerp_angle(rotation.y, atan2(-direction.x, -direction.z), 0.1)
    else:
        velocity.x = move_toward(velocity.x, 0, SPEED)
        velocity.z = move_toward(velocity.z, 0, SPEED)
    
    move_and_slide()
```

---

## Performance Budgeting

### 2D vs 3D Performance

| Metric | 2D Budget | 3D Budget | Notes |
|--------|-----------|-----------|-------|
| Draw calls | 100-200 | 50-100 | Use fewer meshes |
| Vertices | Unlimited | 100K-500K | LOD important |
| Lights | N/A | 3-5 shadowed | Expensive |
| Transparent objects | Many | <10 | Sorting overhead |
| Particle systems | Many | 2-3 max | GPU godot-particles only |

### Optimization Checklist

```gdscript
# 1. Use LOD for distant objects
var mesh_instance := MeshInstance3D.new()
mesh_instance.lod_bias = 1.0  # Lower detail sooner

# 2. Occlusion culling
# Use OccluderInstance3D for large walls/buildings

# 3. Reduce shadow distance
var sun := DirectionalLight3D.new()
sun.directional_shadow_max_distance = 50.0  # Don't render far shadows

# 4. Use unlit materials for distant objects
var material := StandardMaterial3D.new()
material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
```

---
