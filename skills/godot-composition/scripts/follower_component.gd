# follower_component.gd
# Decoupled tracking logic using NodePath injection
class_name FollowerComponent extends Node

# EXPERT NOTE: Using NodePath allows the component to be wired in 
# the inspector by the parent, keeping it context-aware but decoupled.

@export var target_path: NodePath
var target: Node2D

func _ready() -> void:
	if not target_path.is_empty():
		target = get_node(target_path)

func _process(delta: float) -> void:
	if is_instance_valid(target):
		owner.global_position = owner.global_position.lerp(target.global_position, 5.0 * delta)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_exports.html
# - https://docs.godotengine.org/en/stable/classes/class_node.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/scene_tree.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-scene-management/SKILL.md — re-resolve NodePath targets after scene swaps
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md — Inspector NodePath wiring for composition slots
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-composition/SKILL.md
# =============================================================================
