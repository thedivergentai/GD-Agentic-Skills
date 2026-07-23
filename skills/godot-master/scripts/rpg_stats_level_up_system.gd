# level_up_system.gd
# Orchestrating level up benefits
class_name LevelUpSystem extends Node

@export var stats: StatsComponent
@export var curve: ExpProgression

var current_exp: int = 0
var level: int = 1

func add_exp(amount: int):
	current_exp += amount
	var req = curve.get_required_exp(level)
	if current_exp >= req:
		_level_up()

func _level_up():
	level += 1
	# Apply permanent "Level Up" modifier
	var mod = StatusEffectData.new()
	mod.attribute = "strength"
	mod.value = 2.0
	mod.duration = 0 # Permanent
	stats.apply_modifier(mod)
	print("LEVEL UP! Now Level ", level)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-quest-system/SKILL.md — XP awards from quest completion
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md — validate level-up power spikes
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-rpg-stats/SKILL.md
# =============================================================================
