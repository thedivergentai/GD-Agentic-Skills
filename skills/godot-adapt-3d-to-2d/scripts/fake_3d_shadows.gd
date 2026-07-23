extends Sprite2D
class_name Fake3DShadow2D

## Simulates a dynamic 3D shadow projected onto a 2D floor 
## using matrix skewing (shear) based on a simulated sun position.

@export var sun_direction: Vector2 = Vector2(-0.5, 0.2)
@export var shadow_length: float = 1.5
@export var shadow_color: Color = Color(0, 0, 0, 0.4)

func _ready() -> void:
    # Ensure this shadow sits behind the original object
    show_behind_parent = true
    modulate = shadow_color
    
func _process(delta: float) -> void:
    # In Godot 4.x, you skew a CanvasItem using its Transform2D
    var t = Transform2D()
    
    # 1. Scale down Y to simulate lying flat on the ground
    t = t.scaled_local(Vector2(1.0, 0.3))
    
    # 2. Shear (Skew) the matrix toward the sun direction
    t.x.y = sun_direction.x * shadow_length 
    
    # 3. Apply the custom transform
    transform = t
    
    # Optional: Rotate the shadow entirely if the light source orbits
    # rotation = sun_direction.angle()
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/2d/2d_transforms.html
# - https://docs.godotengine.org/en/stable/classes/class_transform2d.html
# - https://docs.godotengine.org/en/stable/classes/class_sprite2d.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-2d-animation/SKILL.md — shadow Sprite2D under characters
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-shaders-basics/SKILL.md — soft-shadow alternatives
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-adapt-3d-to-2d/SKILL.md
# =============================================================================
