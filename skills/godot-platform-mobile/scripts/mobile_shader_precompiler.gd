class_name MobileShaderPrecompiler extends Node3D
## Forces RenderingServer to compile pipelines during loading.

@export var effects_to_precompile: Array[PackedScene] = []

func _ready() -> void:
    for scene in effects_to_precompile:
        var instance := scene.instantiate() as Node3D
        add_child(instance)
        # Hidden nodes trigger compilation in Forward+/Mobile
        instance.hide() 
        
    # Compatibility renderer needs one visible frame in frustum
    if ProjectSettings.get_setting("rendering/renderer/rendering_method") == "gl_compatibility":
        for child in get_children():
            child.show()
            child.position = Vector3(0, 0, -2) # In front of camera
        await get_tree().process_frame
        for child in get_children(): child.queue_free()
