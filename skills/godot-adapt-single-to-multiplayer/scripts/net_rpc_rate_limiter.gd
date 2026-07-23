class_name NetRPCRateLimiter
extends Node

## Expert RPC Rate Limiting.
## Prevents malicious clients from flooding the server with expensive calls.

var rpc_timers: Dictionary = {}

func is_rate_limited(peer_id: int, rpc_name: String, limit_ms: float = 50.0) -> bool:
	var key = str(peer_id) + "_" + rpc_name
	var now = Time.get_ticks_msec()
	
	if rpc_timers.has(key) and (now - rpc_timers[key]) < limit_ms:
		return true
		
	rpc_timers[key] = now
	return false

## Tip: Use this for 'Fire', 'Reload', or 'Interact' RPCs to block macro users.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/networking/high_level_multiplayer.html
# - https://docs.godotengine.org/en/stable/classes/class_multiplayerapi.html
# - https://docs.godotengine.org/en/stable/classes/class_multiplayerpeer.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-multiplayer-networking/SKILL.md — RPC channel and reliability choices
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-shooter-fps/SKILL.md — fire/reload RPC spam surfaces
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-adapt-single-to-multiplayer/SKILL.md
# =============================================================================
