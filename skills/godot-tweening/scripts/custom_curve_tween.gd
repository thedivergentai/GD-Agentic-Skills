# custom_curve_tween.gd
# Driving property animations using visual Curve resources
extends Node2D

@export var bounce_curve: Curve

# EXPERT NOTE: For juice, avoid standard TransTypes and use a 
# Curve resource for total control over the easing profile.

func juice_impact():
	var tween = create_tween()
	# The scale will follow the visual curve exactly
	tween.tween_property(self, "scale", Vector2(1.5, 1.5), 0.6)\
		.set_custom_interpolator(func(v): return bounce_curve.sample(v))
	
	tween.chain().tween_property(self, "scale", Vector2.ONE, 0.2)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_propertytweener.html
# - https://docs.godotengine.org/en/stable/classes/class_curve.html
# - https://docs.godotengine.org/en/stable/tutorials/math/beziers_and_curves.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md — export Curve juice profiles as Resources
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-2d-animation/SKILL.md — when Curve juice beats authored clips
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-tweening/SKILL.md
# =============================================================================
