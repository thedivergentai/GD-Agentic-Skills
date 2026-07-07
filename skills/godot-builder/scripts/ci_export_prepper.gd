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
