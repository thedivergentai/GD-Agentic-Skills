class_name NetDebugOverlayMonitor
extends CanvasLayer

## Expert Network Debug Monitor.
## Displays real-time RTT, Packet Loss, and Jitter.

@onready var label = $Label

func _process(_delta: float) -> void:
	var peer = multiplayer.multiplayer_peer as ENetMultiplayerPeer
	if not peer or peer.get_connection_status() != MultiplayerPeer.CONNECTION_CONNECTED:
		return
	
	# Note: ENet provides statistics per peer
	var stats = "Network Stats:\n"
	stats += "RTT: %dms\n" % peer.get_peer(1).get_statistic(ENetPacketPeer.PEER_ROUND_TRIP_TIME)
	stats += "Loss: %d%%\n" % peer.get_peer(1).get_statistic(ENetPacketPeer.PEER_PACKET_LOSS)
	
	label.text = stats

## Rule: Always provide a network overlay during alpha/beta testing to catch ISP-routing issues.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_multiplayerpeer.html
# - https://docs.godotengine.org/en/stable/classes/class_enetmultiplayerpeer.html
# - https://docs.godotengine.org/en/stable/tutorials/networking/high_level_multiplayer.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — overlay placement and remote debug
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md — CanvasLayer HUD layout for stats
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-adapt-single-to-multiplayer/SKILL.md
# =============================================================================
