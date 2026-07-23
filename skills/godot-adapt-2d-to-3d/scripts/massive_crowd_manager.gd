class_name MassiveCrowdManager extends MultiMeshInstance3D
## Efficiently manages millions of camera-facing instances via GPU hardware.

func _ready() -> void:
    # 1. Configure the MultiMesh for 3D transforms.
    multimesh = MultiMesh.new()
    multimesh.transform_format = MultiMesh.TRANSFORM_3D
    multimesh.instance_count = 10000
    
    # 2. Build a ShaderMaterial using VisualShaderNodeBillboard.
    var material := ShaderMaterial.new()
    # Note: Logic assumes billboard_type=BILLBOARD_TYPE_FIXED_Y and keep_scale=true.
    multimesh.mesh = QuadMesh.new()
    multimesh.mesh.surface_set_material(0, material)
    
    # 3. Populate transforms. The GPU handles orientation.
    for i in range(multimesh.instance_count):
        var pos := Vector3(randf() * 100, 0, randf() * 100)
        multimesh.set_instance_transform(i, Transform3D(Basis(), pos))
