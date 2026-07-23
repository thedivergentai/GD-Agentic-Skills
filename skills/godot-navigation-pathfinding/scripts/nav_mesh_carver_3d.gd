class_name NavMeshCarver3D extends Node3D
## Dynamically carves holes into the NavMesh for permanent environmental changes.

@export var nav_region: NavigationRegion3D

var _source_geometry := NavigationMeshSourceGeometryData3D.new()
var _is_baking: bool = false

func carve_projectile_impact(impact_pos: Vector3, radius: float) -> void:
    if _is_baking: return
    _is_baking = true
    _source_geometry.clear()
    
    # Parse existing geometry and add a carved obstruction.
    NavigationServer3D.parse_source_geometry_data(nav_region.navigation_mesh, _source_geometry, nav_region)
    
    var outline := PackedVector3Array([
        impact_pos + Vector3(-radius, 0, -radius),
        impact_pos + Vector3(radius, 0, -radius),
        impact_pos + Vector3(radius, 0, radius),
        impact_pos + Vector3(-radius, 0, radius)
    ])
    
    _source_geometry.add_projected_obstruction(outline, impact_pos.y, 10.0, true)
    
    # Bake asynchronously to prevent frame stuttering.
    NavigationServer3D.bake_from_source_geometry_data_async(
        nav_region.navigation_mesh, 
        _source_geometry, 
        _on_bake_finished
    )

func _on_bake_finished() -> void:
    NavigationServer3D.region_set_navigation_mesh(nav_region.get_rid(), nav_region.navigation_mesh)
    _is_baking = false
