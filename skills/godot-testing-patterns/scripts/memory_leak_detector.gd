# memory_leak_detector.gd
# Capturing object count regressions
extends Node

# EXPERT NOTE: A sudden spike in Performance.OBJECT_COUNT 
# usually indicates nodes or resources that aren't being 
# freed correctly (orphans).

func _process(_delta):
	if Input.is_action_just_pressed("ui_focus_next"):
		var orphans = Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT)
		if orphans > 0:
			print_rich("[color=red]ORPHAN NODES DETECTED: [/color]", orphans)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_performance.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/debug/objectdb_profiler.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — ObjectDB/orphan investigation
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md — leak cost in long sessions
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-testing-patterns/SKILL.md
# =============================================================================
