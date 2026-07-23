# custom_debug_draw.gd
# Visualizing AI paths and physics bounds in 2D
extends Node2D

# EXPERT NOTE: Use _draw() to visualize non-visual data. 
# Redrawing every frame allows tracking moving targets.

var path: PackedVector2Array = []

func _draw():
	if not OS.is_debug_build(): return
	if path.size() < 2: return
	
	draw_polyline(path, Color.CYAN, 3.0, true)

func _process(_delta):
	queue_redraw()
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/debug/overview_of_debugging_tools.html
# - https://docs.godotengine.org/en/stable/classes/class_node.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-raycasting-queries/SKILL.md — visualize query results
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-navigation-pathfinding/SKILL.md — path/debug overlays
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md
# =============================================================================
