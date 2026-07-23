# hurt_box_component.gd
# Area-based component for dealing damage to HitBoxes
class_name HurtBoxComponent extends Area2D

# EXPERT NOTE: Hurtboxes look for HitBoxComponents specifically, 
# rather than generic physics bodies, ensuring type safety.

@export var damage: float = 10.0

func _on_area_entered(area: Area2D) -> void:
	var hitbox = area as HitBoxComponent
	if hitbox:
		hitbox.handle_hit(damage)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_area2d.html
# - https://docs.godotengine.org/en/stable/tutorials/physics/physics_introduction.html
# - https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-2d-physics/SKILL.md — area_entered overlap rules for deal-damage volumes
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-combat-system/SKILL.md — typed HitBoxComponent cast keeps hurtboxes focused
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-composition/SKILL.md
# =============================================================================
