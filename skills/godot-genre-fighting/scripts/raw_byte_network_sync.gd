# raw_byte_network_sync.gd
# Bypassing RPCs for low-level rollback UDP packets
extends Node

# EXPERT NOTE: send_bytes() with UNRELIABLE mode is the 
# fastest way to transmit raw input frames.

func send_input_frame(frame_data: PackedByteArray):
	if multiplayer.has_multiplayer_peer():
		multiplayer.multiplayer_peer.put_packet(frame_data)

func _on_packet_received(data: PackedByteArray):
	# Parse raw bytes directly into the rollback buffer
	_handle_input_data(data)

func _handle_input_data(_d): pass
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_enetmultiplayerpeer.html
# - https://docs.godotengine.org/en/stable/classes/class_packetpeerudp.html
# - https://docs.godotengine.org/en/stable/tutorials/networking/high_level_multiplayer.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-multiplayer-networking/SKILL.md — UDP/ENet input exchange
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-adapt-single-to-multiplayer/SKILL.md — late-join and lobby sync
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-fighting/SKILL.md
# =============================================================================
