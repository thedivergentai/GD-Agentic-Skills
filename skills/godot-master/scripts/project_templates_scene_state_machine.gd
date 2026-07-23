class_name SceneStateMachine
extends Node

## Node-based State Machine boilerplate.
## Delegates engine callbacks (_physics_process, _input) from parent to active state.

@export var initial_state: StateMachineNode
@onready var current_state: StateMachineNode = initial_state

func _ready() -> void:
	# Auto-register this machine into all child states
	for child in get_children():
		if child is StateMachineNode:
			child.state_machine = self
	
	if current_state:
		current_state.enter()

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)

func _unhandled_input(event: InputEvent) -> void:
	if current_state:
		current_state.handle_input(event)

func transition_to(target_name: StringName) -> void:
	if not has_node(str(target_name)):
		push_error("StateMachine: State %s not found." % target_name)
		return
		
	current_state.exit()
	current_state = get_node(str(target_name))
	current_state.enter()
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/scene_tree.html
# - https://docs.godotengine.org/en/stable/tutorials/inputs/inputevent.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-state-machine-advanced/SKILL.md — production FSM transitions beyond node-child boilerplate
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md — unhandled_input and physics_update wiring
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-templates/SKILL.md
# =============================================================================
