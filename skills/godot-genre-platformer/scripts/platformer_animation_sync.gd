# platformer_animation_sync.gd
extends Node
class_name PlatformerAnimationSync

# State-Driven AnimationTree Sync
# Safely updates logic conditions for AnimationTree without negation operators.

@export var anim_tree: AnimationTree
@export var character: CharacterBody2D

func _physics_process(_delta: float) -> void:
    if not anim_tree or not character: return
    
    var is_moving := abs(character.velocity.x) > 10.0
    var is_in_air := not character.is_on_floor()
    
    # Pattern: Explicitly set booleans for logic-safe Advance Conditions.
    anim_tree.set("parameters/conditions/is_moving", is_moving)
    anim_tree.set("parameters/conditions/is_idle", not is_moving)
    anim_tree.set("parameters/conditions/is_airborne", is_in_air)
    anim_tree.set("parameters/conditions/is_on_ground", not is_in_air)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/animation/animation_tree.html
# - https://docs.godotengine.org/en/stable/classes/class_animationtree.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-animation-tree-mastery/SKILL.md — boolean conditions from physics state
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-2d-animation/SKILL.md — run/idle/air visual sync
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-platformer/SKILL.md
# =============================================================================
