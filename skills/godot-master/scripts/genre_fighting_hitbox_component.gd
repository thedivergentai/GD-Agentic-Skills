# skills/genre-fighting/scripts/hitbox_component.gd
extends Area2D

## Hitbox Component Expert Pattern
## Modular hitbox/hurtbox system for fighting games.
## Separates data (Attack Resource) from logic.

class_name HitboxComponent

enum Type { HITBOX, HURTBOX, GRAB_BOX }

@export var type: Type = Type.HITBOX
@export var attack_data: Resource # Holds damage, frame data, knockback
@export_flags("Player", "Enemy") var target_team: int = 1

signal hit_confirmed(target: Node2D)
signal hurt_confirmed(attacker: Node2D, data: Resource)

func _ready() -> void:
    area_entered.connect(_on_area_entered)
    
    # Default state: disabled until animation frames enable it
    if type == Type.HITBOX:
        monitoring = false
        monitorable = true
    elif type == Type.HURTBOX:
        monitoring = true
        monitorable = true

func _on_area_entered(area: Area2D) -> void:
    if type == Type.HITBOX:
        # We hit someone
        if area is HitboxComponent and area.type == Type.HURTBOX:
            # Check team (simple mask comparison)
            # Assuming area owner has a 'team' property or we use flags
            _process_hit(area)

func _process_hit(hurtbox: HitboxComponent) -> void:
    # Notify myself
    hit_confirmed.emit(hurtbox.owner)
    
    # Notify them
    if hurtbox.has_signal("hurt_confirmed"):
        hurtbox.hurt_confirmed.emit(owner, attack_data)

## EXPERT USAGE:
## Attach to Fighter bone/sprite. Use AnimationPlayer to toggle 'monitoring'.
## When Hitbox enters Hurtbox, signals fire carrying 'attack_data'.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/physics/using_area_2d.html
# - https://docs.godotengine.org/en/stable/tutorials/physics/physics_introduction.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-combat-system/SKILL.md — hitbox/hurtbox DamageData contracts
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-2d-physics/SKILL.md — layers/masks for High/Low/Throw
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-fighting/SKILL.md
# =============================================================================
