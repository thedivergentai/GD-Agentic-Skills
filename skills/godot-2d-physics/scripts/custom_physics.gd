# skills/2d-physics/code/custom_physics.gd
extends RigidBody2D

## Deterministic Solver & Custom Gravity Pattern
## Demonstrates _integrate_forces for absolute control over physics state.

@export var custom_gravity_scale := 1.0
@export var local_gravity_center: Node2D

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
    # --- 1. Custom Movement Math ---
    # Override velocity directly while remaining in the physics solver
    # This prevents 'jitter' compared to manual position changes
    
    var current_vel := state.linear_velocity
    # Apply custom dampening or acceleration
    # current_vel.x = move_toward(current_vel.x, target_speed, accel * state.step)
    
    # --- 2. Localized Gravity Fields ---
    if local_gravity_center:
        var dir := global_position.direction_to(local_gravity_center.global_position)
        var force := dir * 9.8 * custom_gravity_scale
        state.apply_central_force(force)
        
    # --- 3. Deterministic Stop ---
    if should_stop_instantly():
        state.linear_velocity = Vector2.ZERO
        state.angular_velocity = 0

func should_stop_instantly() -> bool:
    return false

## EXPERT NOTE:
## Always use 'state.step' for delta-consistency in _integrate_forces.
## This function is called during the physics synchronization phase, 
## making it the correct place for custom physics engines or character controllers
## that require RigidBody interactions without the 'floatiness' of default physics.

# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/physics/rigid_body.html
# - https://docs.godotengine.org/en/stable/classes/class_physicsdirectbodystate2d.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-characterbody-2d/SKILL.md — when to prefer CharacterBody vs RigidBody
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md — _integrate_forces state.step discipline
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-2d-physics/SKILL.md
# =============================================================================
