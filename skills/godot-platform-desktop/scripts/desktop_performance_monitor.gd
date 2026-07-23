class_name DesktopPerformanceMonitor
extends Node

## Expert OS-level hardware monitoring for PC deployments.
## Used to auto-detect hardware and suggest graphics presets.

func get_hardware_info() -> Dictionary:
	return {
		"cpu": OS.get_processor_name(),
		"ram_total_mb": OS.get_static_memory_usage() / 1024 / 1024, # Current usage
		"gpu": RenderingServer.get_video_adapter_name(),
		"is_sandboxed": OS.is_sandboxed_app()
	}

func suggest_preset() -> StringName:
	# Simplified logic for demonstration
	var gpu = RenderingServer.get_video_adapter_name().to_lower()
	if "rtx" in gpu or "rx 6" in gpu:
		return &"ultra"
	return &"balanced"
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_os.html
# - https://docs.godotengine.org/en/stable/tutorials/rendering/multiple_resolutions.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md — apply suggested graphics presets
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — validate presets with profilers
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-platform-desktop/SKILL.md
# =============================================================================
