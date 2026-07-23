class_name NetHeadlessServerAutoStart
extends Node

## Expert Dedicated Server Entry Point.
## Auto-detects --headless mode and initializes server.

func _ready() -> void:
	if OS.has_feature("dedicated_server") or DisplayServer.get_name() == "headless":
		_start_dedicated_server()

func _start_dedicated_server() -> void:
	print("Auto-Starting Dedicated Server...")
	var port = 7777
	# Handle CLI arguments: --port=9999
	for arg in OS.get_cmdline_args():
		if arg.begins_with("--port="):
			port = arg.split("=")[1].to_int()
	
	# Init Net Logic...

## Rule: Always parse CLI arguments for port/map overrides in dedicated server builds.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/editor/command_line_tutorial.html
# - https://docs.godotengine.org/en/stable/classes/class_os.html
# - https://docs.godotengine.org/en/stable/classes/class_enetmultiplayerpeer.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-server-architecture/SKILL.md — CLI/feature-tag headless boot
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-export-builds/SKILL.md — dedicated-server packaging
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-multiplayer-networking/SKILL.md
# =============================================================================
