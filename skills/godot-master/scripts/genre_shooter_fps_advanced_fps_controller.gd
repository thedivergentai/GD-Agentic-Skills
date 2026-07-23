extends CharacterBody3D
class_name AdvancedFPSController

## Expert FPS Controller (Godot 4.7).
## Smooth movement with ground/air-aware interpolation and head-bob.

@export var walk_speed: float = 8.0
@export var air_control: float = 0.15 # Air acceleration multiplier
@export var head_bob_freq: float = 2.4
@export var head_bob_amp: float = 0.08

@onready var camera: Camera3D = %Camera3D

var _walk_time: float = 0.0

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= 19.6 * delta # Gravity
	
	var input_dir = Input.get_vector("move_left", "move_right", "move_fwd", "move_back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	# Expert Pattern: Higher lerp weight on ground for snappiness
	var weight = 10.0 if is_on_floor() else 10.0 * air_control
	velocity.x = lerp(velocity.x, direction.x * walk_speed, weight * delta)
	velocity.z = lerp(velocity.z, direction.z * walk_speed, weight * delta)
	
	move_and_slide()
	_apply_head_bob(delta, direction)

func _apply_head_bob(delta: float, direction: Vector3) -> void:
	if is_on_floor() and direction.length() > 0.1:
		_walk_time += delta * velocity.length()
		camera.transform.origin.y = sin(_walk_time * head_bob_freq) * head_bob_amp
	else:
		camera.transform.origin = camera.transform.origin.lerp(Vector3.ZERO, delta * 5.0)

## [SKILL NOTICE]: Use 'is_on_floor()' to switch between ground/air 
## interpolation weights. This prevents 'floaty' movement on the ground.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_characterbody3d.html
# - https://docs.godotengine.org/en/stable/tutorials/physics/physics_introduction.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-input-handling/SKILL.md - move axes and capture before air/ground lerp
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-camera-systems/SKILL.md - head-bob camera local offset composition
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-shooter-fps/SKILL.md
# =============================================================================
