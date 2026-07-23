## Subsystem Locator Pattern (Autoload: Subsystems)
## A decoupled alternative to monolithic managers.
## Allows systems to register themselves without requiring hard-coded paths.
extends Node

var _registry: Dictionary = {}

func register(id: StringName, instance: Node) -> void:
	_registry[id] = instance
	print("Subsystem Registered: ", id)

func unregister(id: StringName) -> void:
	_registry.erase(id)

func get_system(id: StringName) -> Node:
	return _registry.get(id)

## Usage Example:
## Subsystems.get_system(&"Inventory").add_item(loot)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/best_practices/autoloads_versus_regular_nodes.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-autoload-architecture/SKILL.md — locator vs Managed Autoload tradeoffs
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-composition/SKILL.md — register scene modules without God objects
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-templates/SKILL.md
# =============================================================================
