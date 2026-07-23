class_name HSMConcurrentLogic
extends Node

## Expert Orchestrator for concurrent state machines.
## Runs multiple state machines in parallel (e.g., Locomotion + Status Effects).

@onready var locomotion_sm := $LocomotionSM
@onready var status_sm := $StatusSM

func update_all(delta: float) -> void:
	locomotion_sm.physics_update(delta)
	status_sm.physics_update(delta)

## Rule: Ensure parallel machines don't conflict over the same actor properties.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/idle_and_physics_processing.html
# - https://docs.godotengine.org/en/stable/tutorials/best_practices/scene_organization.html
# - https://docs.godotengine.org/en/stable/tutorials/best_practices/logic_preferences.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-composition/SKILL.md — parallel SMs as sibling components under one orchestrator
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-combat-system/SKILL.md — locomotion + status effect machines without property fights
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-state-machine-advanced/SKILL.md
# =============================================================================
