# state_component_vsm.gd
# Component-based state machine pattern
class_name StateComponent extends Node

# EXPERT NOTE: Each state is a child node. The parent component 
# manages transitions between them.

signal state_changed(new_state: String)

var current_state: Node = null

func transition_to(state_name: String) -> void:
	var next_state = get_node_or_null(state_name)
	if next_state:
		if current_state: current_state.exit()
		current_state = next_state
		current_state.enter()
		state_changed.emit(state_name)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html
# - https://docs.godotengine.org/en/stable/tutorials/best_practices/scene_organization.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/scene_tree.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-state-machine-advanced/SKILL.md — child-node states with enter/exit transitions
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — state_changed fans out to visuals/AI listeners
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-composition/SKILL.md
# =============================================================================
