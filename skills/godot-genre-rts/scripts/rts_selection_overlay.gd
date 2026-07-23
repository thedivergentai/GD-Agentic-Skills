extends Control
class_name RTSSelectionOverlay

## Expert Box Selection (Godot 4.7).
## Draws a 2D box and projects 3D units to screen space for selection.

@export var camera: Camera3D
@export var box_color = Color(0, 1, 0, 0.2)

var _start_pos = Vector2.ZERO
var _is_dragging = false

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			_start_pos = event.position
			_is_dragging = true
		else:
			_is_dragging = false
			_select_units(Rect2(_start_pos, event.position - _start_pos).abs())
			queue_redraw()
	
	if event is InputEventMouseMotion and _is_dragging:
		queue_redraw()

func _draw() -> void:
	if _is_dragging:
		draw_rect(Rect2(_start_pos, get_local_mouse_position() - _start_pos), box_color, true)

func _select_units(rect: Rect2) -> void:
	var selected = []
	for unit in get_tree().get_nodes_in_group("units"):
		if camera.is_position_behind(unit.global_position): continue
		var screen_pos = camera.unproject_position(unit.global_position)
		if rect.has_point(screen_pos):
			selected.append(unit)
			unit.set_selected(true)

## [SKILL NOTICE]: Project 3D positions to 2D for box selection. It is much 
## more performant than scaling a 3D Area3D or frustum-casting every frame.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/inputs/mouse_and_input_coordinates.html
# - https://docs.godotengine.org/en/stable/classes/class_camera3d.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-camera-systems/SKILL.md — unproject/screen-space selection framing
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-input-handling/SKILL.md — marquee drag input lifecycle
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-rts/SKILL.md
# =============================================================================
