# MOBA Meta-Systems Deep-Dive (load on demand)

> **LLM-ignorance keep rule:** content here is expert Godot/genre knowledge a general agent would not know without reading — never delete, only relocate.

> **MANDATORY** when implementing systems beyond the `scripts/` catalog. Peer skills own full tutorials — route after this reference.

---

## Architecture Overview

### 1. Lane Manager
Spawns waves of minions periodically.

```gdscript
# lane_manager.gd
extends Node

@export var lane_path: Path3D
@export var spawn_interval: float = 30.0
var timer: float = 0.0

func _process(delta: float) -> void:
    timer -= delta
    if timer <= 0:
        spawn_wave()
        timer = spawn_interval

func spawn_wave() -> void:
    # Spawn 3 Melee, 3 Ranged, 1 Cannon (every 3rd wave)
    for i in range(3):
        spawn_minion(MeleeMinion, lane_path)
        await get_tree().create_timer(1.0).timeout
```

### 2. Minion AI
Simple but follows strict rules.

```gdscript
# minion_ai.gd
extends CharacterBody3D

enum State { MARCH, COMBAT }
var current_target: Node3D

func _physics_process(delta: float) -> void:
    match state:
        State.MARCH:
            move_along_path()
            scan_for_enemies()
        State.COMBAT:
            if is_instance_valid(current_target):
                attack(current_target)
            else:
                state = State.MARCH
```

### 3. Tower Aggro Logic
The most misunderstood mechanic by new players.

```gdscript
# tower.gd
func _on_aggro_check() -> void:
    # Priority 1: Enemy Hero attacking Ally Hero
    # Priority 2: Enemy Unit attacking Ally Hero
    # Priority 3: Closest Enemy Minion
    # Priority 4: Closest Enemy Hero
    var target = determine_best_target()
    if target:
        shoot_at(target)
```

### 4. Skill-Shot Ability Cycle
Implementation pattern for "QWER" targeting:
1. **Idle**: Waiting for input.
2. **Telegraphed**: Show indicator (`skill_shot_indicator.gd`) while mouse is held.
3. **Active**: Spawn hitbox/projectile on release.
4. **Recovery**: Brief backswing animation where movement/casting is locked.

---

## Key Mechanics Implementation

### Click-to-Move (RTS Style)
Raycasting from camera to terrain.

```gdscript
func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("move"):
        var result = raycast_from_mouse()
        if result:
            nav_agent.target_position = result.position
```

### Ability System (Data Driven)
Defining "Fireball" or "Hook" without unique scripts for everything.

```gdscript
# ability_data.gd
class_name Ability extends Resource
@export var cooldown: float
@export var mana_cost: float
@export var damage: float
@export var effect_scene: PackedScene
```

---

## Godot-Specific Tips

*   **NavigationAgent3D**: Use `avoidance_enabled` for minions so they flow around each other like water, rather than stacking.
*   **MultiplayerSynchronizer**: Sync Health, Mana, and Cooldowns. Do NOT sync position every frame if using Client-Side Prediction (advanced).
*   **Fog of War**: Use a `SubViewport` with a fog texture. Paint "holes" in the texture where allies are. Project this texture onto the terrain shader.

---

## Advanced MOBA Meta-Systems

Professional implementation of match playback, network smoothing, and advanced jungle AI.

### 1. Match Replay System (Binary Serialization)
For high-performance match recording, use `var_to_bytes()` to serialize state dictionaries into a compressed binary format. Avoid JSON for replays to minimize disk I/O and file size.

```gdscript
class_name ReplayManager extends Node

var frame_history: Array[PackedByteArray] = []

func record_frame(state: Dictionary) -> void:
    # Efficiently convert data to bytes
    frame_history.append(var_to_bytes(state))

func save_replay(match_id: String) -> void:
    var file := FileAccess.open("user://replays/" + match_id + ".dat", FileAccess.WRITE)
    if file:
        file.store_var(frame_history) # Stores the whole array as a variant
        file.close()

func play_frame(frame_index: int) -> Dictionary:
    return bytes_to_var(frame_history[frame_index])
```

### 2. Networked Interpolated Sync
Use Godot 4.x's built-in physics interpolation to mask network jitter. Combined with `MultiplayerSynchronizer`, this provides smooth hero movement even at low tick rates (15-20Hz).

```gdscript
class_name HeroNetSync extends CharacterBody3D

func _ready() -> void:
    # Enable native engine interpolation for visual smoothness
    physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_ON
    
    if is_multiplayer_authority():
        setup_synchronizer()

func setup_synchronizer() -> void:
    var sync := $MultiplayerSynchronizer
    var config := SceneReplicationConfig.new()
    # Sync position/rotation via unreliable ordered packets
    config.add_property(NodePath(".:global_position"))
    sync.replication_config = config
```

### 3. Jungle-AI (Camp Leashing)
Implement a state machine for jungle monsters that monitors distance from their spawn point. If a hero draws them too far, they enter a "Leashing" state, becoming invulnerable and returning home.

```gdscript
class_name JungleCreep extends CharacterBody3D

@export var leash_radius: float = 12.0
@onready var spawn_pos := global_position

func _physics_process(_delta: float) -> void:
    var dist_from_home := global_position.distance_to(spawn_pos)
    
    match state:
        State.CHASING:
            if dist_from_home > leash_radius:
                state = State.LEASHING
        State.LEASHING:
            # Move back to spawn_pos using NavigationAgent3D
            nav_agent.target_position = spawn_pos
            if global_position.distance_to(spawn_pos) < 1.0:
                state = State.IDLE
                health = max_health # Reset health on return
```

**Expert Tip**: Always use `NavigationServer3D.map_get_iteration_id()` to ensure the navigation map is fully synced before allowing AI to pathfind after spawning.
