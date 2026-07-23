# enet_optimized_host.gd
# Configuring high-performance UDP hosts for Godot servers
extends Node

# EXPERT NOTE: ENet is the preferred protocol for action games. 
# Defining precise bandwidth and client limits is vital for stability.

func setup_enet_server(port: int, max_clients: int):
	var peer := ENetMultiplayerPeer.new()
	# Port, Max Clients, Channels (0 for default), In/Out Bandwidth (0 for unlimited)
	var err := peer.create_server(port, max_clients, 0, 0, 0)
	
	if err == OK:
		multiplayer.multiplayer_peer = peer
		print("Server listening on port ", port)
	else:
		push_error("ENet Server Setup Failed: ", err)

# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_enetmultiplayerpeer.html
# - https://docs.godotengine.org/en/stable/tutorials/networking/high_level_multiplayer.html
# - https://docs.godotengine.org/en/stable/classes/class_multiplayerapi.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-multiplayer-networking/SKILL.md — ENet channel/bandwidth tuning beyond create_server
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-adapt-single-to-multiplayer/SKILL.md — wire host peer into authority split
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-server-architecture/SKILL.md
# =============================================================================
