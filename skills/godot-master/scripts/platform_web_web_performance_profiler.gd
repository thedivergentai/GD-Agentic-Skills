class_name WebPerformanceProfiler
extends Node

## Expert performance profiler for WebGL/WebGPU.
## Logs memory and draw calls to the browser console.

func log_profle_data() -> void:
	if not OS.has_feature("web"): return
	
	var draw_calls := Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME)
	var memory := OS.get_static_memory_usage() / 1024 / 1024
	
	JavaScriptBridge.eval("console.log('Godot Performance | Draw Calls: %d | Memory: %dMB');" % [draw_calls, memory])

## Tip: Keep draw calls under 500 for stable 60FPS on mid-range mobile browsers.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/performance/gpu_optimization.html
# - https://docs.godotengine.org/en/stable/tutorials/performance/general_optimization.html
# - https://docs.godotengine.org/en/stable/classes/class_performance.html
# - https://docs.godotengine.org/en/stable/tutorials/rendering/renderers.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md — escalate WebGL budget misses
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-export-builds/SKILL.md — Compatibility + compression export gates
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-platform-web/SKILL.md
# =============================================================================
