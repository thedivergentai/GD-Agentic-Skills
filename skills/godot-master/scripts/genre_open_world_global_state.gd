# global_state.gd
var chunk_data: Dictionary = {} # Vector2i -> Dictionary

func set_entity_dead(chunk_id: Vector2i, entity_id: String) -> void:
    if not chunk_data.has(chunk_id):
        chunk_data[chunk_id] = {}
    chunk_data[chunk_id][entity_id] = { "dead": true }
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-open-world/SKILL.md
# =============================================================================
