class_name NetPacketRateLimiter
extends Node

## Expert Packet Rate Limiter.
## Protects server against malicious clients flooding RPCs.

@export var max_packets_per_sec: int = 60
var peer_buckets: Dictionary = {} # PeerID: Count

func check_rate(peer_id: int) -> bool:
	peer_buckets[peer_id] = peer_buckets.get(peer_id, 0) + 1
	if peer_buckets[peer_id] > max_packets_per_sec:
		print("Peer %d Kicked for Flooding" % peer_id)
		multiplayer.multiplayer_peer.disconnect_peer(peer_id)
		return false
	return true

func _on_timer_reset() -> void:
	peer_buckets.clear()

## Rule: Always rate-limit unauthenticated pings and movement packets to prevent DDoS-lite.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_multiplayerapi.html
# - https://docs.godotengine.org/en/stable/tutorials/networking/high_level_multiplayer.html
# - https://docs.godotengine.org/en/stable/classes/class_multiplayerpeer.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-server-architecture/SKILL.md — server-side flood protection
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — spot RPC spam vs legit traffic
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-multiplayer-networking/SKILL.md
# =============================================================================
