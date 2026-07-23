# static_var_singleton_alt.gd
# Using static variables for global state without Autoloads
extends Node
class_name GlobalState

# EXPERT NOTE: static var is shared across all scripts. 
# Accessible via GlobalState.score from anywhere.

static var score: int = 0
static var unlocked_levels: Array[int] = [1]

static func add_score(val: int):
	score += val

static func is_unlocked(lvl: int) -> bool:
	return unlocked_levels.has(lvl)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_advanced.html
# - https://docs.godotengine.org/en/stable/tutorials/best_practices/autoloads_versus_regular_nodes.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-autoload-architecture/SKILL.md — when Autoload beats static var
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md — register Autoload only when needed
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md
# =============================================================================
