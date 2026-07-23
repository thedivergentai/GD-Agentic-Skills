class_name CompOrchestratorBase
extends Node

## Expert Orchestrator Pattern.
## Job: Wire components together. Math/Logic = 0%, State Management = 100%.

## Minimal two-component wiring: Component A signals UP → Orchestrator calls DOWN on Component B.

signal orchestrator_ready

@export var component_a: CompBaseComponent
@export var component_b: CompBaseComponent

func _ready() -> void:
	_connect_components()
	orchestrator_ready.emit()

func _connect_components() -> void:
	if component_a and component_b:
		if not component_a.task_completed.is_connected(_on_component_a_completed):
			component_a.task_completed.connect(_on_component_a_completed)

func _on_component_a_completed(result: Variant) -> void:
	# Signal UP from A → call DOWN on B (siblings never talk directly).
	if component_b and component_b.has_method(&"apply_result"):
		component_b.apply_result(result)

## Rule: Siblings must NEVER talk directly. Always signal UP to Orchestrator.

# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/best_practices/scene_organization.html
# - https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — signal-up / call-down wiring without sibling calls
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-composition/SKILL.md — shared Orchestrator ownership model
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-composition-apps/SKILL.md
# =============================================================================
