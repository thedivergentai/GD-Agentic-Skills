# PBR ORM Texture Packer Utility
extends Resource

## Expert pattern: Combine Ambient Occlusion, Roughness, and Metallic
## into one RGB texture (ORM) to save 2 texture slots and GPU memory.

func get_orm_material(albedo: Texture, orm: Texture, normal: Texture) -> StandardMaterial3D:
    var mat = StandardMaterial3D.new()
    mat.albedo_texture = albedo
    
    # Mandatory channel mapping for ORM
    mat.orm_texture = orm # R=AO, G=Rough, B=Metal
    
    mat.normal_enabled = true
    mat.normal_texture = normal
    
    # Optimization: Use triplanar in world space for large terrain meshes
    mat.uv1_triplanar = true
    mat.uv1_world_triplanar = true
    
    return mat
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/3d/standard_material_3d.html
# - https://docs.godotengine.org/en/stable/classes/class_ormmaterial3d.html
# - https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/importing_images.html
# - https://docs.godotengine.org/en/stable/classes/class_basematerial3d.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md — packed textures as reusable assets
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md — VRAM/slot savings from ORM
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-materials/SKILL.md
# =============================================================================
