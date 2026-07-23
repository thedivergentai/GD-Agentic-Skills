class_name NetUPNPDiscoveryLogic
extends Node

## Expert UPNP & Local Discovery.
## Automates port forwarding and local peer discovery for P2P play.

func setup_upnp(port: int) -> void:
	var upnp = UPNP.new()
	var error = upnp.discover()
	
	if error == OK:
		if upnp.get_gateway() and upnp.get_gateway().is_valid_gateway():
			upnp.add_port_mapping(port)
			print("UPNP: Port %d forwarded successfully." % port)
	else:
		printerr("UPNP: Discovery failed with error %d" % error)

## Tip: Local discovery can be handled via 'PacketPeerUDP' broadcasting on the local subnet.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_upnp.html
# - https://docs.godotengine.org/en/stable/tutorials/networking/index.html
# - https://docs.godotengine.org/en/stable/classes/class_enetmultiplayerpeer.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-multiplayer-networking/SKILL.md — LAN discovery alternatives
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-export-builds/SKILL.md — firewall/export notes for listen servers
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-adapt-single-to-multiplayer/SKILL.md
# =============================================================================
