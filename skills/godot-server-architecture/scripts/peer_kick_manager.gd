# peer_kick_manager.gd
# Gracefully terminating peer connections
extends Node

# EXPERT NOTE: Disconnecting peers forcefully (disconnect_peer) 
# is cleaner than just erasing them from a list.

func remove_player(peer_id: int, reason: String):
	# Notify the peer first if possible
	_on_kicked.rpc_id(peer_id, reason)
	
	# Drop connection
	multiplayer.disconnect_peer(peer_id)
	print("Kicked peer ", peer_id, " for: ", reason)

@rpc("authority", "call_remote", "reliable")
func _on_kicked(reason: String):
	print("Disconnected by server: ", reason)

# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_multiplayerapi.html
# - https://docs.godotengine.org/en/stable/classes/class_multiplayerpeer.html
# - https://docs.godotengine.org/en/stable/tutorials/networking/high_level_multiplayer.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-multiplayer-networking/SKILL.md — disconnect/kick with lobby state cleanup
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — local kicked/disconnected events off transport
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-server-architecture/SKILL.md
# =============================================================================
