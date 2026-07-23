# health_component.gd
# Specialized Node for managing lifespan and damage logic
class_name HealthComponent extends Node

# EXPERT NOTE: Components should be "ignorant" of their parent. 
# They emit signals up and the parent (or other components) respond.

signal health_changed(current: float, max: float)
signal health_depleted

@export var max_health: float = 100.0
@onready var current_health: float = max_health

func take_damage(amount: float) -> void:
	current_health = clamp(current_health - amount, 0, max_health)
	health_changed.emit(current_health, max_health)
	
	if current_health <= 0:
		health_depleted.emit()

func heal(amount: float) -> void:
	current_health = clamp(current_health + amount, 0, max_health)
	health_changed.emit(current_health, max_health)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html
# - https://docs.godotengine.org/en/stable/classes/class_node.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-rpg-stats/SKILL.md — max/current HP and heal/damage as stat-backed values
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-combat-system/SKILL.md — damage pipelines listen to health_changed / health_depleted
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — emit past-tense health events; parent wires handlers
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-composition/SKILL.md
# =============================================================================
