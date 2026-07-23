# unbind_unwanted_args.gd
# Cleaning up function signatures by discarding signal data
extends Node

func _ready():
	# area_entered emits 1 argument (the area).
	# unbind(1) drops it so we can use a simpler function.
	$Area2D.area_entered.connect(_play_chime.unbind(1))

func _play_chime():
	# This function doesn't need to know WHICH area entered.
	$AudioStreamPlayer.play()
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_callable.html
# - https://docs.godotengine.org/en/stable/classes/class_signal.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md — unbind to keep handler signatures clean
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md
# =============================================================================
