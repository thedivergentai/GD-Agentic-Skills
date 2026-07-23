# server_authority_validator.gd
# Validating client requests at the entry point
extends Node

# EXPERT NOTE: RPC authority checks are the first line of defense. 
# Use get_remote_sender_id() to identify and validate peers.

@rpc("any_peer", "call_local", "reliable")
func commit_transaction(item_id: String, amount: int):
	if not multiplayer.is_server(): return
	
	var peer_id = multiplayer.get_remote_sender_id()
	if _can_afford(peer_id, amount):
		_apply_transaction(peer_id, item_id, amount)
	else:
		_notify_error.rpc_id(peer_id, "Insufficient funds")

@rpc("authority", "call_remote", "reliable")
func _notify_error(msg: String): pass

func _can_afford(id, amt): return true
func _apply_transaction(id, item, amt): pass

# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/networking/high_level_multiplayer.html
# - https://docs.godotengine.org/en/stable/classes/class_multiplayerapi.html
# - https://docs.godotengine.org/en/stable/classes/class_node.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-multiplayer-networking/SKILL.md — authority/RPC patterns for validated actions
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md — economy checks after authority rules change TTK
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-server-architecture/SKILL.md
# =============================================================================
