@tool
extends EditorScript

## Expert Asset Re-import Utility (Godot 4.7).
## Programmatically enforces 'Lossless' compression for PNGs across the project.

func _run() -> void:
	print("\n--- [BUILDER] Starting Asset Pipeline Re-import ---")
	var to_reimport: PackedStringArray = []
	_process_dir("res://", to_reimport)
	
	if not to_reimport.is_empty():
		print("Reimporting %d files..." % to_reimport.size())
		# Thread-safe reimport that keeps Editor UI responsive
		EditorInterface.get_resource_filesystem().reimport_files(to_reimport)
	
	print("--- Asset Pipeline Complete ---\n")

func _process_dir(path: String, out_list: PackedStringArray) -> void:
	var dir := DirAccess.open(path)
	if not dir: return
	
	dir.list_dir_begin()
	var file_name := dir.get_next()
	while file_name != "":
		var full := path.path_join(file_name)
		if dir.current_is_dir():
			if not file_name.begins_with("."):
				_process_dir(full, out_list)
		elif file_name.get_extension() == "png":
			if _force_lossless(full):
				out_list.append(full)
		file_name = dir.get_next()

func _force_lossless(path: String) -> bool:
	var import_path := path + ".import"
	if not FileAccess.file_exists(import_path): return false
	
	var config := ConfigFile.new()
	if config.load(import_path) == OK:
		var current = config.get_value("params", "compress/mode", -1)
		if current != 0: # 0 = Lossless
			config.set_value("params", "compress/mode", 0)
			config.save(import_path)
			return true
	return false

## [SKILL NOTICE]: reimport_files() safely blocks the script while 
## pumping the main loop to prevent Windows "Not Responding" freezes.

# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_editorfilesystem.html
# - https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/import_process.html
# - https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/importing_images.html
# - https://docs.godotengine.org/en/stable/classes/class_configfile.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-export-builds/SKILL.md — enforce lossless/ASTC before shipping
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md — batch reimport vs ad-hoc editor clicks
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-builder/SKILL.md
# =============================================================================
