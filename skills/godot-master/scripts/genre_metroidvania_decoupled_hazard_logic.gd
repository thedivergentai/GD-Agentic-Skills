# decoupled_hazard_logic.gd
extends Area2D
class_name DecoupledHazardLogic

# Decoupled Hazard Damage (Duck Typing Pattern)
# Interacts with colliding bodies safely without strict class requirements.

@export var damage_value: int = 15

func _on_body_entered(body: Node) -> void:
    # Safely checks if the body has a combat/health component method.
    if body.has_method(&"take_damage"):
        # Pattern: Pass damage and optional source metadata.
        body.take_damage(damage_value)
    elif body.has_method(&"on_hazard_collision"):
        body.on_hazard_collision(self)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/physics/using_area_2d.html
# - https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-2d-physics/SKILL.md — Area2D hazard layers and masks
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-composition/SKILL.md — duck-typed take_damage components
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-metroidvania/SKILL.md
# =============================================================================
