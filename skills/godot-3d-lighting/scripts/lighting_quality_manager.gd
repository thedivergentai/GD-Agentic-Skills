class_name LightingQualityManager extends Node

func apply_low_quality_profile(env_rid: RID) -> void:
    # 1. SDFGI Optimization
    # Huge performance gain: Render GI buffers at half resolution
    RenderingServer.gi_set_use_half_resolution(true)
    RenderingServer.environment_set_sdfgi_ray_count(RenderingServer.ENV_SDFGI_RAY_COUNT_4)
    RenderingServer.environment_set_sdfgi_frames_to_converge(RenderingServer.ENV_SDFGI_CONVERGE_IN_30_FRAMES)
    
    # 2. Shadow Optimization
    # Reduce global directional shadow atlas
    RenderingServer.directional_shadow_atlas_set_size(2048, true)
    RenderingServer.directional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_VERY_LOW)
    # Reduce positional (Omni/Spot) shadows for current viewport
    get_viewport().positional_shadow_atlas_size = 1024
    
    # 3. Volumetric Fog
    # Disable or heavily reduce fog detail
    RenderingServer.environment_set_volumetric_fog(env_rid, false, 0.01, Color.WHITE, Color.BLACK, 0.0, 0.2, 64.0, 2.0, 1.0, true, 0.9, 0.0, 1.0)
