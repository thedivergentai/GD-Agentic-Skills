# enet_br_server.gd
# Low-latency UDP server setup for high-player-count games
extends Node

# EXPERT NOTE: ENet is mandatory for Battle Royale games 
# to avoid TCP's head-of-line blocking and latency spikes.

func start_match_server(port: int = 7000):
	var peer := ENetMultiplayerPeer.new()
	# Unlimited bandwidth, 0 channels (max performance)
	var err = peer.create_server(port, 100) # 100 players
	if err == OK:
		multiplayer.multiplayer_peer = peer
		print("Match server spawned on port ", port)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_enetmultiplayerpeer.html
# - https://docs.godotengine.org/en/stable/tutorials/networking/high_level_multiplayer.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-multiplayer-networking/SKILL.md — ENet peer capacity and match host setup
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-server-architecture/SKILL.md — dedicated host process shape
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-battle-royale/SKILL.md
# =============================================================================
