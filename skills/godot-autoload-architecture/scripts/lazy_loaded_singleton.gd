# lazy_loaded_singleton.gd
# Creating "Autoloads" on demand to save memory
extends Node

# EXPERT NOTE: If a singleton is rarely used, don't put it in 
# Project Settings. Load it manually when needed.

static var _instance: Node = null

static func get_instance(tree: SceneTree) -> Node:
	if not is_instance_valid(_instance):
		_instance = load("res://systems/heavy_system.tscn").instantiate()
		tree.root.add_child(_instance)
	return _instance
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/best_practices/autoloads_versus_regular_nodes.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/nodes_and_scene_instances.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/scene_tree.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md — defer heavy systems until first use
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md — preload vs load tradeoffs
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-scene-management/SKILL.md — root.add_child lifecycle
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-autoload-architecture/SKILL.md
# =============================================================================
