extends Node
class_name PuzzleStateValidator

## Expert Puzzle Validation (Godot 4.7).
## Uses recursive dictionary comparisons for win conditions.

signal solved

@export var target_state: Dictionary = {}
var current_state: Dictionary = {}

func update_state(piece_id: String, state: Variant) -> void:
	current_state[piece_id] = state
	_check_win()

func _check_win() -> void:
	# Expert Pattern: Compare dictionaries directly
	if current_state.recursive_equal(target_state):
		solved.emit()
		print("Puzzle Solved!")

## [SKILL NOTICE]: Use 'Dictionary.recursive_equal()' for multi-layered 
## win conditions. It is significantly faster than manual nested loops.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/best_practices/data_preferences.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/idle_and_physics_processing.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — solved signal after recursive_equal
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md — compare target-state hardness across seeds
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-puzzle/SKILL.md
# =============================================================================
