@tool
class_name LightMigrationTool extends EditorScript
## Converts PointLight2D nodes in the active scene to OmniLight3D.

func _run() -> void:
    var root := EditorInterface.get_edited_scene_root()
    if not root: return
    _migrate_node(root)

func _migrate_node(node: Node) -> void:
    if node is PointLight2D:
        var l3d := OmniLight3D.new()
        l3d.light_color = node.color
        l3d.light_energy = node.energy
        # Approximate 3D range from 2D texture radius * scale
        var radius := 128.0 # Default fallback
        if node.texture: radius = node.texture.get_width() / 2.0
        l3d.omni_range = radius * node.texture_scale
        
        # Mapping 2D (x, y) to 3D (x, y, height)
        l3d.position = Vector3(node.position.x, node.position.y, node.height)
        
        node.get_parent().add_child(l3d)
        l3d.owner = EditorInterface.get_edited_scene_root()
        l3d.name = node.name + "_3D"
        
    for child in node.get_children():
        _migrate_node(child)
