# duck_typed_hitbox.gd
extends Area3D
class_name DuckTypedHitbox

# Duck-Typing Hitboxes for Loose Coupling
# Processes combat hits without requiring specific target class references.

@export var base_damage: float = 10.0

func _on_body_entered(body: Node3D) -> void:
    # Pattern: Check for method existence to support destructibles, actors, and props.
    if body.has_method(&"take_damage"):
        # We can pass dictionaries for complex RPG data (element, knockback).
        body.take_damage({
            "amount": base_damage,
            "source": get_parent(),
            "element": &"physical"
        })
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/physics/physics_introduction.html — Area overlap for hits
# - https://docs.godotengine.org/en/stable/classes/class_area3d.html — body_entered duck-typed damage
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-combat-system/SKILL.md — DamageData dictionaries
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-composition/SKILL.md — hitboxes without class hard-coupling
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-action-rpg/SKILL.md
# =============================================================================
