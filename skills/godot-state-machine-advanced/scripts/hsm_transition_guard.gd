class_name HSMTransitionGuard
extends Node

## Expert transition validation logic.
## Prevents illegal state changes using 'can_enter'/'can_exit' checks.

func can_transition(from: Node, to: Node) -> bool:
	# Example: Prevent jumping while floating or dead
	if to.name == "JumpState" and not from.has_method("is_grounded"):
		return false
	
	# Transition validation logic...
	return true

## Rule: Centralize transition logic in the StateMachine, not the individual states.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/best_practices/logic_preferences.html
# - https://docs.godotengine.org/en/stable/classes/class_node.html
# - https://docs.godotengine.org/en/stable/tutorials/best_practices/scene_organization.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md — typed can_enter/can_exit predicates without stringly spaghetti
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ability-system/SKILL.md — cast/channel guards mirror ability precondition checks
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-state-machine-advanced/SKILL.md
# =============================================================================
