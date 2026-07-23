# stack_trace_logger.gd
# Capturing the execution path on failure
extends Node

# EXPERT NOTE: get_stack() provides a programmatic 
# check of where a logic error originated.

func log_problem(msg: String):
	var stack = get_stack()
	printerr("PROBLEM: ", msg)
	for frame in stack:
		printerr(" -> ", frame.source, ":", frame.line, " in ", frame.function)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/debug/overview_of_debugging_tools.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/logging.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md — get_stack / print_stack usage
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — trace unexpected emit callers
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md
# =============================================================================
