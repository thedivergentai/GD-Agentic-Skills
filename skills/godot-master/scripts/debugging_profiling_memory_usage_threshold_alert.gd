# memory_usage_threshold_alert.gd
# Catching memory bloat early
extends Node

# EXPERT NOTE: Monitor static memory and push a warning 
# if it exceeds a project-defined threshold.

const MEMORY_LIMIT_MB = 1024

func _physics_process(_delta):
	var usage_mb = Performance.get_monitor(Performance.MEMORY_STATIC) / 1024 / 1024
	if usage_mb > MEMORY_LIMIT_MB:
		push_warning("MEMORY USAGE HIGH: ", usage_mb, "MB")
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_performance.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/debug/objectdb_profiler.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md — memory leak remediation
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-scene-management/SKILL.md — free transient scenes on threshold
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md
# =============================================================================
