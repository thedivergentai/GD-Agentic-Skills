# purge_report_generator.gd
# Expert utility to identify "slop" (unfreed objects/nodes) and generate a prioritized cleanup report.
# Grounded in Godot 4.x expert patterns (Node.get_orphan_node_ids).

extends RefCounted

class_name PurgeReportGenerator

## Generates a detailed report of all orphan nodes currently in memory.
static func generate_report() -> String:
	var report := "=== GODOT PURGE REPORT (Slop Detection) ===\n"
	report += "Timestamp: %s\n\n" % Time.get_datetime_string_from_system()
	
	var orphan_ids := Node.get_orphan_node_ids()
	
	if orphan_ids.is_empty():
		report += "[PASS] No orphan nodes detected. Architectural purity maintained.\n"
		return report
	
	report += "[FAIL] Detected %d orphan nodes!\n" % orphan_ids.size()
	report += "These nodes are taking up memory but are not in the SceneTree.\n"
	report += "Prioritized Cleanup List:\n"
	report += "-------------------------------------------\n"
	
	# Priority 1: Large Node Trees (if we could check size)
	# For now, we list them all.
	for id in orphan_ids:
		var obj = instance_from_id(id)
		if obj is Node:
			var node := obj as Node
			report += "- [PRIORITY HIGH] Node: %s (Type: %s) [ID: %d]\n" % [node.name, node.get_class(), id]
			if not node.get_script() == null:
				report += "  Script: %s\n" % node.get_script().get_path()
		else:
			report += "- [PRIORITY MED] Object [ID: %d]\n" % id
			
	report += "-------------------------------------------\n"
	report += "RECOMMENDATION: Ensure all nodes are freed using queue_free() or added to the SceneTree.\n"
	report += "Common Culprit: Singletons creating nodes but never parenting them.\n"
	
	return report

## Prints the report directly to the console.
static func print_report() -> void:
	print(generate_report())
	# Also use native debug print for direct debugger output
	Node.print_orphan_nodes()
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/debug/objectdb_profiler.html
# - https://docs.godotengine.org/en/stable/classes/class_performance.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — orphan node confirmation in Debugger
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md — unused preload / dependency hygiene
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-scene-management/SKILL.md — free or reparent nodes before scene swap
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md
# =============================================================================
