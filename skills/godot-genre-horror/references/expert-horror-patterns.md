# Expert patterns (load on demand)

> **MANDATORY** when implementing beyond Golden Path / Decision Trees. Do not paste into SKILL.md or scenes from memory.

## Architecture Overview

### 1. The Director System (Macro AI)
Controls the pacing of the game to prevent constant exhaustion.

```gdscript
# director.gd
extends Node

enum TensionState { BUILDUP, PEAK, RELIEF, QUIET }
var current_tension: float = 0.0
var player_stress_level: float = 0.0

func _process(delta: float) -> void:
    match current_tension_state:
        TensionState.BUILDUP:
            current_tension += 0.5 * delta
            if current_tension > 75.0:
                 trigger_event()
        TensionState.RELIEF:
            current_tension -= 2.0 * delta

func trigger_event() -> void:
    # Hints the Monster AI to check a room NEAR the player, not ON the player
    monster_ai.investigate_area(player.global_position + Vector3(randf(), 0, randf()) * 10)
```

### 2. Sensory Perception (Micro AI)
The monster's actual senses.

```gdscript
# sensory_component.gd
extends Area3D

signal sound_heard(position: Vector3, volume: float)
signal player_spotted(position: Vector3)

func check_vision(target: Node3D) -> bool:
    var space_state = get_world_3d().direct_space_state
    var query = PhysicsRayQueryParameters3D.create(global_position, target.global_position)
    var result = space_state.intersect_ray(query)
    
    if result and result.collider == target:
        return true
    return false
```

### 3. Sanity / Stress System
Distorting the world based on fear.

```gdscript
# sanity_manager.gd
func update_sanity(amount: float) -> void:
    current_sanity = clamp(current_sanity + amount, 0.0, 100.0)
    # Effect: Camera Shake
    camera_shake_intensity = (100.0 - current_sanity) * 0.01
    # Effect: Audio Distortion
    audio_bus.get_effect(0).drive = (100.0 - current_sanity) * 0.05
```

## Key Mechanics Implementation

### Pacing (The Sawtooth Wave)
Horror needs peaks and valleys.
1.  **Safety**: Save room.
2.  **Unease**: Strange noise, lights flicker.
3.  **Dread**: Monster is known to be close.
4.  **Terror**: Chase sequence / Combat.
5.  **Relief**: Escape to Safety.

### The "Dual Brain" AI
*   **Director (All-knowing)**: Cheats to keep the alien relevant (teleports it closer if far away, guides it to player's general area).
*   **Alien (Senses only)**: Honest AI. Must actually see/hear the player to attack.

### 3. Hiding-Spot Metadata System
Use decoupled Object metadata so AI can query state without knowing the class.

```gdscript
# hiding_spot.gd
func _ready():
    add_to_group("hiding_spots")
    set_meta("is_occupied", false)

# predator_ai.gd
func search_hiding_spots():
    for spot in get_tree().get_nodes_in_group("hiding_spots"):
        if spot.get_meta("is_occupied"):
            investigate(spot.global_position)
```

### 4. Adaptive Audio (Stress Muffling)
Dynamic low-pass filtering via `AudioServer`.

```gdscript
# audio_stress_manager.gd
func update_stress(fear_level: float):
    # Enable LPF effect on Master bus (index 0) if fear is high
    AudioServer.set_bus_effect_enabled(0, 0, fear_level > 0.5)
    # Attenuate volume linearly
    AudioServer.set_bus_volume_linear(0, 1.0 - (fear_level * 0.4))
```

### 5. Safe-Room Multithreaded Save
Use `Thread` and `Mutex` to prevent frame drops during checkpoint saves.

```gdscript
# safe_room.gd
var _save_thread: Thread = Thread.new()
var _mutex: Mutex = Mutex.new()

func trigger_save(data: Dictionary):
    _mutex.lock()
    if not _save_thread.is_alive():
        _save_thread.start(_do_save.bind(data.duplicate(true)))
    _mutex.unlock()

func _do_save(data):
    var file = FileAccess.open("user://save.dat", FileAccess.WRITE)
    file.store_var(data)
    file.close()
```

## Godot-Specific Tips

*   **Volumetric Fog**: Use `WorldEnvironment` -> `VolumetricFog` for instant atmosphere. Animate `density` for dynamic dread.
*   **Light Occluder 2D**: For 2D horror, shadow casting is essential.
*   **AudioBus**: Use `Reverb` and `LowPassFilter` on the Master bus, controlled by scripts, to simulate "muffled" hearing when scared or hiding.
*   **AnimationTree**: Use blend spaces to smooth transitions between "Sneak", "Walk", and "Run" animations.

## Common Pitfalls

1.  **Constant Tension**: Player gets numb. **Fix**: Enforce "Relief" periods where nothing happens.
2.  **Frustrating AI**: AI sees player instantly. **Fix**: Give AI a "reaction time" or "suspicion meter" before full aggro.
3.  **Too Dark**: Player can't see anything. **Fix**: Darkness should obscure *details*, not *navigation*. Use rim lighting or a weak flashlight.
