# server_dedicated_host.gd
# Configuring a dedicated server instance
extends Node

# EXPERT NOTE: For dedicated servers, use ENetMultiplayerPeer 
# and disable the scene tree rendering if not needed (Server build).

func start_dedicated_server(port: int):
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(port)
	if error != OK:
		printerr("Server startup failed: ", error)
		return
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(_on_client_connected)
	print("Dedicated server listening on ", port)

func _on_client_connected(id: int):
	print("Client connected: ", id)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_enetmultiplayerpeer.html
# - https://docs.godotengine.org/en/stable/tutorials/editor/command_line_tutorial.html
# - https://docs.godotengine.org/en/stable/classes/class_multiplayerapi.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-server-architecture/SKILL.md — headless dedicated host scaffolding
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-export-builds/SKILL.md — server export presets without GUI
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-multiplayer-networking/SKILL.md
# =============================================================================
