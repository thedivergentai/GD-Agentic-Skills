# hitbox_component.gd
# Safe type-casting for combat detections
extends Area2D
class_name HitboxComponent

# EXPERT NOTE: Using 'as' keyword prevents runtime crashes 
# if a non-combat node enters the area.

func _on_area_entered(area: Area2D):
	var health = area as HealthComponent
	if health:
		health.damage(10)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/physics/using_area_2d.html — area_entered hit detect
# - https://docs.godotengine.org/en/stable/classes/class_area2d.html — safe 'as' cast to HealthComponent
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-combat-system/SKILL.md — hitbox/hurtbox pairing
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-composition/SKILL.md — HitboxComponent sibling pattern
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-action-rpg/SKILL.md
# =============================================================================
