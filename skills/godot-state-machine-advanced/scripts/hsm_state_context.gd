class_name HSMStateContext
extends RefCounted

## Expert pattern: Decoupled State Context.
## Passes dependencies through states without global singletons.

var actor: CharacterBody3D
var target: Node3D
var blackboards: Dictionary = {}

func _init(p_actor: CharacterBody3D) -> void:
	actor = p_actor

## Rule: Pass this context object to every state's 'enter' method.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_refcounted.html
# - https://docs.godotengine.org/en/stable/classes/class_characterbody3d.html
# - https://docs.godotengine.org/en/stable/tutorials/best_practices/autoloads_versus_regular_nodes.html
# - https://docs.godotengine.org/en/stable/tutorials/best_practices/data_preferences.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-composition/SKILL.md — inject actor/target deps instead of GameManager singletons
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md — keep tunables in Resources; context holds runtime refs
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-state-machine-advanced/SKILL.md
# =============================================================================
