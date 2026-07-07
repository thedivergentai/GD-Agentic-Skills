extends Node
class_name VisibilityManager

## Expert Visibility Logic (Godot 4.7).
## Manages environmental stealth modifiers (shadows, bushes, lockers).

var global_visibility_mult: float = 1.0
var active_modifiers: Dictionary = {}

func set_modifier(id: String, multiplier: float) -> void:
	active_modifiers[id] = multiplier
	_update_global_mult()

func remove_modifier(id: String) -> void:
	active_modifiers.erase(id)
	_update_global_mult()

func _update_global_mult() -> void:
	global_visibility_mult = 1.0
	# Expert Pattern: Take the strongest hiding modifier (lowest mult)
	for mult in active_modifiers.values():
		global_visibility_mult = min(global_visibility_mult, mult)

## [SKILL NOTICE]: Use a centralized manager to calculate 
## the player's detection susceptibility based on their environment.
