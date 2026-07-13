---
name: godot-genre-battle-royale
description: "Expert blueprint for Battle Royale games including shrinking zone/storm mechanics (phase-based, damage scaling), large-scale networking (relevancy, tick rate optimization), deployment systems (plane, freefall, parachute), loot spawning (weighted tables, rarity), and performance optimization (LOD, occlusion culling, object pooling). Use for multiplayer survival games or last-one-standing formats. Trigger keywords: battle_royale, zone_shrink, storm_damage, deployment_system, loot_spawn, networking_optimization, relevancy_system, snapshot_interpolation."
---

## Godot 4.7 Baseline

- Expert patterns in this skill target **Godot 4.7+** (stable, 2026-06-18).
- Consult the [Godot 4.7 migration guide](https://docs.godotengine.org/en/4.7/tutorials/migrating/upgrading_to_godot_4.7.html) when upgrading projects from 4.6.
- **NEVER** assume 4.6 defaults (stretch mode, audio area_mask, RichTextLabel percent flags) without checking 4.7 migration notes.

# Genre: Battle Royale

Expert blueprint for Battle Royale games with zone mechanics, large-scale networking, and survival gameplay.

## NEVER Do (Expert Anti-Patterns)

### Networking & Scale
- NEVER sync all 100 players every frame; strictly use a **Relevancy System** to sync high-freq data only for players within ~100m. Far players sync at ~5Hz.
- NEVER use `TRANSFER_MODE_RELIABLE` for movement data; strictly use **Unreliable** to prevent packet backup and network congestion.
- NEVER focus on client-side hit detection; strictly use **Authoritative Server Validation** where the server confirms "Did it hit?" based on state history.
- NEVER trust the client for game state; strictly validate all movement, looting, and inventory changes exclusively on the authoritative server.
- NEVER run a dedicated server with visuals; strictly use **Headless Mode** (`--headless`) or dummy drivers to save massive CPU/GPU resources.
- NEVER call RPCs before connection; strictly wait for the `connected_to_server` signal before attempting synchronization logic.

### Mechanics & Performance
- NEVER pick a fully random center for the Safe Zone; strictly target centers that ensure the new circle is **completely contained** within the current one.
- NEVER allow "Storm Tunneling"; strictly use a **Distance-to-Center** calculation rather than a simple collision perimeter to prevent skips at low tick rates.
- NEVER spawn loot without **Object Pooling**; strictly pre-instantiate and toggle visibility/collision to avoid GC spikes during dense spawns.
- NEVER ignore `VisibilityNotifier3D`; strictly disable `AnimationPlayer`, `_process()`, and heavy AI logic for players that are not visible to the observer.
- NEVER print in tight server loops; strictly avoid `print()` as console I/O is blocking and will tank server performance in high-player-count matches.
---

## Available Scripts

> **MANDATORY**: Read the appropriate script before implementing the corresponding pattern.

### Networking & Multiplayer
### [kill_feed_bus.gd](scripts/kill_feed_bus.gd)
Global elimination signal bus with match stat tracking.

### [headless_branch_logic.gd](scripts/headless_branch_logic.gd)
Expert dedicated server initialization that branches logic based on `headless` execution and server-specific feature flags.

### [enet_br_server.gd](scripts/enet_br_server.gd)
High-player-capacity ENet server setup optimized for 100+ concurrent peers over UDP.

### [state_replication_unreliable.gd](scripts/state_replication_unreliable.gd)
Pattern for synchronizing player transforms via `TRANSFER_MODE_UNRELIABLE` to minimize network congestion in large matches.

### [authoritative_looting.gd](scripts/authoritative_looting.gd)
Authoritative server-side validation logic for preventing cheat-based item collection and infinite looting.

### [targeted_rpc_relay.gd](scripts/targeted_rpc_relay.gd)
Optimized communication pattern using `rpc_id()` to target specific peers and reduce wasted packet broadcasts.

### [server_state_buffer.gd](scripts/server_state_buffer.gd)
Handling network jitter and out-of-order UDP packets via sequential state buffering and tick-based sorting.

### Performance & Optimization
### [rid_loot_spawner.gd](scripts/rid_loot_spawner.gd)
Bypassing the node hierarchy for massive loot density. Uses `RenderingServer` directly to eliminate CPU overhead for item drops.

### [async_map_loader.gd](scripts/async_map_loader.gd)
Non-blocking map sector streaming using `ResourceLoader` background threads for seamless open-world exploration.

### [multimesh_vegetation.gd](scripts/multimesh_vegetation.gd)
Drawing dense foliage and environment assets (100k+ instances) via `MultiMeshInstance3D` to maximize rendering performance.

### [threaded_ai_manager.gd](scripts/threaded_ai_manager.gd)
Offloading server-side bot behavior and pathfinding logic to the `WorkerThreadPool` to prevent main-thread stalling.

## NEVER Do in Battle Royale

- **NEVER export mobile clients without the INTERNET permission** — Communication will silently fail on Android/iOS if the manifest is missing the networking permission [37].
- **NEVER use `get_var(true)` on untrusted data** — Deserializing arbitrary objects allows attackers to execute remote code on the server or other clients [31].
- **NEVER synchronize `Object` or `Resource` types over network** — Use the `MultiplayerSynchronizer` strictly for base types (int, float, vec) [39].
- **NEVER assume `UNRELIABLE` packets arrive in order** — Design state interpolation carefully to handle missing or out-of-order ticks [28].
- **NEVER leave `multiplayer_poll` false without manual calling** — If using custom threads, failing to call `multiplayer.poll()` freezes all traffic [40].

---

## Core Loop
1.  **Deploy**: Player chooses a landing spot from an air vehicle.
2.  **Loot**: Player scavenges weapons and armor.
3.  **Move**: Player runs to the safe zone to avoid taking damage.
4.  **Engage**: Player fights others they encounter.
5.  **Survive**: Player attempts to be the last one standing.

## Skill Chain

| Phase | Skills | Purpose |
|-------|--------|---------|
| 1. Net | `godot-multiplayer-networking` | Authoritative server, lag compensation |
| 2. Map | `godot-3d-world-building`, `level-of-detail` | Large terrain, chunking, distant trees |
| 3. Items | `godot-inventory-system` | Managing backpack, attachments, armor |
| 4. Combat | `shooter-mechanics`, `ballistics` | Projectile physics, damage calculation |
| 5. Logic | `game-manager` | Managing the Storm/Zone state |

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

## Common Pitfalls

1.  **Too Main Loot**: Too much loot causes lag. **Fix**: Use object pooling for loot pickups.
2.  **Camping**: Players hide forever. **Fix**: The Zone forces movement. Also, anti-camping mechanics like "scan reveals" (optional).
3.  **Cheating**: Client-side hit detection. **Fix**: Authoritative server logic. Client says "I shot at direction X", Server calculates "Did it hit?".


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


## Reference
- Master Skill: [godot-master](../godot-master/SKILL.md)
