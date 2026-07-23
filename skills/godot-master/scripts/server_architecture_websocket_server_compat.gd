# websocket_server_compat.gd
# WebSocket implementation for HTML5/Web browser servers
extends Node

# EXPERT NOTE: ENet is UDP-only and unsupported in browsers. 
# WebSocketMultiplayerPeer is required for web compatibility.

func start_web_server(port: int):
	var peer := WebSocketMultiplayerPeer.new()
	var err = peer.create_server(port)
	if err == OK:
		multiplayer.multiplayer_peer = peer
		print("WebSocket Server active on port ", port)

# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/networking/websocket.html
# - https://docs.godotengine.org/en/stable/classes/class_websocketmultiplayerpeer.html
# - https://docs.godotengine.org/en/stable/tutorials/networking/high_level_multiplayer.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-platform-web/SKILL.md — HTML5 client constraints requiring WebSocket peers
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-multiplayer-networking/SKILL.md — shared high-level API over WebSocket transport
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-server-architecture/SKILL.md
# =============================================================================
