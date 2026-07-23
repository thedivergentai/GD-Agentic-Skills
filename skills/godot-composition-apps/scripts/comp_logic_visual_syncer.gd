class_name CompLogicVisualSyncer
extends Node

## Expert pattern: Logic vs Visual Separation.
## Synchronizes a VisualComponent (VFX/Anim) to a LogicComponent.

@export var logic: Node
@export var visuals: Node

func _ready() -> void:
	if logic.has_signal("state_changed"):
		logic.state_changed.connect(_on_logic_state_changed)

func _on_logic_state_changed(new_state: String) -> void:
	if visuals.has_method("play_animation"):
		visuals.play_animation(new_state)

## Rule: Never let 'MovementLogic' know 'AnimationPlayer' exists. Use this syncer.

# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html
# - https://docs.godotengine.org/en/stable/tutorials/best_practices/scene_organization.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-theming/SKILL.md — visual response without logic knowing Theme/Anim
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — logic state_changed → visual play
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-composition-apps/SKILL.md
# =============================================================================
