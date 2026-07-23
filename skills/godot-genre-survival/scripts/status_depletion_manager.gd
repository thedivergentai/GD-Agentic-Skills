extends Node
class_name StatusDepletionManager

## Expert Status Management (Godot 4.7).
## Activity-scaled hunger/thirst depletion (NEVER constant decay).

signal vitals_changed(stats: Dictionary)
signal vital_empty(id: StringName)

@export var sprinting: bool = false
@export var idle_multiplier: float = 1.0
@export var sprint_multiplier: float = 3.0

var stats: Dictionary = {
	"hunger": {"val": 100.0, "max": 100.0, "rate": 0.5},
	"thirst": {"val": 100.0, "max": 100.0, "rate": 0.8}
}

func _physics_process(delta: float) -> void:
	var activity := sprint_multiplier if sprinting else idle_multiplier
	for id in stats:
		var s: Dictionary = stats[id]
		s.val = clampf(s.val - (s.rate * activity * delta), 0.0, s.max)
		if is_equal_approx(s.val, 0.0) or s.val <= 0.0:
			vital_empty.emit(StringName(id))
	vitals_changed.emit(stats)

## [SKILL NOTICE]: Scale rates by activity — NEVER constant drain regardless of player action.

# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/idle_and_physics_processing.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-rpg-stats/SKILL.md — hunger/thirst as depleting stats
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-autoload-architecture/SKILL.md — global needs ownership
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-survival/SKILL.md
# =============================================================================
