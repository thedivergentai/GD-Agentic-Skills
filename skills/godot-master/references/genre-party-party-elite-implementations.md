# Party / Minigame Elite Implementations (load on demand)

> **LLM-ignorance keep rule:** content here is expert Godot/genre knowledge a general agent would not know without reading — never delete, only relocate.

> **MANDATORY** when implementing systems beyond the `scripts/` catalog. Peer skills own full tutorials — route after this reference.

---

## Architecture Overview

### 1. Minigame Definition
Using Resources to define what a minigame is.

```gdscript
# minigame_data.gd
class_name MinigameData extends Resource

@export var title: String
@export var scene_path: String
@export var instructions: String
@export var is_1v3: bool = false
@export var thumbnail: Texture2D
```

### 2. The Party Manager
Singleton that persists between minigames.

```gdscript
# party_manager.gd
extends Node

var players: Array[PlayerData] = [] # Tracks score, input_device_id, color
var current_round: int = 1
var max_rounds: int = 10

func start_minigame(minigame: MinigameData) -> void:
    # 1. Show instructions scene
    await show_instructions(minigame)
    # 2. Transition to actual game
    get_tree().change_scene_to_file(minigame.scene_path)
    # 3. Pass player data to the new scene
    # (The minigame scene must look up PartyManager in _ready)
```

### 3. Minigame Base Class
Every minigame inherits from this to ensure compatibility.

```gdscript
# minigame_base.gd
class_name Minigame extends Node

signal game_ended(results: Dictionary)

func _ready() -> void:
    setup_players(PartyManager.players)
    start_countdown()

func end_game() -> void:
    # Calculate winner
    game_ended.emit(results)
    PartyManager.handle_minigame_end(results)
```

---

## Key Mechanics Implementation

### Local Multiplayer Input
Handling dynamic device assignment.

```gdscript
# player_controller.gd
@export var player_id: int = 0 # 0, 1, 2, 3

func _physics_process(delta: float) -> void:
    var device = PartyManager.players[player_id].device_id
    # Use the specific device ID for input
    var direction = Input.get_vector("p%s_left" % player_id, ...) 
    # Better approach: Remap InputMap actions at runtime explicitly
```

### Asymmetric Gameplay (1v3)
Balancing the "One" vs the "Many".
*   **The One**: Powerful, high HP, unique abilities (e.g., Bowser suit).
*   **The Many**: Weak individually, must cooperate to survive/win.

---

## Godot-Specific Tips

*   **SubViewport**: Powerful for 4-player split-screen. Each player gets a camera, all rendering the same world (or different worlds!).
*   **InputEventJoypadButton**: Use `Input.get_connected_joypads()` to auto-detect controllers on the Lobby screen.
*   **Remapping**: Godot's `InputMap` system can be modified at runtime using `InputMap.action_add_event()`. Creating "p1_jump", "p2_jump" dynamically is a common pattern.

---

## 🚀 Elite Technical Implementations (Batch 09)

### 1. Local-Input-Remapping Pattern (4+ Controllers)
To support dynamic local multiplayer, generate player-specific input actions at runtime using the `InputMap` singleton. This avoids hardcoding "p1_jump" and allows any connected joypad to be assigned to any player slot.

```gdscript
class_name PartyInputManager extends Node

---

## Dynamically registers input actions for a specific player and device.
func register_player_device(player_index: int, device_id: int) -> void:
    var base_actions: Array[String] = ["jump", "dash", "interact"]
    
    for action in base_actions:
        var player_action: StringName = StringName("p%d_%s" % [player_index, action])
        
        if not InputMap.has_action(player_action):
            InputMap.add_action(player_action)
            
        InputMap.action_erase_events(player_action)
        
        var joy_event := InputEventJoypadButton.new()
        joy_event.device = device_id
        joy_event.button_index = JOY_BUTTON_A # Map based on action...
        
        InputMap.action_add_event(player_action, joy_event)
```

### 2. Minigame-Orchestrator Pattern (Scene Switching)
Party games rapidly cycle between minigames. Use an Autoload to securely `free()` the current scene and load the next `PackedScene` using `call_deferred` to prevent crashes during physics/logic execution.

```gdscript
class_name MinigameOrchestrator extends Node

var _current_scene: Node

func _ready() -> void:
    _current_scene = get_tree().root.get_child(-1)

func transition_to_minigame(scene_path: String) -> void:
    call_deferred("_deferred_transition", scene_path)

func _deferred_transition(scene_path: String) -> void:
    _current_scene.free()
    var next_scene := ResourceLoader.load(scene_path) as PackedScene
    _current_scene = next_scene.instantiate()
    get_tree().root.add_child(_current_scene)
    get_tree().current_scene = _current_scene
```

### 3. Screen-Shake-Global Pattern (Impact Observer)
Decouple camera effects from gameplay logic using the Observer pattern. Gameplay nodes broadcast impact intensity via a global signal, and the camera script listens to apply decaying noise to its `h_offset` and `v_offset`.

```gdscript
class_name ImpactCamera3D extends Camera3D

@export var decay_rate: float = 5.0
var _current_shake_strength: float = 0.0

func _process(delta: float) -> void:
    if _current_shake_strength > 0.01:
        _current_shake_strength = lerpf(_current_shake_strength, 0.0, decay_rate * delta)
        h_offset = randf_range(-_current_shake_strength, _current_shake_strength)
        v_offset = randf_range(-_current_shake_strength, _current_shake_strength)
    else:
        h_offset = 0.0
        v_offset = 0.0

func _on_shake_requested(intensity: float) -> void:
    _current_shake_strength = max(_current_shake_strength, intensity)
```


- Master Skill: [godot-master](../SKILL.md)
