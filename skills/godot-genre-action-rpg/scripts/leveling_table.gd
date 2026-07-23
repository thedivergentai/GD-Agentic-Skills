# leveling_table.gd
# Data-driven XP required curves
extends Resource
class_name LevelingTable

# EXPERT NOTE: Using a curve or a formula in a Resource 
# allows balancing progression without touching code.

@export var xp_curve: Curve

func get_required_xp(level: int) -> int:
	# Sample from the designer-defined balance curve
	return int(xp_curve.sample(float(level) / 100.0) * 1000)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html — XP curve Resource
# - https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_exports.html — designer Curve export
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-rpg-stats/SKILL.md — level-up stat grants
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md — validate XP/power curve
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-action-rpg/SKILL.md
# =============================================================================
