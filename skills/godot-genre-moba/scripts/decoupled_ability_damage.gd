# decoupled_ability_damage.gd
extends Area2D
class_name DecoupledAbilityDamage

# Safe Duck-Typing for Ability Damage
# Interacts with target heroes/entities without hard class coupling.

@export var damage_amount: int = 50

func _on_body_entered(body: Node) -> void:
    # Pattern: Check if method exists before calling.
    # Allows projectiles to hit minions, heroes, and buildings interchangeably.
    if body.has_method(&"take_damage"):
        body.take_damage(damage_amount)
        _on_hit_confirmed()

func _on_hit_confirmed() -> void:
    # Handle projectile destruction or effects.
    queue_free()
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/physics/physics_introduction.html
# - https://docs.godotengine.org/en/stable/tutorials/physics/ray-casting.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-combat-system/SKILL.md — take_damage duck-typing
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ability-system/SKILL.md — skill-shot hitboxes
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-moba/SKILL.md
# =============================================================================
