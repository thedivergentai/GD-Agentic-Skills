# binary_save_manager.gd
extends Node
class_name BinarySaveManager

# Efficient Binary Serialization
# Saves massive world-states (thousands of entity flags) with minimal I/O overhead.

func save_world_state(data: Dictionary, path: String) -> void:
    # Pattern: Use FileAccess.store_var with full_objects=false for clean data.
    var file := FileAccess.open(path, FileAccess.WRITE)
    if file:
        file.store_var(data, false)
        file.close()

func load_world_state(path: String) -> Dictionary:
    if not FileAccess.file_exists(path): return {}
    
    var file := FileAccess.open(path, FileAccess.READ)
    var data = file.get_var(false)
    file.close()
    return data if data is Dictionary else {}
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/io/binary_serialization_api.html
# - https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html
# - https://docs.godotengine.org/en/stable/classes/class_fileaccess.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-save-load-systems/SKILL.md — delta world-state schemas and versioning
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-quest-system/SKILL.md — persist chunk-scoped quest/entity flags
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-open-world/SKILL.md
# =============================================================================
