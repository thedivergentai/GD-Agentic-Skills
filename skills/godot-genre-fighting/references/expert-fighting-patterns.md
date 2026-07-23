# Expert patterns (load on demand)

> **MANDATORY** when implementing beyond Golden Path / Decision Trees. Do not paste into SKILL.md or scenes from memory.

## Frame-Based Combat System

Fighting games operate on **frame data** - discrete time units (typically 60fps).

### Frame Data Fundamentals

```gdscript
class_name Attack
extends Resource

@export var name: String
@export var startup_frames: int  # Frames before hitbox becomes active
@export var active_frames: int   # Frames hitbox is active
@export var recovery_frames: int # Frames after hitbox deactivates
@export var on_hit_advantage: int # Frame advantage when attack hits
@export var on_block_advantage: int # Frame advantage when blocked
@export var damage: int
@export var hitstun: int  # Frames opponent is stunned
@export var blockstun: int # Frames opponent is in blockstun

func get_total_frames() -> int:
    return startup_frames + active_frames + recovery_frames

func is_safe_on_block() -> bool:
    return on_block_advantage >= 0
```

### Frame-Accurate Processing

```gdscript
extends Node

var frame_count: int = 0
const FRAME_DURATION := 1.0 / 60.0
var accumulator: float = 0.0

func _process(delta: float) -> void:
    accumulator += delta
    while accumulator >= FRAME_DURATION:
        process_game_frame()
        frame_count += 1
        accumulator -= FRAME_DURATION

func process_game_frame() -> void:
    # All game logic runs here at fixed 60fps
    for fighter in fighters:
        fighter.process_frame()
```

---

## Input System

### Input Buffering

Store inputs and execute when valid:

```gdscript
class_name InputBuffer
extends Node

const BUFFER_FRAMES := 8  # Industry standard: 5-10 frames
var buffer: Array[InputEvent] = []

func add_input(input: InputEvent) -> void:
    buffer.append(input)
    if buffer.size() > BUFFER_FRAMES:
        buffer.pop_front()

func consume_input(action: StringName) -> bool:
    for i in range(buffer.size() - 1, -1, -1):
        if buffer[i].is_action(action):
            buffer.remove_at(i)
            return true
    return false
```

### Motion Input Detection (Quarter Circle, DP, etc.)

```gdscript
class_name MotionDetector
extends Node

const QCF := ["down", "down_forward", "forward"]  # Quarter Circle Forward
const DP := ["forward", "down", "down_forward"]   # Dragon Punch
const MOTION_WINDOW := 15  # Frames to complete motion

var direction_history: Array[String] = []

func add_direction(dir: String) -> void:
    if direction_history.is_empty() or direction_history[-1] != dir:
        direction_history.append(dir)
    # Keep last N directions
    if direction_history.size() > 20:
        direction_history.pop_front()

func check_motion(motion: Array[String]) -> bool:
    if direction_history.size() < motion.size():
        return false
    # Check if motion appears in recent history
    var recent := direction_history.slice(-MOTION_WINDOW)
    return _contains_sequence(recent, motion)

func _contains_sequence(haystack: Array, needle: Array) -> bool:
    var idx := 0
    for dir in haystack:
        if dir == needle[idx]:
            idx += 1
            if idx >= needle.size():
                return true
    return false
```

---

## Hitbox/Hurtbox System

```gdscript
class_name HitboxComponent
extends Area2D

enum BoxType { HITBOX, HURTBOX, THROW, PROJECTILE }

@export var box_type: BoxType
@export var attack_data: Attack
@export var owner_fighter: Fighter

signal hit_confirmed(target: Fighter, attack: Attack)

func _ready() -> void:
    monitoring = (box_type == BoxType.HITBOX or box_type == BoxType.THROW)
    monitorable = (box_type == BoxType.HURTBOX)
    connect("area_entered", _on_area_entered)

func _on_area_entered(area: Area2D) -> void:
    if area is HitboxComponent:
        var other := area as HitboxComponent
        if other.box_type == BoxType.HURTBOX and other.owner_fighter != owner_fighter:
            hit_confirmed.emit(other.owner_fighter, attack_data)
```

---

## Combo System

### Hit Confirmation and Combo Counter

```gdscript
class_name ComboTracker
extends Node

var combo_count: int = 0
var combo_damage: int = 0
var in_combo: bool = false
var damage_scaling: float = 1.0

const SCALING_PER_HIT := 0.9  # 10% reduction per hit

func start_combo() -> void:
    in_combo = true
    combo_count = 0
    combo_damage = 0
    damage_scaling = 1.0

func add_hit(base_damage: int) -> int:
    combo_count += 1
    var scaled_damage := int(base_damage * damage_scaling)
    combo_damage += scaled_damage
    damage_scaling *= SCALING_PER_HIT
    return scaled_damage

func drop_combo() -> void:
    in_combo = false
    combo_count = 0
    damage_scaling = 1.0
```

