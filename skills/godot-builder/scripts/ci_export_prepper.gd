#!/usr/bin/env -S godot -s
extends SceneTree

## Expert CI/CD Export Prepper (Godot 4.7).
## Headless script for versioning and build preparation.

func _init() -> void:
	print("[BUILD_PREP]: Mutating export_presets.cfg for CI...")
	
	var build_num := OS.get_environment("GITHUB_RUN_NUMBER")
	if build_num.is_empty(): build_num = "1.0.0"
	
	var config := ConfigFile.new()
	if config.load("res://export_presets.cfg") == OK:
		# Example: Mutate Preset 0 (Windows)
		config.set_value("preset.0.options", "application/file_version", build_num)
		config.set_value("preset.0.options", "application/product_version", build_num)
		config.save("res://export_presets.cfg")
		print("[BUILD_PREP]: Version set to: %s" % build_num)
	else:
		printerr("[BUILD_PREP]: Failed to load export_presets.cfg")
	
	quit() # MUST explicitly quit SceneTree for headless --script execution.

## [SKILL NOTICE]: Always run with --headless to prevent CI crashes 
## on servers without display drivers/GPUs.

# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/export/exporting_projects.html
# - https://docs.godotengine.org/en/stable/classes/class_configfile.html
# - https://docs.godotengine.org/en/stable/tutorials/editor/command_line_tutorial.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-export-builds/SKILL.md — which preset.N.options keys are safe to mutate
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md — keep export_presets.cfg VCS policy clear
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-builder/SKILL.md
# =============================================================================
