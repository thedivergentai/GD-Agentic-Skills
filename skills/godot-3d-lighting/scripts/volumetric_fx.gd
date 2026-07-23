# skills/3d-lighting/code/volumetric_fx.gd
extends Node3D

## Volumetric Lighting (FogVolume) Expert Pattern
## Demonstrates depth-aware scattering without performance tanking.

func setup_optimized_fog() -> void:
    var env := get_viewport().world_3d.environment
    if not env: return
    
    # 1. Enable Global Volumetric Fog
    env.volumetric_fog_enabled = true
    env.volumetric_fog_density = 0.01 # Subtle base
    
    # 2. Localized FogVolumes
    # Use FogVolume nodes for dense areas (valley, forest) 
    # instead of increasing global density.
    var valley_fog := FogVolume.new()
    valley_fog.size = Vector3(100, 20, 100)
    valley_fog.shape = RenderingServer.FOG_VOLUME_SHAPE_BOX
    add_child(valley_fog)

## OPTIMIZATION:
## Viewport -> Rendering -> Default (Volumetric Fog) -> 'Filter'
## Set 'Use Temporal Reproduction' to TRUE to significantly reduce 
## the amount of samples needed for smooth fog.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/3d/volumetric_fog.html
# - https://docs.godotengine.org/en/stable/tutorials/3d/environment_and_post_processing.html
# - https://docs.godotengine.org/en/stable/classes/class_environment.html
# - https://docs.godotengine.org/en/stable/classes/class_fogvolume.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-particles/SKILL.md — shafts with dust/smoke layers
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-shaders-basics/SKILL.md — fog shader customization
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-horror/SKILL.md — dense fog for tension
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-lighting/SKILL.md
# =============================================================================
