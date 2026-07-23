# puzzle_saver.gd
extends Node
class_name PuzzleSaver

# Saving Persistent Puzzle State
# Serializes object properties safely into the user:// directory.

func save_game(save_name: String = "puzzle_save.json") -> void:
    var save_dict := {}
    var save_nodes := get_tree().get_nodes_in_group("Persist")
    
    for node in save_nodes:
        save_dict[node.name] = {
            # Pattern: Manually split complex types (Vector2) for JSON.
            "pos_x": node.position.x,
            "pos_y": node.position.y,
            "state": node.get("puzzle_state") if "puzzle_state" in node else 0
        }
        
    var path := "user://" + save_name
    var file := FileAccess.open(path, FileAccess.WRITE)
    if file:
        file.store_line(JSON.stringify(save_dict))
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html
# - https://docs.godotengine.org/en/stable/classes/class_json.html
# - https://docs.godotengine.org/en/stable/tutorials/io/runtime_file_loading_and_saving.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-save-load-systems/SKILL.md — versioned progress beyond one-off board JSON
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-puzzle/SKILL.md
# =============================================================================
