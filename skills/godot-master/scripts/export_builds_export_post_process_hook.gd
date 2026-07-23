@tool
extends EditorExportPlugin

## Expert Post-Export Hook.
## Automates tasks like zipping or cleaning up files after a build finishes.

func _get_name() -> String:
	return "ExportPostProcessor"

func _export_end() -> void:
	# Note: Use OS.execute to trigger external zip tools or manifest generators.
	var build_path = get_option("export_path")
	print("Post-processing build at: ", build_path)
	
	# Logic to Zip files or notify Deployment Slack here...
	pass

## Rule: Use EditorExportPlugin to unify export workflows for all team members.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_editorexportplugin.html
# - https://docs.godotengine.org/en/stable/tutorials/export/exporting_projects.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md — EditorPlugin / export plugin APIs
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md — manifest/zip payload layout
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-export-builds/SKILL.md
# =============================================================================
