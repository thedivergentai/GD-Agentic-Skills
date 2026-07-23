# hit_box_component.gd
# Area-based component for intercepting damage
class_name HitBoxComponent extends Area2D

# EXPERT NOTE: Hitboxes delegate damage to a HealthComponent. 
# This decouples the collision shape from the health logic.

@export var health_component: HealthComponent

func handle_hit(damage: float) -> void:
	if health_component:
		health_component.take_damage(damage)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_area2d.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_exports.html
# - https://docs.godotengine.org/en/stable/tutorials/best_practices/scene_organization.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-2d-physics/SKILL.md — Area2D monitoring layers for receive-hit volumes
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-combat-system/SKILL.md — hit reception delegates into HealthComponent
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-composition/SKILL.md
# =============================================================================
