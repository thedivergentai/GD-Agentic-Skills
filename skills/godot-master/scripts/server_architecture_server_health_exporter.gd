class_name ServerHealthExporter
extends Node

## Exports server telemetry and performance metrics for external monitoring (Prometheus/Grafana).
## Runs automatically in headless/dedicated server mode.

@export var export_interval: float = 10.0 # Seconds

func _ready() -> void:
	# Only run on dedicated/headless servers to save client resources
	if DisplayServer.get_name() != "headless":
		queue_free()
		return
	
	var timer = Timer.new()
	timer.wait_time = export_interval
	timer.autostart = true
	timer.timeout.connect(_export_metrics)
	add_child(timer)

func _export_metrics() -> void:
	var metrics = {
		"timestamp": Time.get_unix_time_from_system(),
		"performance": {
			"fps": Performance.get_monitor(Performance.TIME_FPS),
			"process": Performance.get_monitor(Performance.TIME_PROCESS),
			"physics_process": Performance.get_monitor(Performance.TIME_PHYSICS_PROCESS),
			"static_memory": Performance.get_monitor(Performance.MEMORY_STATIC),
			"objects": Performance.get_monitor(Performance.OBJECT_COUNT),
			"nodes": Performance.get_monitor(Performance.OBJECT_NODE_COUNT),
			"orphan_nodes": Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT)
		},
		"network": {
			"peers": multiplayer.get_peers().size(),
			"bandwidth_in": _get_enet_bandwidth_in(),
			"bandwidth_out": _get_enet_bandwidth_out()
		}
	}
	
	# Print to standard output in JSON format for scraping tools like Filebeat or Promtail
	print("METRICS_DUMP:" + JSON.stringify(metrics))

func _get_enet_bandwidth_in() -> float:
	var peer = multiplayer.multiplayer_peer
	if peer is ENetMultiplayerPeer:
		# Note: ENet doesn't expose raw bandwidth easily in high-level API, 
		# but you can track it via custom packet counting.
		return 0.0 
	return 0.0

func _get_enet_bandwidth_out() -> float:
	return 0.0

# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_performance.html
# - https://docs.godotengine.org/en/stable/classes/class_displayserver.html
# - https://docs.godotengine.org/en/stable/classes/class_enetmultiplayerpeer.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — Performance monitors and headless telemetry habits
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md — act on FPS/memory/orphan signals from exporters
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-server-architecture/SKILL.md
# =============================================================================
