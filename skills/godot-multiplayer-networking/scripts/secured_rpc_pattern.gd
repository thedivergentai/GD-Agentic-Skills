# secured_rpc_pattern.gd
# Communication between peers with authority checks
extends Node

# EXPERT NOTE: ALWAYS use any_peer or authority explicitly. 
# NEVER trust client data without server-side validation.

@rpc("any_peer", "call_remote", "reliable")
func request_player_action(action_id: String):
	# Only the server should process authoritative logic
	if not multiplayer.is_server(): return
	
	var sender_id = multiplayer.get_remote_sender_id()
	# Validate if player 'sender_id' can perform 'action_id'
	print("Server processing action from: ", sender_id)
	_broadcast_result.rpc(action_id)

@rpc("authority", "call_local", "reliable")
func _broadcast_result(action_id: String):
	# Everyone (including server itself) updates their local state
	pass
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/networking/high_level_multiplayer.html
# - https://docs.godotengine.org/en/stable/classes/class_multiplayerapi.html
# - https://docs.godotengine.org/en/stable/classes/class_node.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — keep local events separate from RPCs
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md — typed @rpc annotations and sender checks
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-multiplayer-networking/SKILL.md
# =============================================================================
