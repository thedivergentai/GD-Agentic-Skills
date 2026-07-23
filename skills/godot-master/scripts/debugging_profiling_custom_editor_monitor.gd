# custom_editor_monitor.gd
# Exposing game metrics to the Editor Debugger
extends Node

# EXPERT NOTE: add_custom_monitor lets you see game-specific
# bottlenecks (AI count, active projectiles) in the Monitors tab.

func _ready():
	Performance.add_custom_monitor("Game/ActiveProjectiles", _get_projectile_count)

func _get_projectile_count() -> int:
	return get_tree().get_nodes_in_group("Projectiles").size()
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/debug/custom_performance_monitors.html
# - https://docs.godotengine.org/en/stable/classes/class_performance.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md — act on custom monitor spikes
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-autoload-architecture/SKILL.md — register monitors from Autoload
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md
# =============================================================================
