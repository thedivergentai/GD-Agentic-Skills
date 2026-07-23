# client_network_setup.gd
# Connecting to a remote server
extends Node

# EXPERT NOTE: Ensure the protocol (ENet/WebSocket) matches 
# the server. ENet is preferred for UDP-based fast action.

func connect_to_server(address: String, port: int):
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(address, port)
	if error != OK:
		printerr("Connection failed: ", error)
		return
	multiplayer.multiplayer_peer = peer
	multiplayer.connected_to_server.connect(_on_connection_success)

func _on_connection_success():
	print("Successfully connected to host!")
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_enetmultiplayerpeer.html
# - https://docs.godotengine.org/en/stable/classes/class_multiplayerapi.html
# - https://docs.godotengine.org/en/stable/tutorials/networking/high_level_multiplayer.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-adapt-single-to-multiplayer/SKILL.md — host/join client path after SP→MP split
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-export-builds/SKILL.md — matching client export/protocol with server
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-multiplayer-networking/SKILL.md
# =============================================================================
