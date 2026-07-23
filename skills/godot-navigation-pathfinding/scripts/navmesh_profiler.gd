class_name NavMeshProfiler extends Node
## A benchmarking tool to validate NavMesh complexity and bake times.

func run_benchmark(nav_mesh: NavigationMesh, source_geometry: NavigationMeshSourceGeometryData3D) -> void:
    var start_time_usec: float = Time.get_ticks_usec()
    
    # Synchronous bake for linear benchmarking (main thread stall expected).
    NavigationServer3D.bake_from_source_geometry_data(nav_mesh, source_geometry)
    
    var elapsed_ms: float = (Time.get_ticks_usec() - start_time_usec) / 1000.0
    var poly_count: int = NavigationServer3D.get_process_info(NavigationServer3D.INFO_POLYGON_COUNT)
    var edge_count: int = NavigationServer3D.get_process_info(NavigationServer3D.INFO_EDGE_COUNT)
    
    print("Bake Time: %f ms | Polygons: %d | Edges: %d" % [elapsed_ms, poly_count, edge_count])
