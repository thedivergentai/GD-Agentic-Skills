# static_state_manager.gd
# Using static variables for high-performance global state
extends RefCounted
class_name GlobalState

# EXPERT NOTE: static var is shared across all instances of the class. 
# It does NOT require an Autoload node in the SceneTree. 
# Access via: GlobalState.score += 10

static var score: int = 0
static var player_name: String = "Player1"
static var unlocked_levels: Array[int] = [1]

static func add_score(val: int) -> void:
	score += val

static func is_level_unlocked(lvl: int) -> bool:
	return unlocked_levels.has(lvl)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/best_practices/autoloads_versus_regular_nodes.html
# - https://docs.godotengine.org/en/stable/tutorials/best_practices/what_are_godot_classes.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_basics.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md — static var / class_name without SceneTree
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md — when a Resource beats static globals
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md — avoid Node Autoload overhead for pure data
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-autoload-architecture/SKILL.md
# =============================================================================
