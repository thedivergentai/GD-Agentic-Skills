class_name CompHealthComponent
extends Node

## Expert Decoupled Health Component.
## Acts as a data-store and logic-gate for damage.

signal health_changed(new_health: float)
signal health_depleted

@export var max_health: float = 100.0
@onready var current_health: float = max_health

func damage(amount: float) -> void:
	current_health = clamp(current_health - amount, 0, max_health)
	health_changed.emit(current_health)
	
	if current_health <= 0:
		health_depleted.emit()

## Rule: This component knows nothing about 'Player' or 'Enemies', only 'Health'.

# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html
# - https://docs.godotengine.org/en/stable/tutorials/best_practices/godot_interfaces.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-composition/SKILL.md — context-agnostic health data component
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — health_changed / depleted emit contracts
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-composition-apps/SKILL.md
# =============================================================================
