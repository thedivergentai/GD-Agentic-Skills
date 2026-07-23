# dtls_secure_server.gd
# Encrypting ENet traffic using DTLS and certificates
extends Node

# EXPERT NOTE: DTLS provides encryption over UDP, 
# preventing man-in-the-middle attacks on sensitive data.

func secure_server(crypto_key: CryptoKey, cert: X509Certificate):
	var peer := ENetMultiplayerPeer.new()
	peer.create_server(7000)
	
	# Setting up the TLS/DTLS options for the host
	var server_options := TLSOptions.server(crypto_key, cert)
	peer.host.dtls_server_setup(server_options)
	
	multiplayer.multiplayer_peer = peer

# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_enetmultiplayerpeer.html
# - https://docs.godotengine.org/en/stable/classes/class_dtlsserver.html
# - https://docs.godotengine.org/en/stable/classes/class_tlsoptions.html
# - https://docs.godotengine.org/en/stable/classes/class_x509certificate.html
# - https://docs.godotengine.org/en/stable/tutorials/networking/ssl_certificates.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-multiplayer-networking/SKILL.md — secure transport before RPC game traffic
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-export-builds/SKILL.md — ship cert/key assets with dedicated-server builds
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-server-architecture/SKILL.md
# =============================================================================
