extends Node
class_name ProceduralRecoilHandler

## Expert Procedural Recoil (Godot 4.7).
## Framerate-independent camera kick and exponential return.

@export var camera_pivot: Node3D
@export var return_speed: float = 7.0
@export var snap_speed: float = 20.0

var _target_rot: Vector3
var _current_rot: Vector3

func fire_recoil(kick: Vector2) -> void:
	# Vector2(Pitch, Yaw)
	_target_rot += Vector3(kick.x, kick.y, 0)

func _process(delta: float) -> void:
	# Expert Pattern: Exponential smoothing for framerate independence
	_target_rot = _target_rot.lerp(Vector3.ZERO, return_speed * delta)
	_current_rot = _current_rot.lerp(_target_rot, snap_speed * delta)
	
	camera_pivot.rotation = _current_rot

## [SKILL NOTICE]: Use exponential 'lerp' for recoil return to ensure the 
## camera animation feels consistent at 30, 60, or 144 FPS.
