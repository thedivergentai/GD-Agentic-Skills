# performance_benchmark_runner.gd
# Measuring execution time exactly
extends Node

# EXPERT NOTE: Benchmarking in Godot should use 
# Time.get_ticks_usec() for microsecond precision.

func benchmark_loop_performance():
	var start = Time.get_ticks_usec()
	
	for i in 1000000:
		var x = i * i
		
	var duration = Time.get_ticks_usec() - start
	print("Execution took: ", duration, " microseconds")
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_performance.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/debug/custom_performance_monitors.html
# - https://docs.godotengine.org/en/stable/classes/class_time.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md — budgets these micro-benches guard
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — profiler correlation when benches regress
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-testing-patterns/SKILL.md
# =============================================================================
