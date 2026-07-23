# high_precision_benchmarker.gd
# Measuring execution time with microsecond precision
extends Node

# EXPERT NOTE: Milliseconds lack the precision for microbenchmarking;
# always use Time.get_ticks_usec() for CPU cycle measurements.

func benchmark_operation(callable: Callable):
	var begin := Time.get_ticks_usec()
	callable.call()
	var end := Time.get_ticks_usec()
	print("Operation took %d microseconds" % (end - begin))
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_time.html
# - https://docs.godotengine.org/en/stable/tutorials/performance/cpu_optimization.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md — turn usec deltas into fixes
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md — timed balance sim loops
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md
# =============================================================================
