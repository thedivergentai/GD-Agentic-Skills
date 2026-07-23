# Racing Systems Deep-Dive (load on demand)

> **LLM-ignorance keep rule:** content here is expert Godot/genre knowledge a general agent would not know without reading — never delete, only relocate.

> **MANDATORY** when implementing systems beyond the `scripts/` catalog. Peer skills own full tutorials — route after this reference.

---

## Architecture Overview

### 1. Vehicle Controller
Handling the physics of movement.

```gdscript
# car_controller.gd
extends VehicleBody3D

@export var max_torque: float = 300.0
@export var max_steering: float = 0.4

func _physics_process(delta: float) -> void:
    steering = lerp(steering, Input.get_axis("right", "left") * max_steering, 5 * delta)
    engine_force = Input.get_axis("back", "forward") * max_torque
```

### 2. Checkpoint System
Essential for tracking progress and preventing cheating.

```gdscript
# checkpoint_manager.gd
extends Node

var checkpoints: Array[Area3D] = []
var current_checkpoint_index: int = 0
signal lap_completed

func _on_checkpoint_entered(body: Node3D, index: int) -> void:
    if index == current_checkpoint_index + 1:
        current_checkpoint_index = index
    elif index == 0 and current_checkpoint_index == checkpoints.size() - 1:
        complete_lap()
```

### 3. Race Manager
high-level state machine.

```gdscript
# race_manager.gd
enum State { COUNTDOWN, RACING, FINISHED }
var current_state: State = State.COUNTDOWN

func start_race() -> void:
    # 3.. 2.. 1.. GO!
    await countdown()
    current_state = State.RACING
    start_timer()
```

---

## Key Mechanics Implementation

### Drifting
Arcade drifting usually involves faking physics. Reduce friction or apply a sideways force.

```gdscript
func apply_drift_mechanic() -> void:
    if is_drifting:
        # Reduce sideways traction
        wheel_friction_slip = 1.0 
        # Add slight forward boost on exit
    else:
        wheel_friction_slip = 3.0 # High grip
```

### Rubber Banding AI
Keep the race competitive by adjusting AI speed based on player distance.

```gdscript
func update_ai_speed(ai_car: VehicleBody3D, player: VehicleBody3D) -> void:
    var dist = ai_car.global_position.distance_to(player.global_position)
    if ai_car_is_ahead_of_player(ai_car, player):
        ai_car.max_speed = base_speed * 0.9 # Slow down
    else:
        ai_car.max_speed = base_speed * 1.1 # Speed up
```

---

## Godot-Specific Tips

*   **VehicleBody3D**: Godot's built-in node for vehicle physics. It's decent for arcade, but for sims, you might want a custom RayCast suspension.
*   **Path3D / PathFollow3D**: Excellent for simple AI traffic or fixed-path racers (on-rails).
*   **AudioBus**: Use the `Doppler` effect on the AudioListener for realistic passing sounds.
*   **SubViewport**: Use for the rear-view mirror or minimap texture.

---

## Advanced Racing Meta-Systems

Elite implementation of competitive integrity, aerodynamics, and auditory realism.

### 1. Drift-Boost (Mini-Turbo)
Implement a drift-boost mechanic by accumulating a charge variable during the `_physics_process()` callback while the player is in a drift state. Upon release, apply a burst of speed using `apply_central_impulse()` on the `RigidBody3D` (or `VehicleBody3D`), creating the classic arcade "Mini-Turbo" effect.

```gdscript
class_name DriftBoostSystem extends Node

var drift_charge: float = 0.0
const BOOST_MULTIPLIER = 1000.0

func _physics_process(delta: float) -> void:
    if owner.is_drifting:
        drift_charge += delta
    elif drift_charge > 0:
        execute_boost()

func execute_boost() -> void:
    var boost_force := owner.global_transform.basis.z * (drift_charge * BOOST_MULTIPLIER)
    owner.apply_central_impulse(boost_force)
    drift_charge = 0.0
```

### 2. Tire-Smoke Particles
Attach a `GPUParticles3D` node to each wheel and toggle the `emitting` property based on the wheel's traction state. This provides immediate visual feedback for drifting, burnouts, and high-speed braking.

```gdscript
class_name TireSmokeManager extends Node3D

@export var smoke_particles: GPUParticles3D
@export var wheel: VehicleWheel3D

func _process(_delta: float) -> void:
    # Emit smoke if the wheel is slipping significantly
    smoke_particles.emitting = wheel.get_skidinfo() < 0.5
```

### 3. Replay-Ghost Binary Storage
For high-performance ghost car replays, convert positional and rotational data into a `PackedVector2Array` or use Godot's binary `.res` format via `ResourceSaver`. This is significantly faster and more compact than text-based formats for storing frame-by-frame data.

```gdscript
class_name GhostRecorder extends Node

var frame_data: PackedVector3Array = []

func record_frame(pos: Vector3) -> void:
    frame_data.append(pos)

func save_ghost_binary(path: String) -> void:
    var file := FileAccess.open(path, FileAccess.WRITE)
    if file:
        file.store_var(frame_data) # Binary Variant serialization
        file.close()
```

**Architectural Tip**: When implementing Drift-Boost, use a `Tween` to briefly increase the Camera FOV during the boost to enhance the sense of sudden acceleration.
