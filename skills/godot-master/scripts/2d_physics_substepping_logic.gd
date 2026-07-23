# Fixed Timestep Sub-stepping Logic
extends CharacterBody2D

## For extremely fast-moving objects (bullets), standard collision fails.
## Sub-stepping manually breaks the frame into smaller physics steps.

@export var velocity_per_second: Vector2 = Vector2(5000, 0)
@export var sub_steps: int = 4

func _physics_process(delta: float) -> void:
    var step_delta = delta / sub_steps
    for i in range(sub_steps):
        var collision = move_and_collide(velocity_per_second * step_delta)
        if collision:
            _handle_collision(collision)
            break

func _handle_collision(collision: KinematicCollision2D) -> void:
    print("Impact at: ", collision.get_position())
    queue_free()

# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/physics/using_character_body_2d.html
# - https://docs.godotengine.org/en/stable/tutorials/physics/troubleshooting_physics_issues.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-combat-system/SKILL.md — hyper-velocity projectile collision
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md — substep/CCD knobs change hit fairness
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-2d-physics/SKILL.md
# =============================================================================
