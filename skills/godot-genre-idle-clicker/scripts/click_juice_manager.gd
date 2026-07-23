# click_juice_manager.gd
class_name ClickJuiceManager extends Node2D

@export var click_particles: GPUParticles2D

func _input(event: InputEvent) -> void:
    if event.is_action_pressed(&"click"):
        var click_pos = get_global_mouse_position()
        _burst_particles(click_pos)

func _burst_particles(pos: Vector2) -> void:
    for i in range(15):
        var xform = Transform2D(0.0, pos)
        var velocity = Vector2(randf_range(-200.0, 200.0), randf_range(-200.0, 200.0))
        # Direct GPU emission bypasses SceneTree overhead
        click_particles.emit_particle(xform, velocity, Color.WHITE, Color.WHITE, 0)
