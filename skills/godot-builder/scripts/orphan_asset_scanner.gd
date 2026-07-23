@tool
extends EditorScript

## Expert Orphan Asset Scanner (Godot 4.7).
## Recursively traces dependencies to identify unused 'slop' resources.

var _used: Dictionary = {}
var _all: Dictionary = {}

func _run() -> void:
	print("\n--- [BUILDER] Starting Optimization Scan ---")
	_used.clear()
	_all.clear()
	
	# 1. Catalog all files
	_catalog_res("res://")
	
	# 2. Trace from Main Scene
	var main := ProjectSettings.get_setting("application/run/main_scene")
	if not main.is_empty():
		_trace(main)
	
	# 3. Report orphans
	var orphans := 0
	for path in _all:
		if not _used.has(path) and not path.ends_with(".import"):
			if not path.begins_with("res://.godot"):
				print("Orphan detected: %s" % path)
				orphans += 1
	
	print("Found %d orphaned assets." % orphans)
	print("--- Optimization Scan Complete ---\n")

func _trace(path: String) -> void:
	if _used.has(path): return
	_used[path] = true
	
	var deps := ResourceLoader.get_dependencies(path)
	for d in deps:
		var dep_path := d
		if d.contains("::"): dep_path = d.get_slice("::", 2)
		if dep_path.is_empty(): dep_path = d.get_slice("::", 0)
		_trace(dep_path)

func _catalog_res(path: String) -> void:
	var dir := DirAccess.open(path)
	if not dir: return
	
	dir.list_dir_begin()
	var f := dir.get_next()
	while f != "":
		var full := path.path_join(f)
		if dir.current_is_dir():
			if not f.begins_with("."): _catalog_res(full)
		else:
			_all[full] = true
		f = dir.get_next()

## [SKILL NOTICE]: ResourceLoader.get_dependencies() uses C++ parsers 
## to identify links without loading heavy textures into VRAM.

# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_resourceloader.html
# - https://docs.godotengine.org/en/stable/classes/class_projectsettings.html
# - https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/import_process.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md — export size after slop removal
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-export-builds/SKILL.md — keep export filters aligned with used deps
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md — main_scene must be set for tracing
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-builder/SKILL.md
# =============================================================================
