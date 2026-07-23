class_name ReplayManager extends Node

var frame_history: Array[PackedByteArray] = []

func record_frame(state: Dictionary) -> void:
    # Efficiently convert data to bytes
    frame_history.append(var_to_bytes(state))

func save_replay(match_id: String) -> void:
    var file := FileAccess.open("user://replays/" + match_id + ".dat", FileAccess.WRITE)
    if file:
        file.store_var(frame_history) # Stores the whole array as a variant
        file.close()

func play_frame(frame_index: int) -> Dictionary:
    return bytes_to_var(frame_history[frame_index])
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-moba/SKILL.md
# =============================================================================
