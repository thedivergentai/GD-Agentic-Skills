# interaction_component.gd
# Handling contextual logic via Callable injection
class_name InteractionComponent extends Area2D

# EXPERT NOTE: Instead of a massive 'match' statement, the parent 
# injects the specific interaction logic into this component.

var interaction_logic: Callable

func interact() -> void:
	if interaction_logic.is_valid():
		interaction_logic.call()
	else:
		push_warning("InteractionComponent on %s has no logic defined!" % owner.name)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_callable.html
# - https://docs.godotengine.org/en/stable/classes/class_area2d.html
# - https://docs.godotengine.org/en/stable/tutorials/best_practices/logic_preferences.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md — Callable injection instead of giant match tables
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — parent can bind interact handlers with context
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-composition/SKILL.md
# =============================================================================
