# arcade_vehicle_controller.gd
extends CharacterBody3D
class_name ArcadeVehicleController

# Raycast-Based Arcade Vehicle Controller
# Predictable, tight steering and suspension without the complexity of VehicleBody3D.

@export var engine_force := 40.0
@export var steering_limit := 0.4
@export var suspension_rest_dist := 0.5
@export var suspension_stiffness := 30.0
@export var suspension_damping := 2.0

func _physics_process(delta: float) -> void:
    var input_dir = Input.get_vector(&"move_left", &"move_right", &"move_forward", &"move_back")
    
    # Steering
    rotation.y -= input_dir.x * steering_limit * delta * (velocity.length() * 0.1)
    
    # Simple Engine Acceleration
    var forward_dir = -global_transform.basis.z
    velocity += forward_dir * input_dir.y * engine_force * delta
    
    # Friction/Drag
    velocity *= 0.98
    
    move_and_slide()
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_characterbody3d.html
# - https://docs.godotengine.org/en/stable/tutorials/physics/ray-casting.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-physics-3d/SKILL.md — CharacterBody3D arcade kart motion
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-input-handling/SKILL.md — analog steer without VehicleBody
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-racing/SKILL.md
# =============================================================================
