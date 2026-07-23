# Authority And Security

## Anti-Cheat Measures

### Server-Side Validation

```gdscript
# server_validator.gd
extends Node

const MAX_SPEED = 300.0
const MAX_TELEPORT_DISTANCE = 50.0

@rpc("any_peer", "call_remote", "reliable")
func request_move(new_position: Vector2) -> void:
    var sender_id := multiplayer.get_remote_sender_id()
    var player := get_node("/root/World/" + str(sender_id))
    
    # Validate movement
    var distance := player.position.distance_to(new_position)
    var delta := get_physics_process_delta_time()
    var max_allowed := MAX_SPEED * delta
    
    if distance > max_allowed:
        push_warning("Player %d teleported %f units (max: %f)" % [sender_id, distance, max_allowed])
        # Reject movement, force server position
        rpc_id(sender_id, "force_position", player.position)
        return
    
    # Accept movement
    player.position = new_position

@rpc("authority", "call_remote", "reliable")
func force_position(server_position: Vector2) -> void:
    position = server_position
```

---

## Bandwidth Optimization

### Input Buffering

```gdscript
# ❌ BAD: Send input every frame (60 packets/s)
func _physics_process(delta: float) -> void:
    var input := get_input()
    rpc_id(1, "receive_input", input)

# ✅ GOOD: Send every 3rd frame (20 packets/s)
var input_timer := 0.0
const INPUT_SEND_RATE = 0.05  # 20 Hz

func _physics_process(delta: float) -> void:
    input_timer += delta
    if input_timer >= INPUT_SEND_RATE:
        var input := get_input()
        rpc_id(1, "receive_input", input)
        input_timer = 0.0
```

---

## Testing Multiplayer Locally

```gdscript
# Launch multiple instances for testing
# Run from command line:

# Windows:
# Server: Godot.exe --path . res://main.tscn -- --server
# Client 1: Godot.exe --path . res://main.tscn -- --client
# Client 2: Godot.exe --path . res://main.tscn -- --client

# Parse arguments in code:
func _ready() -> void:
    var args := OS.get_cmdline_args()
    if "--server" in args:
        host_game()
    elif "--client" in args:
        join_game("127.0.0.1")
```

---
