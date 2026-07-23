# state_replication_unreliable.gd
# Synchronizing player transforms via unreliable streams
extends Node

# EXPERT NOTE: For 100 players, Reliable mode causes congestion. 
# ALWAYS use Unreliable/Unreliable Ordered for movement.

@rpc("authority", "call_remote", "unreliable")
func update_player_transform(p_id: int, pos: Vector3, rot: float):
	# Interpolate state on clients
	_on_peer_transform_sync(p_id, pos, rot)

func _on_peer_transform_sync(_id, _p, _r): pass
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_multiplayerpeer.html
# - https://docs.godotengine.org/en/stable/classes/class_multiplayersynchronizer.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-multiplayer-networking/SKILL.md — unreliable movement transfer modes
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-adapt-single-to-multiplayer/SKILL.md — snapshot interpolation shells
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-battle-royale/SKILL.md
# =============================================================================
