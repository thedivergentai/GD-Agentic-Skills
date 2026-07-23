# skills/genre-visual-novel/scripts/story_manager.gd
extends Node

## Story Manager (Expert Pattern)
## Driver for Visual Novels. Parses scripts, manages state, and directs UI.

class_name StoryManager

signal line_advanced(text: String, character: String)
signal options_presented(choices: Array)
signal scene_changed(background: String)

var script_data: Dictionary = {}
var current_index: int = 0
var flags: Dictionary = {}
var history: Array[Dictionary] = []

func load_script_from_json(path: String) -> void:
    var file = FileAccess.open(path, FileAccess.READ)
    if file:
        var json = JSON.new()
        if json.parse(file.get_as_text()) == OK:
            script_data = json.data
            current_index = 0
            _process_current_line()
        else:
            printerr("Invalid JSON script")

func advance() -> void:
    current_index += 1
    _process_current_line()

func _process_current_line() -> void:
    if not script_data.has("lines") or current_index >= script_data["lines"].size():
        return
        
    var line = script_data["lines"][current_index]
    
    # Save history state before processing
    history.append({
        "index": current_index,
        "flags": flags.duplicate(true)
    })
    
    if line.has("background"):
        scene_changed.emit(line["background"])
        
    if line.has("choices"):
        options_presented.emit(line["choices"])
    else:
        var char_name = line.get("character", "")
        var text = line.get("text", "")
        line_advanced.emit(text, char_name)

func select_choice(choice_index: int) -> void:
    var line = script_data["lines"][current_index]
    var choices = line["choices"]
    var selected = choices[choice_index]
    
    if selected.has("flag_updates"):
        for key in selected["flag_updates"]:
            flags[key] = selected["flag_updates"][key]
            
    if selected.has("jump_to"):
        _jump_to_label(selected["jump_to"])
    else:
        advance()

func _jump_to_label(label: String) -> void:
    # Simple linear search for label
    for i in range(script_data["lines"].size()):
         if script_data["lines"][i].get("label") == label:
             current_index = i
             _process_current_line()
             return

## EXPERT USAGE:
## Call load_script_from_json() with a path to a JSON file.
## Connect UI to signals to display text/choices.

# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html
# - https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html
# - https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-dialogue-system/SKILL.md — line/choice runner patterns this driver specializes
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — line_advanced / options_presented wiring
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md — JSON vs Resource script payloads
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-visual-novel/SKILL.md
# =============================================================================
