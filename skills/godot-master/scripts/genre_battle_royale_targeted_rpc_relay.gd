# targeted_rpc_relay.gd
# Communicating with specific peers to reduce traffic
extends Node

# EXPERT NOTE: Global broadcasts are wasteful. Use rpc_id(1) 
# for client->server and rpc_id(peer_id) for server->specific_client.

@rpc("any_peer", "call_local", "reliable")
func talk_to_server(msg: String):
	if multiplayer.is_server():
		print("Client says: ", msg)

func send_private_message(peer_id: int, secret: String):
	_receive_private.rpc_id(peer_id, secret)

@rpc("authority", "call_remote", "reliable")
func _receive_private(_s): pass
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/networking/high_level_multiplayer.html
# - https://docs.godotengine.org/en/stable/classes/class_scenemultiplayer.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-multiplayer-networking/SKILL.md — rpc_id interest targeting
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md — cut broadcast bandwidth
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-battle-royale/SKILL.md
# =============================================================================
