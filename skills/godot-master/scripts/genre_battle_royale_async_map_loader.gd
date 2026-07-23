# async_map_loader.gd
# Non-blocking map chunk streaming
extends Node

# EXPERT NOTE: BR maps are huge. Load sectors in background threads 
# to prevent frame drops during exploration.

func load_sector(path: String):
	ResourceLoader.load_threaded_request(path)

func _process(_delta):
	var progress = []
	var status = ResourceLoader.load_threaded_get_status("res://levels/sector_a.tscn", progress)
	if status == ResourceLoader.THREAD_LOAD_LOADED:
		var scene = ResourceLoader.load_threaded_get("res://levels/sector_a.tscn")
		_attach_sector(scene)

func _attach_sector(_s): pass
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/io/background_loading.html
# - https://docs.godotengine.org/en/stable/classes/class_resourceloader.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-world-building/SKILL.md — sector/chunk streaming for large maps
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md — avoid main-thread hitch on load
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-battle-royale/SKILL.md
# =============================================================================
