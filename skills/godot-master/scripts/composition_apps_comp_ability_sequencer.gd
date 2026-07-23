class_name CompAbilitySequencer
extends Node

## Expert Ability Orchestrator.
## Manages child 'Ability' nodes and their activation sequence.

func cast_ability(ability_name: String) -> void:
	var ability = get_node_or_null(ability_name)
	if ability and ability.has_method("execute"):
		ability.execute()

## Rule: Adding new skills is as simple as adding a new child node with a script.

# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/best_practices/scene_organization.html
# - https://docs.godotengine.org/en/stable/tutorials/best_practices/godot_interfaces.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ability-system/SKILL.md — child Ability nodes with execute()
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-state-machine-advanced/SKILL.md — cast sequencing beside FSM states
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-composition-apps/SKILL.md
# =============================================================================
