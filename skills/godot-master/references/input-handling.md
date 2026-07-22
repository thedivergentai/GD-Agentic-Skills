---
name: godot-input-handling
description: "Expert patterns for input handling covering InputMap actions, InputEvent processing, controller support, rebinding, deadzones, and input buffering. Use when setting up player controls, implementing input systems, or adding gamepad/accessibility features. Keywords InputMap, InputEvent, gamepad, controller, rebinding, deadzone, input buffer."
---

# Input Handling

Handle keyboard, mouse, gamepad, and touch input with proper buffering and accessibility support.

## Available Scripts

### [advanced_input_buffer.gd](../scripts/input_handling_advanced_input_buffer.gd)
Frame-perfect input buffering system for responsive jumps, dashes, and combo chains.

### [safe_runtime_rebind.gd](../scripts/input_handling_safe_runtime_rebind.gd)
Dynamic input rebinding with conflict detection, persistence, and multi-device support.

### [analog_deadzone_manager.gd](../scripts/input_handling_analog_deadzone_manager.gd)
Radial deadzone management for analog sticks to eliminate drift while maintaining natural follow-through.

### [multi_touch_gestures.gd](../scripts/input_handling_multi_touch_gestures.gd)
Handling touch, drags, and pinch-to-zoom gestures for mobile and touchscreen compatibility.

### [input_echo_filter.gd](../scripts/input_handling_input_echo_filter.gd)
Filtering echo events to distinguish between hold-to-navigate (UI) and one-time gameplay actions.

### [mouse_capture_manager.gd](../scripts/input_handling_mouse_capture_manager.gd)
Robust mouse capture and sensitivity scaling logic for FPS and mouse-intensive systems.

### [hold_toggle_accessibility.gd](../scripts/input_handling_hold_toggle_accessibility.gd)
Software-side support for user-defined 'Hold' vs 'Toggle' accessibility preferences.

### [glyph_prompt_manager.gd](../scripts/input_handling_glyph_prompt_manager.gd)
Real-time switching between Keyboard and Gamepad UI prompts based on the last active device.

### [action_state_machine.gd](../scripts/input_handling_action_state_machine.gd)
Tracking the lifecycle of an action ('Just Pressed', 'Held', 'Released') for complex state logic.

### [unhandled_input_priority.gd](../scripts/input_handling_unhandled_input_priority.gd)
Demonstrating the correct use of `_unhandled_input` to prevent gameplay logic from leaking into UI.

> **MANDATORY - For Responsive Controls**: Read input_buffer.gd before implementing jump/dash mechanics.

## NEVER Do in Input Handling

- **NEVER poll input in `_process()` for gameplay actions** — Use `_physics_process()` or `_unhandled_input()`. `_process()` is frame-rate dependent, causing dropped inputs at low FPS [22].
- **NEVER use hardcoded key checks (e.g., `KEY_W`)** — Always use `InputMap` actions. Hardcoded keys prevent rebinding and break compatibility with non-QWERTY layouts [23].
- **NEVER ignore analog stick deadzones** — Drifting sticks at 0.05 magnitude will cause unintended movement. Implement a radial deadzone (not axial) in code or settings [24].
- **NEVER assume a single input device** — Players may switch between Keyboard and Controller mid-session. Use `Input.joy_connection_changed` to update UI prompts dynamically [25].
- **NEVER use `_input()` for gameplay actions** — `_input()` fires for ALL events (including UI). Use `_unhandled_input()` so gameplay logic doesn't trigger while clicking menus [26].
- **NEVER omit input buffering in fast-paced games** — If a player presses jump 50ms before landing, the input is lost without a buffer. Implement a 100-150ms buffer for a "tight" feel [27].
- **NEVER use `Input.is_action_pressed()` for one-time triggers** — It returns true every frame the key is held. Use `_just_pressed` for jumps, attacks, and toggles to avoid logic spam.
- **NEVER implement manual 'Hold vs Toggle' logic in multiple places** — Centralize it in a setting or input wrapper to ensure accessibility consistency across the whole game.
- **NEVER forget to handle `InputEvent.is_echo()` in UI navigation** — Echo events (keyboard repeat) should move menus but rarely should they trigger "Confirm" or "Back" actions.
- **NEVER capture the mouse without a 'Release' shortcut** — If your game crashes or blocks `ui_cancel`, the user is trapped. Always provide a fallback escape for mouse capture.

---

## Godot 4.7: Input Device IDs

- Mouse and keyboard are no longer device ID `0` — use `InputEvent.DEVICE_ID_MOUSE` and `InputEvent.DEVICE_ID_KEYBOARD`.
- **NEVER** compare `event.device == 0` for mouse/keyboard; joypads may legitimately use ID 0.

## Input Propagation & Isolation
Godot propagates input events in a specific order. Understanding this is key to isolating UI from gameplay.

1. **`_input(event)`**: High-priority global intercept. Use for dev consoles or debug overlays.
2. **`_gui_input(event)`**: Handled by **Control nodes (UI)**. If a UI element consumes the event (e.g., clicking a button), it calls `accept_event()`, stopping further propagation.
3. **`_unhandled_input(event)`**: Reached ONLY if no UI element consumed the event. **Expert Pattern**: Put all gameplay logic (jump, shoot) here to prevent accidental triggers while interacting with menus.

## InputMap Best Practices
Avoid physical key checks. Define semantic actions (e.g., `move_left`, `interact`) in **Project Settings > Input Map**.

