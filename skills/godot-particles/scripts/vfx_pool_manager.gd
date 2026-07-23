class_name VFXPool extends Node

@export var vfx_scene: PackedScene
var pool: Array[GPUParticles3D] = []

func _ready() -> void:
    for i in 20:
        var inst := vfx_scene.instantiate() as GPUParticles3D
        add_child(inst)
        inst.emitting = false
        inst.finished.connect(func(): pool.append(inst))
        pool.append(inst)

func spawn(pos: Vector3) -> void:
    if pool.is_empty(): return
    var vfx = pool.pop_back()
    vfx.global_position = pos
    # Use restart() to avoid async GPU state delays
    vfx.restart()
