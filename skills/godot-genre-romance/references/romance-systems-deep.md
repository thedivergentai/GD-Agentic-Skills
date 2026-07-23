# Romance / Dating Sim Systems Deep-Dive (load on demand)

> **LLM-ignorance keep rule:** content here is expert Godot/genre knowledge a general agent would not know without reading — never delete, only relocate.

> **MANDATORY** when implementing systems beyond the `scripts/` catalog. Peer skills own full tutorials — route after this reference.

---

## Architecture Overview

### 1. Affection Manager (The Heart)
Handles complex relationship stats and gift preferences for all characters.

```gdscript
# affection_manager.gd
class_name AffectionManager
extends Node

signal milestone_reached(character_id, level)

var relationship_data: Dictionary = {} # character_id: { attraction: 0, trust: 0, comfort: 0 }

func add_affection(char_id: String, type: String, amount: int) -> void:
    if not relationship_data.has(char_id):
        relationship_data[char_id] = {"attraction": 0, "trust": 0, "comfort": 0}
    
    relationship_data[char_id][type] = clamp(relationship_data[char_id][type] + amount, -100, 100)
    check_milestones(char_id)

func get_gift_effect(char_id: String, item_id: String) -> int:
    # Logic for likes/dislikes with diminishing returns
    return 10 # Placeholder
```

### 2. Date Event System
Manages the success or failure of romantic outings.

```gdscript
# date_event_system.gd
func run_date(character_id: String, location_res: DateLocation) -> void:
    var score = 0
    # Weighted calculation
    score += relationship_data[character_id]["attraction"] * location_res.chemistry_mod
    score += relationship_data[character_id]["trust"] * location_res.safety_mod
    
    if score > location_res.success_threshold:
        play_date_outcome("SUCCESS", character_id)
    else:
        play_date_outcome("FAILURE", character_id)
```

### 3. Route Manager
Controls story branching and persistent unlocks.

```gdscript
# route_manager.gd
var unlocked_routes: Array[String] = []

func lock_in_route(char_id: String):
    # Detect conflicts with other routes here
    if flags.get("on_route"): return
    
    current_route = char_id
    flags["on_route"] = true
    unlocked_cgs.append(char_id + "_prologue")
```

---

## Key Mechanics Implementation

### Emotional Feedback (Juice)
Don't just change a number; show the change.

```gdscript
# ui_feedback.gd
func play_heart_burst(pos: Vector2):
    var heart = heart_scene.instantiate()
    add_child(heart)
    heart.global_position = pos
    var tween = create_tween().set_parallel()
    tween.tween_property(heart, "scale", Vector2(1.5, 1.5), 0.5)
    tween.tween_property(heart, "modulate:a", 0.0, 0.5)
```

### Time-Gated Events
Romance thrives on anticipation.

*   **Deadline Scheduling**: "Confess by June 15th or lose."
*   **Contextual Dialogue**: Characters reacting differently based on time of day or weather.

### 4. NPC Daily Schedule (Signal-Driven)
Avoid polling in `_process`. Use a central TimeManager and data-driven schedules.

```gdscript
# npc_schedule.gd (Resource)
class_name NPCSchedule extends Resource
@export var daily_routine: Dictionary = {8: "TownSquare", 12: "Tavern", 18: "Home"}

# npc_controller.gd
func _ready():
    TimeManager.hour_changed.connect(_on_hour_changed)

func _on_hour_changed(hour: int):
    var dest = schedule.daily_routine.get(hour, "")
    if dest: _navigate_to(dest)
```

### 5. Seasonal Dialogue Mapping
Inject world state into dialogue using `.format()` and `Resource` mapping.

```gdscript
# seasonal_dialogue.gd (Resource)
enum Season { SPRING, SUMMER, AUTUMN, WINTER }
@export var season_lines: Dictionary = { Season.WINTER: "Stay warm near the fire." }

# ui_layer.gd
func update_greeting(season: Season):
    var text = dialogue_res.get_seasonal_line(season)
    label.text = text.format({"player_name": Global.player_name})
```

### 6. Jealousy Broadcasting (Groups)
Decouple the player from NPC logic using `SceneTree.call_group()`.

```gdscript
# player_romance_manager.gd
func start_date(npc_name: String):
    # Notify everyone in the group without needing direct references
    get_tree().call_group("romantic_interests", "on_player_date_started", npc_name)

# npc_jealousy.gd
func _ready():
    add_to_group("romantic_interests")

func on_player_date_started(dating_name: String):
    if dating_name != self.name and affection > 30:
        affection -= 10 # Jealousy penalty
```

---

## Godot-Specific Tips

*   **Resources for Characters**: Use `CharacterProfile` resources to store base stats, sprites, and gift preferences.
*   **RichTextLabel Animations**: Use custom BBCode for "blushing" text (pulsing pink) or "nervous" text (shaking).
*   **Dialogic Integration**: While this skill focuses on the *systems*, pairing it with Godot's **Dialogic** plugin is highly recommended for handling the actual dialogue boxes.
