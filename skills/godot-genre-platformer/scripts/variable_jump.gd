# variable_jump.gd
extends Node
class_name VariableJump

# Variable Jump Height (Early Release Cutoff)
# Cuts upward momentum if the jump button is released mid-ascent.

@export var body: CharacterBody2D
@export var min_jump_velocity: float = -200.0

func _physics_process(_delta: float) -> void:
    # Pattern: Only cut if moving UP and button just released.
    if Input.is_action_just_released(&"jump") and body.velocity.y < min_jump_velocity:
        body.velocity.y = min_jump_velocity
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/physics/using_character_body_2d.html
# - https://docs.godotengine.org/en/stable/tutorials/inputs/input_examples.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-characterbody-2d/SKILL.md — cut upward velocity on release
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-input-handling/SKILL.md — jump just_released cutoff
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-platformer/SKILL.md
# =============================================================================
