# status_effect_component.gd
# Managing temporary modifiers via composition
class_name StatusEffectComponent extends Node

# EXPERT NOTE: Stacking status effects as children allows for 
# easy management of durations and overlapping logic.

func apply_effect(effect_scene: PackedScene):
	var effect = effect_scene.instantiate()
	add_child(effect)
	# Effect script handles its own timer and removal
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/getting_started/step_by_step/instancing.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/nodes_and_scene_instances.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ability-system/SKILL.md — buff/debuff scenes as stacked child effect instances
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md — effect PackedScene/Resource definitions
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-composition/SKILL.md
# =============================================================================
