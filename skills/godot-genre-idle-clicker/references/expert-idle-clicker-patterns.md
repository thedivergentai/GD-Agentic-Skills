# Expert patterns (load on demand)

> **MANDATORY** when implementing beyond Golden Path / Decision Trees. Do not paste into SKILL.md or scenes from memory.

## Architecture Overview

### 1. Big Number System
Standard `float` goes to `INF` around 1.8e308. Idle games often go beyond.
You need a custom `BigNumber` class (Mantissa + Exponent).

```gdscript
# big_number.gd
class_name BigNumber

var mantissa: float = 0.0 # 1.0 to 10.0
var exponent: int = 0     # Power of 10

func _init(m: float, e: int) -> void:
    mantissa = m
    exponent = e
    normalize()

func normalize() -> void:
    if mantissa >= 10.0:
        mantissa /= 10.0
        exponent += 1
    elif mantissa < 1.0 and mantissa != 0.0:
        mantissa *= 10.0
        exponent -= 1
```

### 2. Generator System
The core entities that produce currency.

```gdscript
# generator.gd
class_name Generator extends Resource

@export var id: String
@export var base_cost: BigNumber
@export var base_revenue: BigNumber
@export var cost_growth_factor: float = 1.15

var count: int = 0

func get_cost() -> BigNumber:
    # Cost = Base * (Growth ^ Count)
    return base_cost.multiply(pow(cost_growth_factor, count))
```

### 3. Simulation Manager (Offline Progress)
Calculating gains while the game was closed.

```gdscript
# game_manager.gd
func _ready() -> void:
    var last_save_time = save_data.timestamp
    var current_time = Time.get_unix_time_from_system()
    var seconds_offline = current_time - last_save_time
    
    if seconds_offline > 60:
        var revenue = calculate_revenue_per_second().multiply(seconds_offline)
        add_currency(revenue)
        show_welcome_back_popup(revenue)
```

## Key Mechanics Implementation

### Prestige System (Reset)
Resetting `generators` but keeping `prestige_currency`.

```gdscript
func prestige() -> void:
    if current_money.less_than(prestige_threshold):
        return
        
    # Formula: Cube root of money / 1 million
    # (Just an example, depends on balance)
    var gained_keys = calculate_prestige_gain()
    
    save_data.prestige_currency += gained_keys
    save_data.global_multiplier = 1.0 + (save_data.prestige_currency * 0.10)
    
    # Reset
    save_data.money = BigNumber.new(0, 0)
    save_data.generators = ResetGenerators()
    save_game()
    reload_scene()
```

### Formatting Numbers
Displaying `1234567` as `1.23M`.

```gdscript
static func format(bn: BigNumber) -> String:
    if bn.exponent < 3:
        return str(int(bn.mantissa * pow(10, bn.exponent)))
    
    var suffixes = ["", "K", "M", "B", "T", "Qa", "Qi"]
    var suffix_idx = bn.exponent / 3
    
    if suffix_idx < suffixes.size():
        return "%.2f%s" % [bn.mantissa * pow(10, bn.exponent % 3), suffixes[suffix_idx]]
    else:
        return "%.2fe%d" % [bn.mantissa, bn.exponent]
```

## Godot-Specific Tips

*   **Timers**: Do NOT use `Timer` nodes for revenue generation (drifting). Use `_process(delta)` and accumulate time.
*   **GridContainer**: Perfect for the "Generators" list.
*   **Resources**: Use `.tres` files to define every generator (Farm, Mine, Factory) so you can tweak balance without touching code.

## 🚀 Elite Technical Implementations (Batch 09)

### 1. BigReal-Math-Structure (Handling > 1e308)
Idle games often exceed the limits of 64-bit floats (~1.8e308). Use a custom `RefCounted` class to store numbers in scientific notation (mantissa + exponent), allowing for virtually infinite growth.

```gdscript
class_name BigReal extends RefCounted

@export var mantissa: float = 0.0
@export var exponent: int = 0

func _init(m: float = 0.0, e: int = 0) -> void:
    mantissa = m
    exponent = e
    _normalize()

func _normalize() -> void:
    if mantissa == 0.0:
        exponent = 0
        return
    while abs(mantissa) >= 10.0:
        mantissa /= 10.0
        exponent += 1
    while abs(mantissa) < 1.0 and mantissa != 0.0:
        mantissa *= 10.0
        exponent -= 1

func multiply(other: BigReal) -> BigReal:
    return BigReal.new(mantissa * other.mantissa, exponent + other.exponent)
```

### 2. Multi-Offline-Progression Pattern
Calculate retroactively what the player earned while the game was closed using `Time.get_unix_time_from_system()`. Save the timestamp to `user://` and compare it upon relaunch.

```gdscript
class_name OfflineProgressionManager extends Node

signal offline_earnings_calculated(seconds_offline: float)
const SAVE_PATH: String = "user://offline_save.json"

func _ready() -> void:
    _process_offline_time()

func _process_offline_time() -> void:
    var current_time = Time.get_unix_time_from_system()
    var last_time = load_timestamp() # From FileAccess
    var delta = current_time - last_time
    
    if delta > 60.0:
        offline_earnings_calculated.emit(delta)

func save_timestamp() -> void:
    var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
    file.store_string(JSON.stringify({"last_time": Time.get_unix_time_from_system()}))
```

### 3. Particle-Batch-Juice (Manual Emission)
Spawning new nodes for click-juice is expensive. Use a single `GPUParticles2D` and call `emit_particle()` manually on every click to batch spawn particles directly at the mouse coordinates.

```gdscript
class_name ClickJuiceManager extends Node2D

@export var click_particles: GPUParticles2D

func _input(event: InputEvent) -> void:
    if event.is_action_pressed(&"click"):
        var click_pos = get_global_mouse_position()
        _burst_particles(click_pos)

func _burst_particles(pos: Vector2) -> void:
    for i in range(15):
        var xform = Transform2D(0.0, pos)
        var velocity = Vector2(randf_range(-200.0, 200.0), randf_range(-200.0, 200.0))
        # Direct GPU emission bypasses SceneTree overhead
        click_particles.emit_particle(xform, velocity, Color.WHITE, Color.WHITE, 0)
```
