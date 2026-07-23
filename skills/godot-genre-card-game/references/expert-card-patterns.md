# Expert patterns (load on demand)

> **MANDATORY** when implementing beyond Golden Path / Decision Trees. Do not paste into SKILL.md or scenes from memory.

## Architecture Overview

### 1. Card Data (Resource-based)
Godot Resources are perfect for card data.

```gdscript
# card_data.gd
extends Resource
class_name CardData

enum Type { ATTACK, SKILL, POWER }
enum Target { ENEMY, SELF, ALL_ENEMIES }

@export var id: String
@export var name: String
@export_multiline var description: String
@export var cost: int
@export var type: Type
@export var target_type: Target
@export var icon: Texture2D
@export var effect_script: Script # Custom logic per card
```

### 2. Deck Manager
Handles the piles: Draw Pile, Hand, Discard Pile, Exhaust Pile.

```gdscript
# deck_manager.gd
var draw_pile: Array[CardData] = []
var hand: Array[CardData] = []
var discard_pile: Array[CardData] = []

func draw_cards(amount: int) -> void:
    for i in amount:
        if draw_pile.is_empty():
            reshuffle_discard()
            
        if draw_pile.is_empty(): 
            break # No cards left
            
        var card = draw_pile.pop_back()
        hand.append(card)
        card_drawn.emit(card)

func reshuffle_discard() -> void:
    draw_pile.append_array(discard_pile)
    discard_pile.clear()
    draw_pile.shuffle()
```

### 3. Card Visual (UI)
The interactive node representing a card in hand.

```gdscript
# card_ui.gd
extends Control

var card_data: CardData
var start_pos: Vector2
var is_dragging: bool = false

func _gui_input(event: InputEvent) -> void:
    if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
        if event.pressed:
            start_drag()
        else:
            end_drag()

func _process(delta: float) -> void:
    if is_dragging:
        global_position = get_global_mouse_position() - size / 2
    else:
        # Hover effect or return to hand position
        pass
```

## Key Mechanics Implementation

### Effect Resolution (Command Pattern)
Decouple the "playing" of a card from its "effect".

```gdscript
func play_card(card: CardData, target: Node) -> void:
    if current_energy < card.cost:
        show_error("Not enough energy")
        return
        
    current_energy -= card.cost
    
    # Execute effect
    var effect = card.effect_script.new()
    effect.execute(target)
    
    move_to_discard(card)
```

### Hand Layout (Arching)
Cards in hand usually form an arc. Use a math formula (Bezier or Circle) to position them based on `index` and `total_cards`.

```gdscript
func update_hand_visuals() -> void:
    var center_x = screen_width / 2
    var radius = 1000.0
    var angle_step = 5.0
    
    for i in hand_visuals.size():
        var card = hand_visuals[i]
        var angle = deg_to_rad((i - hand_visuals.size() / 2.0) * angle_step)
        var target_pos = Vector2(
            center_x + sin(angle) * radius,
            screen_height + cos(angle) * radius
        )
        card.target_rotation = angle
        card.target_position = target_pos
```

## Godot-Specific Tips

*   **MouseFilter**: Getting drag/drop to work with overlapping UI requires careful setup of `mouse_filter` (Pass vs Stop).
*   **Z-Index**: Use `z_index` or `CanvasLayer` to ensure the dragged card is always on top of everything else.
*   **Tweens**: Essential! Tween position, rotation, and scale for that "juicy" Hearthstone/Slay the Spire feel.


---

## 🚀 Elite Technical Implementations (Batch 09)

### 1. Holographic Foil (Shader Script)
Add visual rarity and "juice" to cards using a holographic shader. This script uses iridescence based on TIME and UV coordinates to create a shifting rainbow effect.

```glsl
shader_type canvas_item;

uniform float foil_speed : hint_range(0.1, 5.0) = 1.0;
uniform float foil_intensity : hint_range(0.0, 1.0) = 0.5;

void fragment() {
    vec4 base_color = texture(TEXTURE, UV);
    
    // Create shifting rainbow iridescence
    vec3 holo_color = vec3(
        0.5 + 0.5 * sin(TIME * foil_speed + UV.x * 10.0),
        0.5 + 0.5 * sin(TIME * foil_speed + UV.y * 10.0 + 2.0),
        0.5 + 0.5 * sin(TIME * foil_speed + (UV.x + UV.y) * 10.0 + 4.0)
    );
    
    // Blend with base texture alpha
    COLOR = vec4(mix(base_color.rgb, holo_color, foil_intensity * base_color.a), base_color.a);
}
```

### 2. Card-History Logging (Action Tracking)
Track card actions (Played, Drawn, Discarded) for a history panel using a custom `Logger`. This intercepts messages tagged with `[CARD]` and routes them to a turn history buffer.

```gdscript
class_name CardHistoryLogger extends Logger

signal history_updated(entry: String)
var turn_history: Array[String] = []

func _log_message(message: String, error: bool) -> void:
    if not error and message.begins_with("[CARD]"):
        turn_history.append(message)
        history_updated.emit(message)

# To register (in an Autoload):
# func _init(): OS.add_logger(CardHistoryLogger.new())
```

### 3. Hand-Limit Logic (Over-Draw Protection)
Encapsulate hand data and enforce a maximum size. Use signals to notify the UI when a card is successfully drawn or discarded due to being overdrawn.

```gdscript
class_name HandManager extends Node

signal card_drawn(card: Resource)
signal card_overdrawn(card: Resource)

@export var max_hand_size: int = 10
var _current_hand: Array[Resource] = []

func draw_card(new_card: Resource) -> void:
    if _current_hand.size() >= max_hand_size:
        # Hand is full; trigger overdraw
        card_overdrawn.emit(new_card)
    else:
        _current_hand.append(new_card)
        card_drawn.emit(new_card)
```
