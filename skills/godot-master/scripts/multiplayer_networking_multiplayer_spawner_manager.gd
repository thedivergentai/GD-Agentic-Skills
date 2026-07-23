# multiplayer_spawner_manager.gd
# Syncing node spawning across the network
extends MultiplayerSpawner

# EXPERT NOTE: Use MultiplayerSpawner to automatically 
# instance nodes across all peers when added to parent.

func _ready():
	# Set spawn_path to a shared parent (e.g. /root/Main/Players)
	spawn_function = _custom_spawn

func _custom_spawn(data: Dictionary) -> Node:
	var player = preload("res://player.tscn").instantiate()
	player.player_id = data["id"]
	player.set_name(str(data["id"]))
	return player
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_multiplayerspawner.html
# - https://docs.godotengine.org/en/stable/classes/class_scenemultiplayer.html
# - https://docs.godotengine.org/en/stable/tutorials/networking/high_level_multiplayer.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-scene-management/SKILL.md — spawn paths and packed scenes
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-adapt-single-to-multiplayer/SKILL.md — late-join spawn graphs
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-multiplayer-networking/SKILL.md
# =============================================================================
