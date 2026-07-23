# scene_tree_dump.gd
# Debugging orphan nodes and tree bloat
extends Node

# EXPERT NOTE: Use print_tree_pretty() to see a snapshot 
# of the current active hierarchy in the terminal.

func log_tree_state():
	print_rich("[color=yellow]--- SCENE TREE DUMP ---[/color]")
	get_tree().root.print_tree_pretty()
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_node.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/debug/debugger_panel.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-scene-management/SKILL.md — tree bloat after scene swaps
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-composition/SKILL.md — unexpected component node counts
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md
# =============================================================================
