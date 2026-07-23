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

# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/3d/lights_and_shadows.html
# - https://docs.godotengine.org/en/stable/tutorials/3d/visibility_ranges.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/groups.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-lighting/SKILL.md — shadow/cover modifiers that scale detection
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-horror/SKILL.md — hiding-spot multipliers shared with stalker AI
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md — bush/locker multiplier fairness sims
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-stealth/SKILL.md
# =============================================================================
