# health_component.gd
# Entity Composition pattern for modular RPG units
extends Node
class_name HealthComponent

signal health_changed(current: int, max: int)
signal died

@export var stats: BaseStats

var current_health: int

func _ready():
	current_health = stats.max_health

func damage(amount: int):
	current_health -= amount
	health_changed.emit(current_health, stats.max_health)
	if current_health <= 0:
		died.emit()
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html — health_changed / died
# - https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html — BaseStats Resource export
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-composition/SKILL.md — HealthComponent composition
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-combat-system/SKILL.md — damage apply pipeline
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-action-rpg/SKILL.md
# =============================================================================
