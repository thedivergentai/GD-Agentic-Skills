# manual_network_poll.gd
# Running networking on a separate thread via manual polling
extends Node

# EXPERT NOTE: Disabling SceneTree.multiplayer_poll allows 
# you to control exactly when network packets are processed.

func _ready():
	# Stop the engine from automatically polling networking
	get_tree().multiplayer_poll = false

func _physics_process(_delta):
	# Manual pumping of the network stack, usually inside a Mutex lock
	if multiplayer.has_multiplayer_peer():
		multiplayer.poll()

# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_multiplayerapi.html
# - https://docs.godotengine.org/en/stable/classes/class_scenemultiplayer.html
# - https://docs.godotengine.org/en/stable/tutorials/networking/high_level_multiplayer.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-multiplayer-networking/SKILL.md — poll timing with transfer modes and sync Hz
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md — off-main-thread poll vs frame budget
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-server-architecture/SKILL.md
# =============================================================================
