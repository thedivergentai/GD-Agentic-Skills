# Architecture Overview

### 1. Wave Manager
Handles the timing and godot-composition of enemy waves.

```gdscript
# wave_manager.gd
extends Node

signal wave_started(wave_index: int)
signal wave_cleared
signal enemy_spawned(enemy: Node2D)

@export var waves: Array[Resource] # Array of WaveDefinition resources
var current_wave_index: int = 0
var active_enemies: int = 0

func start_next_wave() -> void:
    if current_wave_index >= waves.size():
        print("All waves cleared!")
        return
        
    var wave_data = waves[current_wave_index]
    wave_started.emit(current_wave_index)
    _spawn_wave(wave_data)
    current_wave_index += 1

func _spawn_wave(wave: WaveResource) -> void:
    for group in wave.groups:
        await get_tree().create_timer(group.delay).timeout
        for i in group.count:
            var enemy = group.enemy_scene.instantiate()
            add_child(enemy)
            active_enemies += 1
            enemy.tree_exiting.connect(_on_enemy_died)
            await get_tree().create_timer(group.interval).timeout

func _on_enemy_died() -> void:
    active_enemies -= 1
    if active_enemies <= 0:
        wave_cleared.emit()
```

### 2. Tower Logic (State Machine)
Towers act as autonomous agents.

*   **States**: `Idle`, `AcquireTarget`, `Attack`, `Cooldown`.
*   **Targeting Priority**: `First`, `Last`, `Strongest`, `Weakest`, `Closest`.

```gdscript
# tower.gd
extends Node2D

var targets_in_range: Array[Node2D] = []
var current_target: Node2D

func _physics_process(delta: float) -> void:
    if current_target == null or not is_instance_valid(current_target):
        _acquire_target()
    
    if current_target:
        _rotate_turret(current_target.global_position)
        if can_fire():
            fire_projectile()

func _acquire_target() -> void:
    # Example: Target closest to end of path
    var max_progress = -1.0
    for enemy in targets_in_range:
        if enemy.progress > max_progress:
            current_target = enemy
            max_progress = enemy.progress
```

### 3. Pathfinding Variants

#### A. Fixed Path (Kingdom Rush style)
Enemies follow a pre-defined `Path2D`.
*   **Implementation**: `PathFollow2D` as parent of Enemy.
*   **Pros**: Deterministic, easy to balance, optimized.
*   **Cons**: Less player agency in shaping the path.

#### B. Mazing (Fieldrunners style)
Players build towers to block/reroute enemies.
*   **Implementation**: `NavigationAgent2D` on enemies. Towers update `NavigationRegion2D` (bake on separate thread).
*   **Pros**: High strategic depth.
*   **Cons**: Computationally expensive recalculation, needs anti-blocking logic (don't let player seal the exit).
