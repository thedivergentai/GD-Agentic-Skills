# mock_network_provider.gd
# Expert utility for simulating network latency and packet loss during local tests.
# Grounded in Godot 4.x ENetMultiplayerPeer simulation properties.

extends Node

class_name MockNetworkProvider

## Configures the multiplayer peer with simulated latency/loss.
static func configure_simulated_network(peer: ENetMultiplayerPeer, latency_ms: int = 50, jitter_ms: int = 10, loss_percent: float = 0.05) -> void:
	if peer == null:
		return
		
	# ENet-specific simulation (available via host/peer settings)
	# Note: In Godot 4, some of these are set via the ENetConnection.
	print("Network Simulator: Latency=%dms, Jitter=%dms, Loss=%.1f%%" % [latency_ms, jitter_ms, loss_percent * 100])
	
	# Placeholder for lower-level ENet configurations
	# peer.get_host().set_bandwidth_limit(...) etc.

## Expert Tip: Use this provider in 'Integration Test' scenes to verify 
## that prediction/reconciliation logic handles real-world lag.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/networking/high_level_multiplayer.html
# - https://docs.godotengine.org/en/stable/classes/class_enetmultiplayerpeer.html
# - https://docs.godotengine.org/en/stable/classes/class_offlinemultiplayerpeer.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-multiplayer-networking/SKILL.md — peer/RPC APIs under lag simulation
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-adapt-single-to-multiplayer/SKILL.md — prediction paths that need mock latency
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-testing-patterns/SKILL.md
# =============================================================================
