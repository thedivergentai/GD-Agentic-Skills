# dialogue_ui_controller.gd
# Visual rendering of conversation lines
extends Control

@onready var text_label = $TextLabel
@onready var options_container = $OptionsContainer

func _ready():
	DialogueManager.line_started.connect(_on_line_started)

func _on_line_started(node: DialogueNode):
	text_label.text = node.text
	_clear_options()
	for i in range(node.options.size()):
		var btn = Button.new()
		btn.text = node.options[i].text
		btn.pressed.connect(DialogueManager.select_option.bind(i))
		options_container.add_child(btn)

func _clear_options():
	for child in options_container.get_children():
		child.queue_free()
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_control.html
# - https://docs.godotengine.org/en/stable/classes/class_button.html
# - https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md — options container layout
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — listen to manager signals
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-dialogue-system/SKILL.md
# =============================================================================
