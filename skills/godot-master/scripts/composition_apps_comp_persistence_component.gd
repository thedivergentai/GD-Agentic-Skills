class_name CompPersistenceComponent
extends Node

## Expert Persistence Component.
## Automatically registers the Orchestrator for saving.

func _ready() -> void:
	add_to_group("Saveable")

func get_save_data() -> Dictionary:
	# Orchestrator calls this to collect state
	return {}

## Rule: Keep save logic in a component to easily add/remove persistence to any node.

# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/groups.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-save-load-systems/SKILL.md — Saveable group collection patterns
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md — serializable state dictionaries
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-composition-apps/SKILL.md
# =============================================================================
