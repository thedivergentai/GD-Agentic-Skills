# autoload_reference_checker.gd
# Validating singleton availability before access
extends Node

# EXPERT NOTE: Using 'get_node("/root/Name")' is safer than using the 
# global name if you code for packages/plugins that might lack the Autoload.

static func get_events(tree: SceneTree) -> Node:
	var path = "/root/GlobalEvents"
	if tree.root.has_node(path):
		return tree.root.get_node(path)
	push_warning("GlobalEvents Autoload not found!")
	return null
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/scene_tree.html
# - https://docs.godotengine.org/en/stable/classes/class_node.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md — optional Autoload names for plugins
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-testing-patterns/SKILL.md — null-safe getters in tests without full registry
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md — NodePath / get_node_or_null patterns
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-autoload-architecture/SKILL.md
# =============================================================================
