class_name CompBaseComponent
extends Node

## Expert Base Component.
## Job: Encapsulate a single responsibility. Must work "on a rock".

signal task_completed(result: Variant)

func _ready() -> void:
	# Optional: Register to a group for mass orchestration
	add_to_group("Components")

## Rule: NEVER use 'get_parent()' to access data. Use signals or dependency injection.

# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/best_practices/what_are_godot_classes.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/groups.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-composition/SKILL.md — single-responsibility component base
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md — typed signals and class_name components
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-composition-apps/SKILL.md
# =============================================================================
