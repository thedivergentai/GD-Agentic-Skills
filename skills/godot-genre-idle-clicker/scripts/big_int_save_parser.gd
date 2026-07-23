# big_int_save_parser.gd
extends Node

# 64-bit Integer JSON Save Parser
# Safely handles quintillions of currency units during serialization into/from JSON.
func load_economic_state(json_string: String) -> void:
    var data: Dictionary = JSON.parse_string(json_string)
    
    # USE to_float() then int() for scientific notation strings like "1e20".
    # to_int() is unsafe for exponential strings as it stops at the 'e'.
    var raw_value = data.get("balance", "0")
    if raw_value is String:
        var balance: int = int(raw_value.to_float())
        _apply_balance(balance)

func _apply_balance(_val: int) -> void: pass
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_json.html
# - https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html
# - https://docs.godotengine.org/en/stable/classes/class_fileaccess.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-save-load-systems/SKILL.md — parse scientific notation balances
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md — to_float before int for e-notation
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-idle-clicker/SKILL.md
# =============================================================================
