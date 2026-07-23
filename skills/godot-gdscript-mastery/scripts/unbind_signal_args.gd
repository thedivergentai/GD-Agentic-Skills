# unbind_signal_args.gd
# Discarding unneeded signal arguments safely
extends Node

func _ready() -> void:
	# Some signals (like area_entered) pass an argument.
	# unbind(1) tells Godot to drop that argument before calling our function.
	$Area2D.area_entered.connect(_on_generic_event.unbind(1))

func _on_generic_event() -> void:
	print("Something entered the area, but I didn't need its reference.")
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_callable.html
# - https://docs.godotengine.org/en/stable/classes/class_signal.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — unbind unwanted physics/UI args
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md
# =============================================================================
