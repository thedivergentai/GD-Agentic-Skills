class_name CompDataDrivenConfig
extends Node

## Expert Resource-driven Component configuration.
## Allows behavior to be hot-swapped via .tres files.

@export var config: Resource

func _ready() -> void:
	if config:
		_apply_config()

func _apply_config() -> void:
	# Pattern: Access properties from the Resource.
	# Example: parent.speed = config.movement_speed
	pass

## Rule: Decouple 'Values' (Resource) from 'Logic' (Component).

# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_exports.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md — .tres configs for hot-swap behavior
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md — resource folder conventions
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-composition-apps/SKILL.md
# =============================================================================
