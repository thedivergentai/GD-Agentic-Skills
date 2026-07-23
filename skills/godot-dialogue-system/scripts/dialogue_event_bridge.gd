# dialogue_event_bridge.gd
# Triggering game logic from conversation nodes
extends Node

func _ready():
	DialogueManager.line_started.connect(_on_line_started)

func _on_line_started(node: DialogueNode):
	if node.event_signal != "":
		# Assumes a GlobalEventBus or similar
		if get_tree().root.has_node("GlobalBus"):
			get_node("/root/GlobalBus").emit_signal(node.event_signal)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — GlobalBus event routing
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-quest-system/SKILL.md — quest hooks from dialogue
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-dialogue-system/SKILL.md
# =============================================================================
