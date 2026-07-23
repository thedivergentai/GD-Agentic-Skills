# skills/3d-lighting/code/lighting_manager.gd
extends Node

## SDFGI & Hybrid Lighting Expert Pattern
## Manages global illumination settings for optimal performance.

func configure_sdfgi_for_scene(optimization_level: String = "balanced") -> void:
    var env := get_viewport().world_3d.environment
    if not env: return
    
    env.sdfgi_enabled = true
    
    match optimization_level:
        "fast":
            env.sdfgi_cascades = 4
            env.sdfgi_min_cell_size = 0.2
            env.sdfgi_use_occlusion = false # Saves GPU
        "balanced":
            env.sdfgi_cascades = 6
            env.sdfgi_min_cell_size = 0.1
            env.sdfgi_use_occlusion = true
        "high":
            env.sdfgi_cascades = 8
            env.sdfgi_y_scale = RenderingServer.ENV_SDFGI_Y_SCALE_75_PERCENT

## HYBRID PATTERN:
## Blueprints for using LightmapGI for static environment (baked) 
## mixed with SDFGI for dynamic bounce lighting.
## 1. Set Environment Nodes to Bake Mode: 'Static'
## 2. Generate LightmapGI
## 3. Enable SDFGI but set its 'Energy' low (0.2) to fill in dynamic gaps.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/3d/lights_and_shadows.html
# - https://docs.godotengine.org/en/stable/tutorials/performance/optimizing_3d_performance.html
# - https://docs.godotengine.org/en/stable/classes/class_light3d.html
# - https://docs.godotengine.org/en/stable/classes/class_omnilight3d.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md — escalate light-pool hotspots
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — measure shadow toggles
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-autoload-architecture/SKILL.md — central light pool owner
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-lighting/SKILL.md
# =============================================================================