### 1. Analog Deadzones
Analog sticks suffer from drift. Use `Input.get_vector()` for mathematically correct **circular deadzones**.
- **Bad**: Subtracting axis strengths manually creates "square" deadzones.
- **Good**: `var input := Input.get_vector("left", "right", "up", "down")` applies a perfectly circular deadzone and clamps magnitude to 1.0.

### 2. Basic Polling

```gdscript
# Check if action pressed this frame
if Input.is_action_just_pressed("jump"):
    jump()

# Check if action held
if Input.is_action_pressed("fire"):
    shoot()

# Check if action released
if Input.is_action_just_released("jump"):
    release_jump()

# Get axis (-1 to 1)
var direction := Input.get_axis("move_left", "move_right")

# Get vector
var input_vector := Input.get_vector("left", "right", "up", "down")
```

## InputEvent Processing

```gdscript
func _input(event: InputEvent) -> void:
    if event is InputEventKey:
        if event.keycode == KEY_ESCAPE and event.pressed:
            pause_game()
    
    if event is InputEventMouseButton:
        if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
            click_position = event.position
```

## Multi-Modal Input & UI Glyphs
Modern games must handle simultaneous Controller and Keyboard/Mouse input smoothly.

### 1. Handling Input Modes
- **Mouse Aiming**: Process `InputEventMouseMotion` in `_unhandled_input()` for relative movement.
- **Stick Movement**: Poll `Input.get_vector()` in `_physics_process()` for clamped state.

### 2. Dynamic Glyph Swapping
To update UI prompts (e.g., "Press E" vs "Press X") in real-time:
- **Autoload Strategy**: Create a singleton that monitors `_input(event)`.
- **Detection**: Check `event is InputEventJoypadButton` or `InputEventJoypadMotion` to detect gamepad use.
- **Broadcasting**: Emit a signal (e.g., `signal device_changed(is_gamepad: bool)`) when the hardware type shifts. All UI elements should listen to this signal to swap their prompt textures.

## Expert Input Extensions

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

## Reference
- [Godot Docs: InputEvent](https://docs.godotengine.org/en/stable/tutorials/inputs/inputevent.html)

## Expert Input Architectures

### 1. Input-Event-Parsing (Virtual Injection)
To simulate player input for automated testing or AI assistance, use `Input.parse_input_event()`. This injects raw `InputEvent` objects directly into the engine's processing pipeline, bypassing physical hardware. This is critical for building robust CI/CD test suites or deterministic tutorials.

```gdscript
class_name VirtualInputInjector extends Node
## Injects virtual hardware events into the engine pipeline.

func simulate_jump() -> void:
    var event := InputEventAction.new()
    event.action = &"jump"
    event.pressed = true
    
    # 1. Dispatch the "Pressed" event.
    Input.parse_input_event(event)
    
    # 2. Schedule the "Released" event.
    await get_tree().create_timer(0.1).timeout
    event.pressed = false
    Input.parse_input_event(event)
```

### 2. Input-Combo-Validation (Sequence Buffering)
Professional fighting games and action-RPGs utilize a rolling buffer to validate complex input sequences (e.g., "Down, Right, Punch"). Store semantic actions with their timestamps and check if the buffer ends with a specific pattern within a strict time window (e.g., 500ms).

```gdscript
class_name ComboValidator extends Node
## Validates timed input sequences for special moves.

var _input_buffer: Array[Dictionary] = []
@export var combo_timeout: float = 0.5

func add_input(action: StringName) -> void:
    _input_buffer.append({"action": action, "time": Time.get_ticks_msec()})
    _cleanup_buffer()
    
    # Example: Fireball (Down, Right, Attack)
    if _check_sequence(["move_down", "move_right", "attack"]):
        _execute_special_move("fireball")

func _cleanup_buffer() -> void:
    var now := Time.get_ticks_msec()
    _input_buffer = _input_buffer.filter(func(i): return now - i.time < (combo_timeout * 1000))

func _check_sequence(sequence: Array[StringName]) -> bool:
    if _input_buffer.size() < sequence.size(): return false
    
    for i in range(sequence.size()):
        var buffer_idx := _input_buffer.size() - sequence.size() + i
        if _input_buffer[buffer_idx].action != sequence[i]:
            return false
    return true
```

### 3. Input-Replay-Buffer (Deterministic Playback)
Deterministic replay is essential for debugging high-speed physics or creating "Ghost" racing data. Capture every `InputEvent` in `_unhandled_input()`, serializing the data with the current `multiplayer.get_unique_id()` or frame count.

```gdscript
class_name InputReplayBuffer extends Node
## Captures and replays deterministic input streams.

var _recorded_events: Array[Dictionary] = []
var _is_replaying: bool = false

func _unhandled_input(event: InputEvent) -> void:
    if _is_replaying: return
    
    # Capture the duplicate event and current engine frame.
    _recorded_events.append({
        "frame": Engine.get_frames_drawn(),
        "event": event.duplicate()
    })

func start_replay() -> void:
    _is_replaying = true
    var start_frame := Engine.get_frames_drawn()
    
    for entry in _recorded_events:
        var target_frame: int = entry.frame
        while Engine.get_frames_drawn() < start_frame + target_frame:
            await get_tree().process_frame
        
        Input.parse_input_event(entry.event)
```

## Reference
- [Godot Docs: InputEvent](https://docs.godotengine.org/en/stable/tutorials/inputs/inputevent.html)


### Related
- Master Skill: [godot-master](../SKILL.md)
