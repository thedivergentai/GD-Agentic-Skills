# hierarchical_state_base.gd
extends Node
class_name HierarchicalStateBase

# Hierarchical State Machine Base
# Modular base for complex RPG AI and Player state logic.

@export var initial_state: Node
@onready var current_state: Node = initial_state

func _physics_process(delta: float) -> void:
    # Pattern: Delegate the tick to the active specialized state script.
    if current_state and current_state.has_method(&"physics_tick"):
        current_state.physics_tick(delta)

func transition(target_path: NodePath, params: Dictionary = {}) -> void:
    var next_state = get_node_or_null(target_path)
    if not next_state: return
    
    if current_state.has_method(&"on_exit"):
        current_state.on_exit()
        
    current_state = next_state
    
    if current_state.has_method(&"on_enter"):
        current_state.on_enter(params)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/idle_and_physics_processing.html — physics_tick delegation
# - https://docs.godotengine.org/en/stable/tutorials/best_practices/scene_organization.html — state children under owner
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-state-machine-advanced/SKILL.md — hierarchical ARPG AI/player FSM
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-characterbody-2d/SKILL.md — movement states under physics
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-action-rpg/SKILL.md
# =============================================================================
