# framing_box_camera_2d.gd
class_name FramingBoxCamera2D
extends Camera2D
## Dynamically zooms and pans to frame multiple targets.

@export var targets: Array[Node2D] = []
@export var margin: float = 100.0
@export var min_zoom: float = 0.5
@export var max_zoom: float = 2.0

func _physics_process(_delta: float) -> void:
	if targets.is_empty():
		return

	var rect := Rect2(targets[0].global_position, Vector2.ZERO)
	for target in targets:
		rect = rect.expand(target.global_position)

	rect = rect.grow(margin)
	global_position = rect.get_center()

	var screen_size := get_viewport_rect().size
	var zoom_x := screen_size.x / rect.size.x
	var zoom_y := screen_size.y / rect.size.y
	var target_zoom := clampf(min(zoom_x, zoom_y), min_zoom, max_zoom)
	zoom = Vector2.ONE * target_zoom
