# server_state_buffer.gd
# Handling UDP packet jitter on the server
extends Node

# EXPERT NOTE: UDP packets lack sequence guarantees. 
# Buffer and sort state chunks using IDs to prevent stutter.

var buffer: Dictionary = {}

func push_state(peer_id: int, state_id: int, data: Dictionary):
	if !buffer.has(peer_id): buffer[peer_id] = []
	buffer[peer_id].append({"id": state_id, "data": data})
	
	# Sort by ID to ensure sequential processing
	buffer[peer_id].sort_custom(func(a, b): return a.id < b.id)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_multiplayerpeer.html
# - https://docs.godotengine.org/en/stable/tutorials/networking/high_level_multiplayer.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-multiplayer-networking/SKILL.md — jitter/out-of-order UDP handling
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-adapt-single-to-multiplayer/SKILL.md — tick-sorted state buffers
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-battle-royale/SKILL.md
# =============================================================================
