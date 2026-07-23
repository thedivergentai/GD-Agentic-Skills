# custom_monitor_profiler.gd
# Monitoring performance bottlenecks in real-time
extends Label

# EXPERT NOTE: Use Performance.get_monitor to create 
# custom debug overlays that catch regression during play.

func _process(_delta):
	text = "FPS: %d\n" % Engine.get_frames_per_second()
	text += "Draw Calls: %d\n" % Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME)
	text += "Static Memory: %s\n" % String.humanize_size(Performance.get_monitor(Performance.MEMORY_STATIC))
	text += "Objects: %d\n" % Performance.get_monitor(Performance.OBJECT_COUNT)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_performance.html
# - https://docs.godotengine.org/en/stable/tutorials/performance/general_optimization.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-autoload-architecture/SKILL.md — singleton monitor service pattern
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md — Debugger Monitors tab workflow
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md
# =============================================================================
