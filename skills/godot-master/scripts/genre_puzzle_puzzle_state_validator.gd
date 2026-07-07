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
