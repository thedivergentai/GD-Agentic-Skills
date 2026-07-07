extends Node
class_name WorldOriginShifter

## Expert Origin Shifting (Godot 4.7).
## Resets world origin to (0,0,0) to prevent jitter.

@export var world_root: Node3D
@export var player: Node3D
@export var threshold: float = 8192.0 # 32-bit float safe limit

var total_offset: Vector3 = Vector3.ZERO

func _physics_process(_delta: float) -> void:
	if player.global_position.length() > threshold:
		_perform_shift()

func _perform_shift() -> void:
	var shift = -player.global_position
	total_offset += shift
	
	# Shift world root and update physics interpolation
	world_root.global_position += shift
	player.global_position += shift
	player.reset_physics_interpolation()
	
	# Sync shaders (Global Uniforms)
	RenderingServer.global_shader_parameter_set("world_offset", total_offset)

## [SKILL NOTICE]: Use 'reset_physics_interpolation()' during 
## origin shifts to prevent 1-frame visual 'streaking' or 'warping'.
