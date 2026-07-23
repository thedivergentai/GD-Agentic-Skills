# track_signal_emitter_source.gd
# Identifying which node fired a shared signal
extends Node

func _ready():
	# Connect multiple buttons to the same handler
	for btn in $Menu/Buttons.get_children():
		# Append the emitter itself to the callback arguments
		btn.pressed.connect(_on_button_pressed, CONNECT_APPEND_SOURCE_OBJECT)

func _on_button_pressed(source: Button):
	print("Clicked: ", source.name)
	match source.name:
		"Quit": get_tree().quit()
		"Start": _start_game()
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_object.html
# - https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md — shared pressed handler with APPEND_SOURCE_OBJECT
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md
# =============================================================================
