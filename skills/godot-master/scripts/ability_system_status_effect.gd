extends Resource
class_name StatusEffect

## Ticking status/buff Resource. Per-character instances MUST come from duplicate(true) on a template.

@export var effect_name: String = "Unknown"
@export var duration: float = 5.0
@export var tick_rate: float = 1.0

var _time_since_last_tick: float = 0.0
var _elapsed_time: float = 0.0


func apply_effect(_target: Node) -> void:
	pass


func process_tick(target: Node, delta: float) -> bool:
	_elapsed_time += delta
	_time_since_last_tick += delta
	if _time_since_last_tick >= tick_rate:
		apply_effect(target)
		_time_since_last_tick = 0.0
	return _elapsed_time >= duration
# ---
# GDSkills research links (agents)
# Docs:
# - https://docs.godotengine.org/en/stable/classes/class_resource.html — duplicate(true) before runtime apply
# - https://docs.godotengine.org/en/stable/tutorials/scripting/idle_and_physics_processing.html — tick in physics step via manager
# Related:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-combat-system/SKILL.md — DoT application
# ---
