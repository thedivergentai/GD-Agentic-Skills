class_name NetLANDiscovery
extends Node

## Expert LAN Discovery (UDP Broadcast).
## Allows peers to find local servers without external master servers.

const BROADCAST_PORT = 12345
var udp := PacketPeerUDP.new()

func _ready() -> void:
	udp.bind(BROADCAST_PORT)

func broadcast_presence(server_name: String) -> void:
	udp.set_dest_address("255.255.255.255", BROADCAST_PORT)
	udp.put_packet(server_name.to_utf8_buffer())

func _process(_delta) -> void:
	if udp.get_available_packet_count() > 0:
		var packet = udp.get_packet()
		var msg = packet.get_string_from_utf8()
		# Add to local server list...

## Rule: UDP broadcasting is for LAN only. For Internet discovery, use an external Web API bridge.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_packetpeerudp.html
# - https://docs.godotengine.org/en/stable/classes/class_udpserver.html
# - https://docs.godotengine.org/en/stable/tutorials/networking/index.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-platform-desktop/SKILL.md — LAN co-op desktop defaults
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-autoload-architecture/SKILL.md — discovery Autoload lifecycle
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-multiplayer-networking/SKILL.md
# =============================================================================
