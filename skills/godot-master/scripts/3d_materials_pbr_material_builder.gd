# skills/3d-materials/scripts/pbr_material_builder.gd
extends Node

## PBR Material Builder (Expert Pattern)
## Runtime helper to build StandardMaterial3D from texture sets.
## Automatically handles ORM packing if provided.

class_name PBRMaterialBuilder

static func build(albedo: Texture2D, normal: Texture2D = null, orm: Texture2D = null) -> StandardMaterial3D:
    var mat = StandardMaterial3D.new()
    
    # 1. Albedo
    if albedo:
        mat.albedo_texture = albedo
        
    # 2. Normal
    if normal:
        mat.normal_enabled = true
        mat.normal_texture = normal
        
    # 3. ORM (Occlusion, Roughness, Metallic)
    if orm:
        mat.orm_texture = orm
        mat.ao_enabled = true
        # Godot Standard: ORM texture (R=AO, G=Rough, B=Metal)
        # Verify channel mapping
        mat.ao_texture_channel = BaseMaterial3D.TEXTURE_CHANNEL_RED
        mat.roughness_texture_channel = BaseMaterial3D.TEXTURE_CHANNEL_GREEN
        mat.metallic_texture_channel = BaseMaterial3D.TEXTURE_CHANNEL_BLUE
    else:
        # Default defaults
        mat.roughness = 0.5
        mat.metallic = 0.0
        
    return mat

static func build_triplanar(albedo: Texture2D, normal: Texture2D = null) -> StandardMaterial3D:
    var mat = build(albedo, normal)
    mat.uv1_triplanar = true
    return mat

## EXPERT USAGE:
## var mat = PBRMaterialBuilder.build(load("grass_c.png"), load("grass_n.png"))
## $MeshInstance.material_override = mat
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/3d/standard_material_3d.html
# - https://docs.godotengine.org/en/stable/classes/class_standardmaterial3d.html
# - https://docs.godotengine.org/en/stable/classes/class_ormmaterial3d.html
# - https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/importing_images.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md — share built materials as Resources
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-shaders-basics/SKILL.md — triplanar/custom paths beyond StandardMaterial3D
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-materials/SKILL.md
# =============================================================================
