# disconnect_ghost_signals.gd
# Memory management when switching tracking targets
extends Node

var current_target: Node

func track_new_entity(entity: Node):
	# Cleanup old connection to prevent memory/logic leaks
	if current_target and current_target.died.is_connected(_on_target_died):
		current_target.died.disconnect(_on_target_died)
		
	current_target = entity
	current_target.died.connect(_on_target_died)

func _on_target_died():
	print("Current target lost.")
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_signal.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/scene_tree.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-scene-management/SKILL.md — retarget listeners when entities swap
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-combat-system/SKILL.md — disconnect old target.died before tracking anew
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md
# =============================================================================
