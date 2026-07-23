class_name HSMHierarchicalBase
extends Node

## Expert Hierarchical State Machine (HSM) base delegator.
## Propagates physics, input, and updates to the active child state.

var current_state: Node = null

func _physics_process(delta: float) -> void:
	if current_state and current_state.has_method("physics_update"):
		current_state.physics_update(delta)

func _input(event: InputEvent) -> void:
	if current_state and current_state.has_method("handle_input"):
		current_state.handle_input(event)

func transition_to(new_state_path: String, msg: Dictionary = {}) -> void:
	if not has_node(new_state_path): return
	
	if current_state:
		current_state.exit()
	
	current_state = get_node(new_state_path)
	current_state.enter(msg)

## Rule: Always delegate processing to children to ensure hierarchical encapsulation.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/idle_and_physics_processing.html
# - https://docs.godotengine.org/en/stable/classes/class_node.html
# - https://docs.godotengine.org/en/stable/classes/class_inputevent.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/scene_tree.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-composition/SKILL.md — HSM root as a composed StateComponent under the actor
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-input-handling/SKILL.md — forward sampled actions into handle_input on the active child
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-state-machine-advanced/SKILL.md
# =============================================================================
