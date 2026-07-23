# trauma_debugger.gd
class_name TraumaDebugger
extends Node2D
## Visualizes the decay curve of a trauma-based shake system.

@export var camera: Node
var _history: PackedFloat32Array = []

func _process(_delta: float) -> void:
	if not camera or not camera.has_method(&"get_trauma"):
		return

	_history.append(camera.call(&"get_trauma"))
	if _history.size() > 200:
		_history.remove_at(0)
	queue_redraw()

func _draw() -> void:
	var width := 400.0
	var height := 100.0
	var step := width / 200.0

	for i in range(1, _history.size()):
		var p1 := Vector2(i * step, height - (_history[i - 1] * height))
		var p2 := Vector2((i + 1) * step, height - (_history[i] * height))
		draw_line(p1, p2, Color.YELLOW, 2.0)
