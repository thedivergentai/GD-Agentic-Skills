class_name NavigationBridge2D5D extends Node

## Projects 3D NavigationServer paths to 2D screenspace for 2.5D movement.
static func query_2_5d_path(camera: Camera3D, map_rid: RID, start_2d: Vector2, target_2d: Vector2) -> PackedVector2Array:
    # 1. Project 2D screen points to the 3D ground plane (Y=0).
    var start_3d := camera.project_position(start_2d, 0.0)
    var target_3d := camera.project_position(target_2d, 0.0)
    
    # 2. Query optimized 3D path.
    var path_3d := NavigationServer3D.map_get_path(map_rid, start_3d, target_3d, true)
    
    # 3. Project 3D world points back to 2D screenspace coordinates for the sprite.
    var path_2d := PackedVector2Array()
    for point in path_3d:
        path_2d.append(camera.unproject_position(point))
        
    return path_2d
