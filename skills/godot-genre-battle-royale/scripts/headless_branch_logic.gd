# headless_branch_logic.gd
# Dedicated server pathing for battle royale hosts
extends Node

# EXPERT NOTE: Dedicated servers must skip UI and input 
# and use optimized physics drivers (Dummy).

func _ready():
	if DisplayServer.get_name() == "headless":
		_server_init()
	else:
		_client_init()

func _server_init():
	# Configure server-only timers or state update rates
	multiplayer.peer_connected.connect(_on_peer_connected)
	print("Dedicated Server active for Battle Royale session.")

func _on_peer_connected(id): pass
func _client_init(): pass
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/editor/command_line_tutorial.html
# - https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_dedicated_servers.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-export-builds/SKILL.md — dedicated server export presets
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-server-architecture/SKILL.md — headless feature branching
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-battle-royale/SKILL.md
# =============================================================================
