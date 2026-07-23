class_name HSMPushdownStack
extends Node

## Expert Pushdown Automata implementation.
## Manages a state stack for interrupt-resume behaviors (e.g., Stun, Pause, Menu).

var state_stack: Array[Node] = []

func push_state(state_path: String, msg: Dictionary = {}) -> void:
	var new_state := get_node(state_path)
	if not new_state: return
	
	if not state_stack.is_empty():
		state_stack.back().exit()
	
	state_stack.append(new_state)
	new_state.enter(msg)

func pop_state() -> void:
	if state_stack.size() <= 1: return # Keep initial state
	
	var old_state := state_stack.pop_back()
	old_state.exit()
	
	if not state_stack.is_empty():
		state_stack.back().enter({"is_resume": true})

## Tip: Use 'is_resume' in 'enter()' to avoid re-triggering one-shot entry animations.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/scene_tree.html
# - https://docs.godotengine.org/en/stable/classes/class_node.html
# - https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-dialogue-system/SKILL.md — push dialogue/cutscene overlays then pop back to gameplay
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-scene-management/SKILL.md — pause/menu stacks must survive scene ownership rules
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-state-machine-advanced/SKILL.md
# =============================================================================
