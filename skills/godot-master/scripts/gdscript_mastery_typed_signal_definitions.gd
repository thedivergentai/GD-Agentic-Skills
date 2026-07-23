# typed_signal_definitions.gd
# Strict parameter enforcement for cross-module reliability
extends Node

# EXPERT NOTE: Typed signals prevent "String vs Int" mismatch bugs 
# that are hard to track in large projects.

signal damage_taken(amount: int, origin: Vector2, critical: bool)
signal level_up(new_level: int)

func take_hit(dmg: int, pos: Vector2):
	var is_crit = randf() > 0.8
	# Compiler validates these arguments during emit() call
	damage_taken.emit(dmg, pos, is_crit)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_basics.html
# - https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html
# - https://docs.godotengine.org/en/stable/classes/class_signal.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — typed emits before bus/sequencer patterns
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-combat-system/SKILL.md — typed damage_taken payloads
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md
# =============================================================================
