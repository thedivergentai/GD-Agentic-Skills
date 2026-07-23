# push_error_safe_exit.gd
# Reporting errors without crashing the engine
extends Node

# EXPERT NOTE: push_error() sends to the Godot console 
# and debugger without stopping execution like assert().

func load_critical_config(path: String):
	if not FileAccess.file_exists(path):
		push_error("CRITICAL CONFIG MISSING: ", path)
		# Fallback to default avoid crash
		return _generate_default_config()
	
	return load(path)

func _generate_default_config():
	return {}
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/debug/output_panel.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/logging.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md — push_error vs assert semantics
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-save-load-systems/SKILL.md — soft-fail config/save IO
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md
# =============================================================================
