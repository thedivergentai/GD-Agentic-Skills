class_name UniversalGrabManager extends Node3D
## Decoupled interaction manager using OpenXR actions.

@export var controller: XRController3D
@export var grab_area: Area3D

var _grabbed: Node3D = null

func _ready() -> void:
    controller.button_pressed.connect(_on_grab)

func _on_grab(action_name: String) -> void:
    if action_name == "grab" and not _grabbed:
        for body in grab_area.get_overlapping_bodies():
            if body.is_in_group("grabbable"):
                _grabbed = body
                _grabbed.reparent(controller, true)
                break
