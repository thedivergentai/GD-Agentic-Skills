# fps_movement_logic.gd
extends CharacterBody3D
class_name FPSMovementLogic

# Smooth FPS Movement with Acceleration & Friction
# Handles responsive WASD movement using vector interpolation.

@export var max_speed := 8.0
@export var accel := 10.0
@export var friction := 15.0
@export var gravity := 20.0

func _physics_process(delta: float) -> void:
    var input_dir := Input.get_vector(&"move_left", &"move_right", &"move_forward", &"move_back")
    
    # Convert input to direction relative to player rotation.
    var direction := (global_transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
    
    if is_on_floor():
        if direction != Vector3.ZERO:
            velocity.x = move_toward(velocity.x, direction.x * max_speed, accel * delta)
            velocity.z = move_toward(velocity.z, direction.z * max_speed, accel * delta)
        else:
            velocity.x = move_toward(velocity.x, 0.0, friction * delta)
            velocity.z = move_toward(velocity.z, 0.0, friction * delta)
    else:
        # Gravity is an acceleration: Scale by delta.
        velocity.y -= gravity * delta
        
    # Pattern: Delta is applied inside move_and_slide() automatically.
    move_and_slide()
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_characterbody3d.html
# - https://docs.godotengine.org/en/stable/tutorials/3d/using_transforms.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-input-handling/SKILL.md - Input.get_vector move basis
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md - InputMap action names for walk/sprint
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-shooter-fps/SKILL.md
# =============================================================================
