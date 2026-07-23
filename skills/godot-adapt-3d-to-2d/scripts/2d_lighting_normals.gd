# 2d_lighting_normals.gd
extends Sprite2D
class_name LitSprite2D

## Expert Script for generating 3D-like lighting on 2D sprites
## In 3D, StandardMaterial handles normal maps reacting to lights.
## In 2D, we must construct a CanvasTexture via code if we are generating assets procedurally,
## or properly assign it in the editor.

@export var albedo_texture: Texture2D
@export var normal_texture: Texture2D # Generated via tools like SpriteIlluminator

func _ready() -> void:
    if albedo_texture == null or normal_texture == null:
        push_warning("LitSprite2D requires both albedo and normal textures.")
        return
        
    var canvas_texture = CanvasTexture.new()
    
    # Base color texture
    canvas_texture.diffuse_texture = albedo_texture
    
    # The normal map calculates angles for the 2D PointLight
    canvas_texture.normal_texture = normal_texture
    
    # Optional specular map to give 2D materials specific shininess
    # canvas_texture.specular_texture = load("...")
    # canvas_texture.specular_color = Color(1.0, 1.0, 1.0)
    # canvas_texture.specular_shininess = 20.0
    
    # Apply to the Sprite2D node
    texture = canvas_texture
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/2d/2d_lights_and_shadows.html
# - https://docs.godotengine.org/en/stable/classes/class_canvastexture.html
# - https://docs.godotengine.org/en/stable/classes/class_pointlight2d.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-lighting/SKILL.md — bake normals before 2D port
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-2d-animation/SKILL.md — CanvasTexture on Sprite2D
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-adapt-3d-to-2d/SKILL.md
# =============================================================================
