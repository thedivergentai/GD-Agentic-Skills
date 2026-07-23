# custom_collision_slider.gd
extends CharacterBody2D
class_name CustomCollisionSlider

# Custom Collision Slide Response
# Manual calculation of sliding response for high-speed or non-standard physics.

func _physics_process(delta: float) -> void:
    # Use move_and_collide for manual control.
    var collision := move_and_collide(velocity * delta)
    if collision:
        # Expert Pattern: Manually slide along the normal to prevent sticking.
        velocity = velocity.slide(collision.get_normal())
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/physics/using_character_body_2d.html
# - https://docs.godotengine.org/en/stable/classes/class_kinematiccollision2d.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-characterbody-2d/SKILL.md — move_and_collide manual slide
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-2d-physics/SKILL.md — high-speed collision response
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-platformer/SKILL.md
# =============================================================================
