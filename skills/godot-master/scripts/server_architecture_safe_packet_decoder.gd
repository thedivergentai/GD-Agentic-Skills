# safe_packet_decoder.gd
# Preventing RCE vulnerabilities in network serialization
extends Node

# EXPERT NOTE: NEVER pass true to get_var/set_var on untrusted data. 
# Object decoding allows a client to trigger arbitrary code.

func process_untrusted_packet(packet_peer: PacketPeerUDP):
	if packet_peer.get_available_packet_count() > 0:
		# EXPERT: Passing 'false' forbids Object decoding, preventing RCE.
		var data: Variant = packet_peer.get_var(false)
		_handle_data(data)

func _handle_data(data: Variant): pass

# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/io/binary_serialization_api.html
# - https://docs.godotengine.org/en/stable/classes/class_packetpeer.html
# - https://docs.godotengine.org/en/stable/classes/class_packetpeerudp.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-multiplayer-networking/SKILL.md — apply same no-object-decode rule to custom RPCs
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-adapt-single-to-multiplayer/SKILL.md — validate untrusted client payloads at authority
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-server-architecture/SKILL.md
# =============================================================================
