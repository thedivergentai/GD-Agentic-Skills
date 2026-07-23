# Expert patterns (load on demand)

> **MANDATORY** when implementing beyond Golden Path / Decision Trees. Do not paste into SKILL.md or scenes from memory.

## Architecture Overview

### 1. The Zone Manager (The Storm)
Manages the shrinking safe area.

```gdscript
# zone_manager.gd
extends Node

@export var phases: Array[ZonePhase]
var current_phase_index: int = 0
var current_radius: float = 2000.0
var target_radius: float = 2000.0
var center: Vector2 = Vector2.ZERO
var target_center: Vector2 = Vector2.ZERO
var shrink_speed: float = 0.0

func start_next_phase() -> void:
    var phase = phases[current_phase_index]
    target_radius = phase.end_radius
    # Pick new center WITHIN current circle but respecting new radius
    var random_angle = randf() * TAU
    var max_offset = current_radius - target_radius
    var offset = Vector2.RIGHT.rotated(random_angle) * (randf() * max_offset)
    target_center = center + offset
    
    shrink_speed = (current_radius - target_radius) / phase.shrink_time

func _process(delta: float) -> void:
    if current_radius > target_radius:
        current_radius -= shrink_speed * delta
        center = center.move_toward(target_center, (shrink_speed * delta) * (center.distance_to(target_center) / (current_radius - target_radius)))
```

### 2. Loot Spawner
Efficiently populating the world.

```gdscript
# loot_manager.gd
func spawn_loot() -> void:
    for spawn_point in get_tree().get_nodes_in_group("loot_spawns"):
        if randf() < spawn_point.spawn_chance:
            var item_id = loot_table.roll_item()
            var loot_instance = loot_scene.instantiate()
            loot_instance.setup(item_id)
            add_child(loot_instance)
```

### 3. Deployment System
Transitioning from plane to ground.

```gdscript
# player_controller.gd
enum State { IN_PLANE, FREEFALL, PARACHUTE, GROUNDED }

func _physics_process(delta: float) -> void:
    match current_state:
        State.FREEFALL:
            velocity.y = move_toward(velocity.y, -50.0, gravity * delta)
            move_and_slide()
            if position.y < auto_deploy_height:
                deploy_parachute()
```

## Key Mechanics Implementation

### Zone Damage
Checking if player is outside the circle.

```gdscript
func check_zone_damage() -> void:
    var dist = Vector2(global_position.x, global_position.z).distance_to(ZoneManager.center)
    if dist > ZoneManager.current_radius:
        take_damage(ZoneManager.dps * delta)
```

### Networking Optimization
You cannot sync 100 players every frame.
*   **Relevancy**: Only send updates for players within visual range.
*   **Frequency**: Update far-away players at 4Hz, nearby at 20Hz+ (Server Tick).
*   **Snapshot Interpolation**: Client buffers headers to play them back smoothly.

## Godot-Specific Tips

*   **MultiplayerSynchronizer**: Use `replication_interval` to lower bandwidth for distant objects.
*   **VisibilityNotifier3D**: Critical. Disable `_process` and AnimationPlayer for players behind you or far away.
*   **Occlusion Culling**: Essential for large maps with buildings. Bake occlusion data.
*   **HLOD**: Use Hierarchical Level of Detail for terrain and large structures.

## Advanced Battle Royale Systems

Elite patterns for handling massive scale, low-latency networking, and high-performance visuals.

### 1. Lag Compensation (Hit Validation Backtracking)
The server maintains a history of entity transforms. When a client reports a hit with a timestamp, the server "rewinds" the target to that moment for authoritative validation.

```gdscript
class_name LagCompensator extends Node

var _position_history: Dictionary = {} # Timestamp -> Transform3D
const MAX_HISTORY_MS: int = 1000 # Keep 1 second of history

func _physics_process(_delta: float) -> void:
    if multiplayer.is_server():
        var current_time := Time.get_ticks_msec()
        _position_history[current_time] = owner.global_transform
        
        # Cleanup old entries
        for t in _position_history.keys():
            if t < current_time - MAX_HISTORY_MS:
                _position_history.erase(t)

@rpc("any_peer", "call_remote", "reliable")
func server_validate_hit(client_hit_pos: Vector3, client_timestamp: int) -> void:
    if not multiplayer.is_server(): return
    
    # 1. Backtrack to find the transform at the time the client saw it
    var historical_transform := _get_closest_transform(client_timestamp)
    
    # 2. Validate hit against historical state
    var distance := historical_transform.origin.distance_to(client_hit_pos)
    if distance < 2.0: # Tolerance
        apply_damage_authoritative()

func _get_closest_transform(timestamp: int) -> Transform3D:
    # Logic to find exact or interpolated historical transform
    return _position_history.get(timestamp, owner.global_transform)
```

### 2. Delta-Patching (MultiplayerSynchronizer Optimization)
Godot 4.x natively supports delta-patching via `MultiplayerSynchronizer`. Set replication to `ON_CHANGE` to strictly transmit modified data.

```gdscript
class_name MonsterSynchronizer extends Node

func setup_replication(monster: CharacterBody3D) -> void:
    var sync := MultiplayerSynchronizer.new()
    add_child(sync)
    
    var config := SceneReplicationConfig.new()
    
    # Position: High frequency sync
    var pos_path := NodePath(str(monster.get_path()) + ":position")
    config.add_property(pos_path)
    config.property_set_replication_mode(pos_path, SceneReplicationConfig.REPLICATION_MODE_ALWAYS)
    
    # Health: Delta-patch (only sync when changed)
    var health_path := NodePath(str(monster.get_path()) + ":current_health")
    config.add_property(health_path)
    config.property_set_replication_mode(health_path, SceneReplicationConfig.REPLICATION_MODE_ON_CHANGE)
    
    sync.replication_config = config
    sync.delta_interval = 0.05 # Limit sync to 20Hz for bandwidth efficiency
```

### 3. Zone Visualizer (Storm Perimeter Shader)
Use a custom spatial shader with `unshaded` and `cull_disabled` render modes for high-performance, massive-scale zone effects.

*zone_shield.gdshader*
```glsl
shader_type spatial;
render_mode unshaded, cull_disabled;

uniform vec4 storm_color : source_color = vec4(0.6, 0.1, 1.0, 1.0);
uniform float storm_opacity : hint_range(0.0, 1.0) = 0.5;

void fragment() {
    ALBEDO = storm_color.rgb;
    ALPHA = storm_opacity;
    EMISSION = storm_color.rgb * 2.0; # Glow visibility at distance
}
```

**Expert Tip**: For the "Zone Wall", use an inverted `SphereMesh` with its scale controlled by the `ZoneManager`. This ensures the player is always "inside" the mesh, rendering the back-faces (cull_disabled) correctly.
