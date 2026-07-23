# additive_ui_layering.gd
# Managing multiple UI layouts without replacing the whole scene
extends Node

# EXPERT NOTE: Don't change the entire scene for just a menu. 
# Load UI scenes as children of a persistent 'UI' node.

func open_menu(path: String):
	var scene = load(path).instantiate()
	add_child(scene)
	# Pause game logic if it's a pause menu
	get_tree().paused = true

func close_menu(menu: Node):
	menu.queue_free()
	get_tree().paused = false
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/best_practices/scene_organization.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/pausing_games.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/nodes_and_scene_instances.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md — menu scenes as children of a persistent UI root
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-autoload-architecture/SKILL.md — PROCESS_MODE_ALWAYS UI while tree is paused
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-scene-management/SKILL.md
# =============================================================================
