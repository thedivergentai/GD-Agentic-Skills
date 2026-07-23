class_name BaseActor
extends CharacterBody2D # or CharacterBody3D

## Template foundation for all gameplay agents (Player, NPC, Enemies).
## Enforces a consistent lifecycle for state transitions and combat.

signal state_changed(new_state: StringName)
signal damaged(amount: int, source: Node)

@export var actor_name: String = "Agent"
@export var faction: StringName = &"neutral"

var current_state: StringName = &"idle"

func _physics_process(delta: float) -> void:
	_process_logic(delta)

## Virtual: Override for AI or input logic
func _process_logic(_delta: float) -> void:
	pass

## Expert Tip: Use a dedicated method for damage to centralize logging and effects
func take_damage(amount: int, source: Node = null) -> void:
	damaged.emit(amount, source)
	_on_damage_received(amount, source)

func _on_damage_received(_amount: int, _source: Node) -> void:
	pass
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/nodes_and_scene_instances.html
# - https://docs.godotengine.org/en/stable/tutorials/best_practices/scene_organization.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md — virtual hooks and typed signals on base entities
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-state-machine-advanced/SKILL.md — actor state_changed paired with FSM nodes
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-templates/SKILL.md
# =============================================================================
