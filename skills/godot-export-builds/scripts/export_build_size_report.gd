@tool
extends EditorScript

## Expert Build Size Analyzer.
## Scans resources and identifies the largest contributors to build size.

func _run() -> void:
	var files = _get_all_files("res://")
	var sorted_files = []
	
	for f in files:
		var size = FileAccess.get_file_size(f)
		sorted_files.append({"path": f, "size": size})
		
	sorted_files.sort_custom(func(a, b): return a.size > b.size)
	
	print("--- Top 20 Largest Resources ---")
	for i in range(min(20, sorted_files.size())):
		var f = sorted_files[i]
		print("%s: %.2f MB" % [f.path, f.size / 1024.0 / 1024.0])

func _get_all_files(path: String) -> Array:
	var arr = []
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				arr.append_array(_get_all_files(path + file_name + "/"))
			else:
				arr.append(path + file_name)
			file_name = dir.get_next()
	return arr
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/export/exporting_projects.html
# - https://docs.godotengine.org/en/stable/tutorials/best_practices/project_organization.html
# - https://docs.godotengine.org/en/stable/engine_details/development/compiling/optimizing_for_size.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md — find oversized packed resources
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md — escalate when filters are not enough
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-export-builds/SKILL.md
# =============================================================================
