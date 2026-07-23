# Shadowmasking and LightmapGI Setup
extends LightmapGI

## Advanced baking workflow: Distant shadows are baked (Lightmap)
## while nearby shadows remain dynamic (DirectionalLight3D).

func configure_expert_bake() -> void:
    # Forward+ Renderer required for high quality
    quality = LightmapGI.BAKE_QUALITY_ULTRA
    bounces = 3
    
    # Architecture Tip: Ensure your DirectionalLight3D is set to 'Bake Mode: Dynamic'
    # so it results in shadowmasking instead of full static bake.
    
    # Use denoiser for soft, realistic transitions
    use_denoiser = true
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/3d/global_illumination/using_lightmap_gi.html
# - https://docs.godotengine.org/en/stable/tutorials/3d/global_illumination/introduction_to_global_illumination.html
# - https://docs.godotengine.org/en/stable/classes/class_lightmapgi.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-world-building/SKILL.md — static UV2-ready architecture
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-materials/SKILL.md — bake mode and lightmap size hints
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-adapt-desktop-to-mobile/SKILL.md — prefer baked GI on Mobile
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-lighting/SKILL.md
# =============================================================================
