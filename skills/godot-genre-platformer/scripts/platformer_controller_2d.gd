extends CharacterBody2D
class_name ExpertPlatformerController

## Expert Platformer Physics (Godot 4.7).
## Implements Coyote Time and Jump Buffering for perfect feel.

@export var speed: float = 300.0
@export var jump_velocity: float = -400.0
@export var coyote_time: float = 0.15
@export var jump_buffer: float = 0.15

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var _coyote_timer: float = 0.0
var _buffer_timer: float = 0.0

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		_coyote_timer += delta
	else:
		_coyote_timer = 0.0

	# Handle Jump Buffer
	if Input.is_action_just_pressed("jump"):
		_buffer_timer = jump_buffer
	
	_buffer_timer -= delta

	# Handle Jump logic
	if _buffer_timer > 0 and _coyote_timer < coyote_time:
		velocity.y = jump_velocity
		_buffer_timer = 0
		_coyote_timer = coyote_time # Consume coyote time

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = lerpf(velocity.x, direction * speed, 0.2)
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()

## [SKILL NOTICE]: Use 'lerpf' for movement smoothing and 'move_and_slide()' 
## for standard CharacterBody2D interaction. Time-based buffering is mandatory.
