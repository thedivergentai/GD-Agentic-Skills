class_name NetENetExpertConfig
extends Node

## Expert ENet Tuning.
## Configures internal ENet settings for competitive-grade networking.

func setup_enet_peer(is_server: bool, port: int, max_clients: int = 32) -> ENetMultiplayerPeer:
	var peer = ENetMultiplayerPeer.new()
	var err: Error
	
	if is_server:
		err = peer.create_server(port, max_clients)
	else:
		err = peer.create_client("127.0.0.1", port)
	
	if err != OK: return null
	
	# Expert Tuning
	var host: ENetHost = peer.get_host()
	host.compress(ENetHost.COMPRESS_RANGE_CODER) # Efficient for dynamic packet sizes
	host.set_max_channels(3) # [0: Reliable, 1: Unreliable, 2: Ordered]
	
	# Limits
	host.set_bandwidth_limit(1024 * 1024, 1024 * 1024) # 1MB up/down
	
	return peer

## Rule: Use tailored Channels (Reliable vs Unreliable) to avoid Head-of-Line blocking.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_enetmultiplayerpeer.html
# - https://docs.godotengine.org/en/stable/classes/class_multiplayerpeer.html
# - https://docs.godotengine.org/en/stable/classes/class_enetconnection.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md — channel/bandwidth budgets under load
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — measure before retuning ENet knobs
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-multiplayer-networking/SKILL.md
# =============================================================================
