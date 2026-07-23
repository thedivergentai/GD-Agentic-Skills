# Expert Input Extensions

### 1. Input-Buffering (Action Queuing)
Decouple input presses from physics execution to make controls feel "tight." Store the input in a timed buffer and consume it when a valid state (e.g., landing) is reached [1, 2].

```gdscript
var jump_buffer_timer: float = 0.0

func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("jump"):
        jump_buffer_timer = 0.15 # 150ms window

func _physics_process(delta: float) -> void:
    if jump_buffer_timer > 0.0:
        jump_buffer_timer -= delta
        if is_on_floor():
            jump()
            jump_buffer_timer = 0.0
```

### 2. Coyote-Time (Jump Leniency)
Allow a jump for a few frames after the character leaves a ledge by tracking the time since last grounded [4].

```gdscript
var coyote_timer: float = 0.0

func _physics_process(delta: float) -> void:
    if is_on_floor():
        coyote_timer = 0.1 # 100ms grace period
    else:
        coyote_timer -= delta
    
    if Input.is_action_just_pressed("jump") and coyote_timer > 0.0:
        jump()
        coyote_timer = 0.0
```

### 3. Multiplayer-Input-Synchronization
Route local device input to the authoritative server using RPCs and `multiplayer.get_remote_sender_id()` for validation [7, 8].

```gdscript
@rpc("any_peer", "call_local", "unreliable")
func sync_input(dir: Vector2) -> void:
    var sender = multiplayer.get_remote_sender_id()
    # Apply dir to the player body associated with sender...
```
