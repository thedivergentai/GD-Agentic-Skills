# isolated_multiplayer_api.gd
# Running Client and Server instances in a single Godot run
extends Node

# EXPERT NOTE: Use for Local Hosting where the same instance 
# needs to act as both authoritative server and local client.

func split_branches():
	var server_api = MultiplayerAPI.create_default_interface()
	# Isolate the /root/Server branch to its own MultiplayerAPI root
	get_tree().set_multiplayer(server_api, ^"/root/Server")
	
	print("Network branches isolated: Client and Server now run independently.")

# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_multiplayerapi.html
# - https://docs.godotengine.org/en/stable/classes/class_scenemultiplayer.html
# - https://docs.godotengine.org/en/stable/tutorials/networking/high_level_multiplayer.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-multiplayer-networking/SKILL.md — SceneMultiplayer roots for host+client-in-one
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-scene-management/SKILL.md — /root/Server branch layout for isolated APIs
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-server-architecture/SKILL.md
# =============================================================================
