class_name HSMReentryAwareState
extends Node

## Expert state with Re-entry Awareness.
## Distinguishes between fresh entry and being resumed from a stack.

func enter(msg: Dictionary = {}) -> void:
	if msg.get("is_resume", false):
		_on_resumed()
	else:
		_on_fresh_entry()

func _on_fresh_entry() -> void:
	# Trigger sound, start animation
	pass

func _on_resumed() -> void:
	# Keep current animation frame, just resume logic
	pass
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_basics.html
# - https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html
# - https://docs.godotengine.org/en/stable/tutorials/best_practices/godot_notifications.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — resume payloads should not re-fire entry SFX listeners
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-dialogue-system/SKILL.md — pop from dialogue stack resumes gameplay without fresh-entry FX
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-state-machine-advanced/SKILL.md
# =============================================================================
