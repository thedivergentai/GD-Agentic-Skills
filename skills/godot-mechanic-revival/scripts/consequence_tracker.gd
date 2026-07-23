class_name ConsequenceTracker
extends Node

## Tracks cumulative deaths and modifies game state accordingly.
## Useful for dynamic difficulty (God Hand style) or narrative penalties (Dragonrot).

signal difficulty_changed(new_level: int)

@export var death_count: int = 0
@export var revive_count: int = 0

# Configurable thresholds for consequences
@export var difficulty_increase_threshold: int = 5

func record_death() -> void:
	death_count += 1
	_check_consequences()

func record_revive() -> void:
	revive_count += 1
	# Maybe reviving REDUCES the death penalty?
	# Or maybe it costs more meta-currency.

func _check_consequences() -> void:
	# Example: Every 5 deaths, increase world difficulty (or decrease for mercy)
	if death_count % difficulty_increase_threshold == 0:
		var difficulty_level = int(death_count / difficulty_increase_threshold)
		difficulty_changed.emit(difficulty_level)
		print("World Tendency Shifted: Custom Difficulty Level " + str(difficulty_level))
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html — difficulty_changed on death thresholds
# - https://docs.godotengine.org/en/stable/classes/class_node.html — accumulate death/revive counters
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md — simulate death-penalty curves
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-roguelike/SKILL.md — meta consequences after run death
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-mechanic-revival/SKILL.md
# =============================================================================
