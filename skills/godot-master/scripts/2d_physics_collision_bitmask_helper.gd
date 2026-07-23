# Collision Bitmask Helper
extends Node

## Managing bitmasks logically instead of hardcoding integers.
## Use constants and shift operators to keep complex faction systems readable.

enum Faction { NONE = 0, PLAYER = 1, ENEMY = 2, PROJECTILE = 3, WORLD = 4 }

func setup_actor_collision(node: CollisionObject2D, faction: Faction) -> void:
    # Clear current layers and masks
    node.collision_layer = 0
    node.collision_mask = 0
    
    # Set layer (What am I?)
    node.set_collision_layer_value(faction, true)
    
    # Set mask (What do I hit?)
    match faction:
        Faction.PLAYER:
            node.set_collision_mask_value(Faction.ENEMY, true)
            node.set_collision_mask_value(Faction.WORLD, true)
        Faction.PROJECTILE:
            node.set_collision_mask_value(Faction.ENEMY, true)
            node.set_collision_mask_value(Faction.PLAYER, true)

# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/physics/physics_introduction.html
# - https://docs.godotengine.org/en/stable/classes/class_collisionobject2d.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md — enum/bitshift readability for masks
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-combat-system/SKILL.md — faction layer conventions for hitboxes
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-2d-physics/SKILL.md
# =============================================================================
