# secure_variable_synchronizer.gd
# Authority-only variable updates
extends Node

# EXPERT NOTE: Never let clients dictate their own health 
# or money. Only the server updates these variables.

@export var health: int = 100:
	set(val):
		health = val
		health_changed.emit(val)

signal health_changed(new_val)

func damage(amount: int):
	# Damage logic should only execute on the server
	if not multiplayer.is_server(): return
	health -= amount
	# Update will replicate automatically if using Synchronizer
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_multiplayersynchronizer.html
# - https://docs.godotengine.org/en/stable/classes/class_node.html
# - https://docs.godotengine.org/en/stable/tutorials/networking/high_level_multiplayer.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-adapt-single-to-multiplayer/SKILL.md — authority-owned shared state
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-save-load-systems/SKILL.md — persist economy/identity, not PeerIDs
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-multiplayer-networking/SKILL.md
# =============================================================================
