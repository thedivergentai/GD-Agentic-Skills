@tool
extends EditorScript

## Expert Version Syncing.
## Pulls latest Git tag/hash and injects it into 'project.godot'.

func _run() -> void:
	var output = []
	var exit_code = OS.execute("git", ["describe", "--always", "--tags"], output)
	
	if exit_code == 0:
		var version_str = output[0].strip_edges()
		ProjectSettings.set_setting("application/config/version", version_str)
		ProjectSettings.save()
		print("Project version synced to Git: ", version_str)
	else:
		printerr("Git sync failed. Ensure 'git' is in the system PATH.")

## Rule: Automate versioning during export to ensure build traceability.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_projectsettings.html
# - https://docs.godotengine.org/en/stable/tutorials/export/exporting_projects.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md — application/config/version ownership
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md — EditorScript tooling patterns
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-export-builds/SKILL.md
# =============================================================================
