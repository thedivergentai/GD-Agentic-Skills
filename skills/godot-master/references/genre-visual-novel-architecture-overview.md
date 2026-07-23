# Architecture Overview

### 1. Story Manager (The Driver)
Parses the script and directs the other systems.

```gdscript
# story_manager.gd
extends Node

var current_script: Dictionary
var current_line_index: int = 0
var flags: Dictionary = {}

func load_script(script_path: String) -> void:
    var file = FileAccess.open(script_path, FileAccess.READ)
    current_script = JSON.parse_string(file.get_as_text())
    current_line_index = 0
    display_next_line()

func display_next_line() -> void:
    if current_line_index >= current_script["lines"].size():
        return
        
    var line_data = current_script["lines"][current_line_index]
    
    if line_data.has("choice"):
        present_choices(line_data["choice"])
    else:
        CharacterManager.show_character(line_data.get("character"), line_data.get("expression"))
        DialogueUI.show_text(line_data["text"])
        current_line_index += 1
```

### 2. Dialogue UI (Typewriter Effect)
Displaying text character by character.

```gdscript
# dialogue_ui.gd
func show_text(text: String) -> void:
    rich_text_label.text = text
    rich_text_label.visible_ratio = 0.0
    
    var tween = create_tween()
    tween.tween_property(rich_text_label, "visible_ratio", 1.0, text.length() * 0.05)
```

### 3. History & Rollback
Essential VN feature. Store the state before every line.

```gdscript
var history: Array[Dictionary] = []

func save_state_to_history() -> void:
    history.append({
        "line_index": current_line_index,
        "flags": flags.duplicate(),
        "background": current_background,
        "music": current_music
    })

func rollback() -> void:
    if history.is_empty(): return
    var trusted_state = history.pop_back()
    restore_state(trusted_state)
```
