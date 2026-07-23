class_name LightVolumeTrigger extends Area3D

@export var interior_environment: Environment
@export var transition_duration: float = 2.0

func _ready() -> void:
    body_entered.connect(_on_body_entered)
    body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node3D) -> void:
    if body.is_in_group("player"):
        var camera := get_viewport().get_camera_3d()
        # Duplicate to avoid modifying the original resource
        if not camera.environment:
            camera.environment = interior_environment.duplicate()
            
        var tween := create_tween().set_parallel(true)
        # Interpolate key properties for visual adaptation
        tween.tween_property(camera.environment, "tonemap_exposure", interior_environment.tonemap_exposure, transition_duration)
        tween.tween_property(camera.environment, "ambient_light_energy", interior_environment.ambient_light_energy, transition_duration)

func _on_body_exited(body: Node3D) -> void:
    # Reverse tween or clear camera environment to return to WorldEnvironment
    pass
