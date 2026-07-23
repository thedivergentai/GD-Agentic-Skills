# callable_binding_context.gd
# Injecting extra data into callbacks using bind()
extends Node

func _ready() -> void:
	for i in range(5):
		var btn = Button.new()
		# When clicked, _on_button_pressed will receive 'i' as an argument
		btn.pressed.connect(_on_button_pressed.bind(i))
		add_child(btn)

func _on_button_pressed(index: int) -> void:
	print("Clicked button number: ", index)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_callable.html
# - https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — bind context on shared handlers
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md — bind index/id on button.pressed
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md
# =============================================================================
