# modular_dlc_loader.gd
# Expert pattern for mounting external .pck files (DLC/Mods) at runtime.
# Grounded in Godot 4.x ProjectSettings.load_resource_pack.

extends Node

class_name ModularDLCLoader

## Loads a resource pack (.pck or .zip) into the virtual filesystem.
static func load_dlc(path: String, replace_files: bool = true) -> bool:
	if not FileAccess.file_exists(path):
		push_error("DLC Loader: File not found at %s" % path)
		return false
		
	# Mount the PCK
	var success = ProjectSettings.load_resource_pack(path, replace_files)
	if success:
		print("DLC Loader: Successfully mounted %s" % path)
	else:
		push_error("DLC Loader: Failed to mount %s" % path)
		
	return success

## Scans a folder for DLC packs and loads them all.
static func load_all_dlc_in_folder(folder_path: String) -> void:
	var dir = DirAccess.open(folder_path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".pck"):
				load_dlc(folder_path + "/" + file_name)
			file_name = dir.get_next()
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/export/exporting_pcks.html
# - https://docs.godotengine.org/en/stable/tutorials/io/data_paths.html
# - https://docs.godotengine.org/en/stable/classes/class_projectsettings.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-export-builds/SKILL.md — building and signing PCK packs for DLC
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-scene-management/SKILL.md — loading scenes after pack mount overrides
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-templates/SKILL.md
# =============================================================================
