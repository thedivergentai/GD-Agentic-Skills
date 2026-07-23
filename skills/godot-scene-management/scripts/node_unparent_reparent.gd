# node_unparent_reparent.gd
# Safely moving nodes between scene hierarchies
extends Node

# PROBLEM: Reparenting mid-frame can cause issues with 
# transform synchronization.

func reparent_node(node: Node, new_parent: Node):
	# Preserve global transform during reparenting
	var global_xform = node.global_transform if node is Node2D or node is Node3D else null
	
	node.get_parent().remove_child(node)
	new_parent.add_child(node)
	
	if global_xform:
		node.global_transform = global_xform
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_node.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/nodes_and_scene_instances.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/idle_and_physics_processing.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-composition/SKILL.md — move component nodes between parents without path breakage
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — reconnect listeners after reparent when paths change
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-scene-management/SKILL.md
# =============================================================================
