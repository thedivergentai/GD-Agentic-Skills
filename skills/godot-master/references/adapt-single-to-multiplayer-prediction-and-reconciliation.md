# Prediction And Reconciliation

## Client Prediction & Server Reconciliation

### Problem: Lag Makes Game Feel Unresponsive

```gdscript
# Without prediction:
# 1. Client presses W
# 2. Input sent to server
# 3. Server processes (50ms later)
# 4. Server sends back position
# 5. Client sees movement (100ms RTT)
# Result: 100ms delay between input and visual feedback
```

### Solution: Client-Side Prediction

```gdscript
# player_controller.gd
extends CharacterBody2D

var input_buffer: Array = []
var server_state := {"position": Vector2.ZERO, "tick": 0}

func _physics_process(delta: float) -> void:
    if is_multiplayer_authority():
        var input := Input.get_vector("left", "right", "up", "down")
        
        # Client predicts movement IMMEDIATELY
        var tick := Engine.get_physics_frames()
        input_buffer.append({"input": input, "tick": tick})
        process_movement(input)
        
        # Send input to server
        if multiplayer.get_unique_id() != 1:
            rpc_id(1, "server_receive_input", input, tick)
    
    else:
        # Other players: just display synced position (no prediction)
        pass

@rpc("any_peer", "call_remote", "unreliable")
func server_receive_input(input: Vector2, client_tick: int) -> void:
    # Server processes input
    process_movement(input)
    
    # Send authoritative state back
    rpc_id(multiplayer.get_remote_sender_id(), "client_receive_state", position, client_tick)

@rpc("authority", "call_remote", "unreliable")
func client_receive_state(server_pos: Vector2, server_tick: int) -> void:
    # Reconciliation: check if prediction was correct
    var error := position.distance_to(server_pos)
    
    if error > 5.0:  # Threshold for correction
        # Snap to server position
        position = server_pos
        
        # Replay inputs that happened after server_tick
        for buffered_input in input_buffer:
            if buffered_input.tick > server_tick:
                process_movement(buffered_input.input)
    
    # Clean old inputs
    input_buffer = input_buffer.filter(func(i): return i.tick > server_tick)

func process_movement(input: Vector2) -> void:
    velocity = input.normalized() * SPEED
    move_and_slide()
```

---

## Lag Compensation Techniques

### Interpolation (Other Player Smoothing)

```gdscript
# Other players appear choppy due to packet loss/jitter
# Solution: Interpolate between received states

extends CharacterBody2D

var position_buffer: Array = []
const BUFFER_SIZE = 3  # Store last 3 positions

func _ready() -> void:
    if not is_multiplayer_authority():
        # Disable local physics, use interpolation
        set_physics_process(false)

func _process(delta: float) -> void:
    if not is_multiplayer_authority() and position_buffer.size() >= 2:
        # Interpolate between buffered positions
        var from := position_buffer[0]
        var to := position_buffer[1]
        var t := 0.2  # Interpolation speed
        
        position = position.lerp(to, t)
        
        if position.distance_to(to) < 1.0:
            position_buffer.pop_front()

# Called by MultiplayerSynchronizer when position updates
func _on_position_synced(new_pos: Vector2) -> void:
    position_buffer.append(new_pos)
    if position_buffer.size() > BUFFER_SIZE:
        position_buffer.pop_front()

### Server-Side Lag Compensation (Hit Rewind)

To ensure clients can hit targets accurately despite latency, the server must "rewind" the world state to the exact moment the client fired.

**Expert Pattern:**
1. **Record History**: Store global transforms of all hit-able entities (players, enemies) in a rolling buffer indexed by `Engine.get_physics_frames()`.
2. **Hit Request**: Client sends a "Fire" RPC including the `tick` when they pressed the button.
3. **Rewind**: Server retrieves the state for that `tick`, temporarily moves all RIDs back to those transforms via `PhysicsServer3D.body_set_state()`.
4. **Validate**: Perform a raycast query.
5. **Restore**: Move all RIDs back to their "present day" transforms.

> [!TIP]
> Always use `PhysicsServer3D` directly for rewinding to bypass `SceneTree` overhead and prevent unwanted signal/node update cascades.
```

---
