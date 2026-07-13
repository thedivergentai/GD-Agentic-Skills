---
name: godot-genre-party
description: "Expert blueprint for party games including minigame resource system (define via .tres files), local multiplayer input (4-player controller management), asymmetric gameplay (1v3 balance), scene management (clean minigame loading/unloading), persistent scoring (track wins across rounds), and split-screen rendering (SubViewport per player). Use for Mario Party-style games or WarioWare collections. Trigger keywords: party_game, minigame_collection, local_multiplayer, asymmetric_gameplay, split_screen, dynamic_input_mapping."
---

## Godot 4.7 Baseline

- Expert patterns in this skill target **Godot 4.7+** (stable, 2026-06-18).
- Consult the [Godot 4.7 migration guide](https://docs.godotengine.org/en/4.7/tutorials/migrating/upgrading_to_godot_4.7.html) when upgrading projects from 4.6.
- **NEVER** assume 4.6 defaults (stretch mode, audio area_mask, RichTextLabel percent flags) without checking 4.7 migration notes.

# Genre: Party / Minigame Collection

Expert blueprint for party games balancing accessibility, variety, and social fun.

## NEVER Do (Expert Anti-Patterns)

### Multiplayer & Input
- NEVER hardcode player inputs to specific joypad IDs (e.g., 0 or 1); strictly query dynamically via `Input.get_connected_joypads()`.
- NEVER bake player-IDs into the input map (e.g., "p1_jump"); strictly use a **Dynamic Input Router** to map physical controllers to players at runtime.
- NEVER use `Input.is_action_pressed()` for assigning new player joins; strictly parse raw `InputEventJoypadButton` in `_unhandled_input()` for device metadata.
- NEVER allow inconsistent controls between games; strictly standardize across all minigames (**A = Accept/Action**, **B = Back/Cancel**, **Joystick = Move**).
- NEVER assume a disconnected joypad removes a player; strictly connect to the `joy_connection_changed` signal to pause and handle dropouts gracefully.
- NEVER use boolean polling for analog sticks; strictly use `Input.get_vector()` for precision and deadzones.

### User Experience & Feedback
- NEVER use long text-based tutorials; strictly use a **3-second looping GIF** + a single-sentence instruction overlay (e.g., "Mash A to fly!").
- NEVER ignore "Asymmetric" balance in 1v3 games; strictly provide the "One" with unique abilities or increased HP/speed to offset the numerical disadvantage.
- NEVER neglect Accessibility and Handicap systems; strictly implement optional support (e.g., speed boosts for lower-skilled players) to keep the competition social.
- NEVER leave UI Control nodes with `FOCUS_NONE` for gamepad menus; strictly set to `FOCUS_ALL` with explicit focus neighbors for accessible navigation.

### Rendering & Architecture
- NEVER use heavy scene transitions; strictly keep minigame assets light and use **Threaded Background Loading** while the instructions screen is active.
- NEVER draw global `CanvasLayer` UI for individual split-screen players; strictly use per-viewport `CanvasLayer` children.
- NEVER manually set sizes on `SubViewport` children; strictly use `GridContainer` or `BoxContainer` for automatic split-screen layout.
- NEVER store tournament state or scores inside minigame scenes; strictly use a **Persistent Autoload** (Singleton).
- NEVER use a static `Camera2D` for shared-room games; strictly use a **dynamic group camera** that zooms/pans to fit all players in frame.
- NEVER overlap `SubViewportContainer` nodes without setting `mouse_filter` to `PASS`; otherwise, top viewports will block input.

---

## 🛠 Expert Components (scripts/)

### Original Expert Patterns
- [party_input_router.gd](scripts/party_input_router.gd) - Professional local multiplayer solution mapping `device_id` to `player_id`.

### Modular Components
- [player_join_manager.gd](scripts/player_join_manager.gd) - Slot mapping logic using raw JoypadButton event parsing.
- [split_screen_manager.gd](scripts/split_screen_manager.gd) - SubViewport synchronization for shared physics worlds.
- [tournament_state.gd](scripts/tournament_state.gd) - Persistent Autoload singleton for cross-scene state.

---

## Core Loop
1.  **Lobby**: Players join and select characters/colors.
2.  **Meta**: Players move on a board or vote for the next game.
3.  **Play**: Short, intense minigame (30s - 2m).
4.  **Score**: Winners get points/coins.
5.  **Repeat**: Cycle continues until a turn limit or score limit.

## Skill Chain

| Phase | Skills | Purpose |
|-------|--------|---------|
| 1. Input | `input-mapping` | Handling 2-4 local controllers dynamically |
| 2. Scene | `godot-scene-management` | Loading/Unloading minigames cleanly |
| 3. Data | `godot-resource-data-patterns` | Defining minigames via Resource files |
| 4. UI | `godot-ui-containers` | Scoreboards, instructions screens |
| 5. Logic | `godot-turn-system` | Managing the "Board Game" phase |

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

## Godot-Specific Tips

*   **SubViewport**: Powerful for 4-player split-screen. Each player gets a camera, all rendering the same world (or different worlds!).
*   **InputEventJoypadButton**: Use `Input.get_connected_joypads()` to auto-detect controllers on the Lobby screen.
*   **Remapping**: Godot's `InputMap` system can be modified at runtime using `InputMap.action_add_event()`. Creating "p1_jump", "p2_jump" dynamically is a common pattern.

## Common Pitfalls

1.  **Long Tutorials**: Players just want to play. **Fix**: 3-second looping GIF + 1 sentence instruction overlay before the game starts.
2.  **Downtime**: Loading times between 10-second minigames. **Fix**: Keep minigame assets light. Use a "Board" scene that stays loaded in the background if possible, or use creating `Thread` loading.
3.  **Confusing Controls**: Minigame A uses "A" to jump, Minigame B uses "B". **Fix**: Standardize. "A" is always Accept/Action. "B" is always Back/Cancel.


---

## 🚀 Elite Technical Implementations (Batch 09)

### 1. Local-Input-Remapping Pattern (4+ Controllers)
To support dynamic local multiplayer, generate player-specific input actions at runtime using the `InputMap` singleton. This avoids hardcoding "p1_jump" and allows any connected joypad to be assigned to any player slot.

```gdscript
class_name PartyInputManager extends Node

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


- Master Skill: [godot-master](../godot-master/SKILL.md)
