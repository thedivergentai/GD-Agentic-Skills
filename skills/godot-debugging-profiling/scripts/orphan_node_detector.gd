# orphan_node_detector.gd
# Tracking nodes that were removed but never freed
extends Node

# EXPERT NOTE: OBJECT_ORPHAN_NODE_COUNT only works in debug builds.
# Use print_orphan_nodes() to dump the IDs for leak analysis.

func check_for_leaks():
	if not OS.is_debug_build(): return
	
	var orphans = Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT)
	if orphans > 0:
		print_rich("[color=red]Memory Leak: %d Orphan nodes detected![/color]" % orphans)
		Node.print_orphan_nodes()
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_performance.html
# - https://docs.godotengine.org/en/stable/classes/class_node.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/debug/objectdb_profiler.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-scene-management/SKILL.md — scene free vs orphan growth
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — retained connections keep nodes alive
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md
# =============================================================================
