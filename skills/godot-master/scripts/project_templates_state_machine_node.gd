class_name StateMachineNode
extends Node

## Abstract state node to be used inside a SceneStateMachine.
## Override these methods in specific state scenes/scripts.

var state_machine: SceneStateMachine

func enter() -> void:
	pass

func exit() -> void:
	pass

func physics_update(_delta: float) -> void:
	pass

func handle_input(_event: InputEvent) -> void:
	pass

## Expert: Call state_machine.transition_to(&"NewState") to switch.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/nodes_and_scene_instances.html
# - https://docs.godotengine.org/en/stable/tutorials/best_practices/godot_notifications.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-state-machine-advanced/SKILL.md — enter/exit/physics_update contract for specialized states
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md — abstract base methods and override discipline
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-templates/SKILL.md
# =============================================================================