### Cancel System

```gdscript
enum CancelType { NONE, NORMAL, SPECIAL, SUPER }

func can_cancel_into(from_attack: Attack, to_attack: Attack) -> bool:
    # Normal → Special → Super hierarchy
    match to_attack.cancel_type:
        CancelType.NORMAL:
            return from_attack.cancel_type == CancelType.NONE
        CancelType.SPECIAL:
            return from_attack.cancel_type in [CancelType.NONE, CancelType.NORMAL]
        CancelType.SUPER:
            return true  # Supers can cancel anything
    return false
```

---

## Character States

```gdscript
enum FighterState {
    IDLE, WALKING, CROUCHING, JUMPING,
    ATTACKING, BLOCKING, HITSTUN, BLOCKSTUN,
    KNOCKDOWN, WAKEUP, THROW, THROWN
}

class_name FighterStateMachine
extends Node

var current_state: FighterState = FighterState.IDLE
var state_frame: int = 0

func transition_to(new_state: FighterState) -> void:
    exit_state(current_state)
    current_state = new_state
    state_frame = 0
    enter_state(new_state)

func is_actionable() -> bool:
    return current_state in [
        FighterState.IDLE,
        FighterState.WALKING,
        FighterState.CROUCHING
    ]
```

---

## Netcode Considerations

### Rollback Essentials

```gdscript
class_name GameState
extends Resource

# Serialize complete game state for rollback
func save_state() -> Dictionary:
    return {
        "frame": frame_count,
        "fighters": fighters.map(func(f): return f.serialize()),
        "projectiles": projectiles.map(func(p): return p.serialize())
    }

func load_state(state: Dictionary) -> void:
    frame_count = state["frame"]
    for i in fighters.size():
        fighters[i].deserialize(state["fighters"][i])
    # Reconstruct projectiles...
```

---

## Godot-Specific Tips

1. **Use `_physics_process` sparingly** - implement your own frame-based loop
2. **AnimationPlayer**: Tie hitbox activation to animation frames
3. **Custom collision**: May need custom hitbox system rather than physics engine
4. **Save/Load for rollback**: Keep state serializable


## Advanced Fighting Game Meta-Systems

Professional implementation of move-set management, editor-side debugging, and roster balance.

### 1. Command-List JSON Schema (Move-set Definitions)
Decouple move-sets from character logic by using an external JSON schema. This allows designers to iterate on frame data and inputs without modifying GDScript.

```gdscript
class_name MoveSetLoader extends Node

var move_data: Dictionary = {}

func load_from_json(path: String) -> void:
    var file := FileAccess.open(path, FileAccess.READ)
    if file:
        var json_string := file.get_as_text()
        var result = JSON.parse_string(json_string)
        if result is Dictionary:
            move_data = result
        file.close()

# Example JSON Schema structure:
# {
#   "hadouken": {
#     "input": ["down", "down_forward", "forward", "punch"],
#     "startup": 12,
#     "active": 3,
#     "recovery": 25,
#     "damage": 800
#   }
# }
```

### 2. Visual Frame Advancer (Editor Debugger)
Use `@tool` scripts to create editor-side debugging tools that allow scrubbing through animation frames to verify hitbox alignment.

```gdscript
@tool
class_name FrameAdvancer extends Node

@export var current_frame: int = 0:
    set(value):
        current_frame = value
        if Engine.is_editor_hint():
            _sync_animation_to_frame()

@export var step_forward: bool = false:
    set(value):
        if value:
            current_frame += 1
            step_forward = false # Reset toggle

func _sync_animation_to_frame() -> void:
    var anim_player: AnimationPlayer = get_node_or_null("../AnimationPlayer")
    if anim_player:
        anim_player.seek(current_frame * (1.0/60.0), true)
        # Force a redraw of debug shapes
        get_parent().queue_redraw()
```

### 3. Character-Specific Scaling (Balance Resources)
Encapsulate roster balance variables in `Resource` files. This allows for profile-based scaling (e.g., HeavyWeight vs. GlassCannon) that can be swapped instantly.

```gdscript
class_name FighterBalanceProfile extends Resource

@export_group("Damage Scaling")
@export var base_damage_mult: float = 1.0
@export var combo_proration_rate: float = 0.9 # Lower means faster damage drop-off

@export_group("Movement Scaling")
@export var walk_speed_mult: float = 1.0
@export var dash_distance_mult: float = 1.0

@export_group("Defense Scaling")
@export var max_health: int = 10000
@export var guts_threshold: float = 0.3 # Damage reduction kicks in at 30% HP

# Usage in Fighter script:
# @export var balance_profile: FighterBalanceProfile
# func take_damage(amount: int) -> void:
#     health -= int(amount * balance_profile.damage_reduction_curve)
```

**Anti-Pattern**: NEVER hardcode balance numbers in the Fighter base class. Strictly use delegated `Resource` profiles to maintain a clean, maintainable roster.
