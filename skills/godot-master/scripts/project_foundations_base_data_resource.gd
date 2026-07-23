@icon("res://icons/data_resource.svg")
class_name BaseDataResource
extends Resource

## Reactive Resource foundation for scalability.
## Centralizes data-driven triggers by emitting changed signals on property setters.

@export_group("Identity")
@export var id: StringName
@export var display_name: String = "New Item"

@export_group("Statistics")
@export var base_value: float = 1.0:
	set(v):
		base_value = v
		emit_changed()

@export var metadata: Dictionary = {}:
	set(v):
		metadata = v
		emit_changed()

## Deep duplicate helper to ensure nested resources are truly decoupled
func clone() -> BaseDataResource:
	return self.duplicate(true)

## Expert Tip: Always emit_changed() when modifying custom lists or internal states
## to ensure UI components or other listeners can react to the Resource change.
func update_metadata(key: String, value: Variant) -> void:
	metadata[key] = value
	emit_changed()
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html
# - https://docs.godotengine.org/en/stable/classes/class_resource.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md — catalogs, duplication, and emit_changed conventions
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — Resource.changed vs domain EventBus events
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md
# =============================================================================
