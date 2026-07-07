# audit_memory_fragmentation.gd
# Expert runtime utility for tracking ObjectDB allocations and detecting fragmentation risks.
# Grounded in Godot 4.7+ ObjectDB snapshots.

extends RefCounted

class_name MemoryFragmentationAuditor

## Captures a snapshot of current memory metrics and object counts.
static func capture_metrics() -> Dictionary:
	var metrics := {}
	metrics["total_objects"] = Performance.get_monitor(Performance.OBJECT_COUNT)
	metrics["node_count"] = Performance.get_monitor(Performance.OBJECT_NODE_COUNT)
	metrics["resource_count"] = Performance.get_monitor(Performance.OBJECT_RESOURCE_COUNT)
	metrics["memory_static"] = Performance.get_monitor(Performance.MEMORY_STATIC)
	metrics["memory_static_max"] = Performance.get_monitor(Performance.MEMORY_STATIC_MAX)
	return metrics

## Detects spikes in short-lived allocations by comparing two snapshots.
static func audit_fragmentation(snap_a: Dictionary, snap_b: Dictionary) -> String:
	var report := "=== Memory Fragmentation Audit ===\n"
	
	var obj_diff = snap_b["total_objects"] - snap_a["total_objects"]
	var mem_diff = snap_b["memory_static"] - snap_a["memory_static"]
	
	if obj_diff > 1000:
		report += "[WARNING] High Object spike detected: +%d objects\n" % obj_diff
		report += "Possible Cause: Short-lived instances not being pooled.\n"
	
	if mem_diff > 1024 * 1024 * 10: # 10MB
		report += "[WARNING] High Static Memory spike: +%.2f MB\n" % (mem_diff / 1024.0 / 1024.0)
		report += "Possible Cause: Large resource leaks or unmanaged arrays.\n"
		
	if report == "=== Memory Fragmentation Audit ===\n":
		report += "[PASS] Memory delta within acceptable stability thresholds.\n"
		
	return report

## Expert tip: In Godot 4.7, use the ObjectDB Profiler in the Debugger tab 
## to take visual snapshots and diff them for deep fragmentation analysis.
