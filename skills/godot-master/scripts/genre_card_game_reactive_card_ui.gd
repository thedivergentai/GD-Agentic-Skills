# reactive_card_ui.gd
# Automatically updating UI nodes via Resource listeners
extends Control

@export var data: CardData

@onready var label = $NameLabel

func _ready():
	# EXPERT: React to data changes from ANY system
	data.changed.connect(_update_ui)
	_update_ui()

func _update_ui():
	label.text = data.card_name
	print("UI Refreshed for ", data.card_name)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html
# - https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html
# - https://docs.godotengine.org/en/stable/classes/class_control.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — Resource.changed → label/stat refresh
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md — bind UI to duplicated match instances
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-card-game/SKILL.md
# =============================================================================
