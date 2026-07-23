# headless_init_manager.gd
# Detecting and initializing dedicated server environments
extends Node

# EXPERT NOTE: DisplayServer.get_name() returns "headless" 
# only if the binary was launched with the --headless argument.

func _ready():
	if DisplayServer.get_name() == "headless" or OS.has_feature("dedicated_server"):
		print_rich("[color=green]DEDICATED SERVER DETECTED[/color]")
		_start_server_logic()

func _start_server_logic():
	# Configure server-specific singletons or physics speeds
	Engine.max_fps = 60 # Servers don't need high FPS, but need stability

# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/editor/command_line_tutorial.html
# - https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_dedicated_servers.html
# - https://docs.godotengine.org/en/stable/classes/class_displayserver.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-export-builds/SKILL.md — dedicated-server export presets for headless hosts
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-multiplayer-networking/SKILL.md — start multiplayer peer after headless detect
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-server-architecture/SKILL.md
# =============================================================================
