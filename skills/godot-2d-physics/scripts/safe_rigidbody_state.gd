# Safe RigidBody2D State Modification
extends RigidBody2D

## NEVER modify position or linear_velocity in _process or _physics_process.
## Use _integrate_forces for thread-safe access to the PhysicsDirectBodyState.

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
    # Example: Teleporting safely mid-collision
    if Input.is_action_just_pressed("teleport"):
        var new_transform = Transform2D(state.transform.get_rotation(), Vector2.ZERO)
        state.transform = new_transform
    
    # Example: Applying a custom impulse that overrides existing velocity
    if Input.is_action_just_pressed("jump"):
        state.linear_velocity.y = -500

# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/physics/rigid_body.html
# - https://docs.godotengine.org/en/stable/classes/class_physicsdirectbodystate2d.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md — never mutate RigidBody in _process
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-physics-3d/SKILL.md — parallel integrate_forces discipline in 3D
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-2d-physics/SKILL.md
# =============================================================================
