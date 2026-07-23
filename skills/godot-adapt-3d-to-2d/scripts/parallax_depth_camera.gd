extends Camera2D
class_name FakeDepthCamera2D

## Expert Camera2D for simulating 3D depth via Parallax
## Replaces FOV and 3D positioning with scale-based depth layers.

@export var depth_layers: Array[CanvasLayer] = []
@export var base_camera_speed: float = 10.0

@onready var player: Node2D = get_parent()

func _ready() -> void:
    set_process(true)
    # Ensure smoothing is active for that "cinematic 3D" feel
    position_smoothing_enabled = true
    position_smoothing_speed = base_camera_speed

func _process(delta: float) -> void:
    # Simulating a perspective shift when the player moves rapidly
    # by slightly nudging the furthest background CanvasLayers in opposition to camera movement.
    var cam_velocity = get_screen_center_position() - global_position
    
    for i in range(depth_layers.size()):
        var layer = depth_layers[i]
        # Deeper layers (higher index) move slower, causing a parallax effect without using ParallaxBackground
        var depth_factor = 1.0 - (float(i) / depth_layers.size()) * 0.5
        layer.offset = global_position * (1.0 - depth_factor)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/2d/2d_parallax.html
# - https://docs.godotengine.org/en/stable/tutorials/2d/canvas_layers.html
# - https://docs.godotengine.org/en/stable/classes/class_parallax2d.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-camera-systems/SKILL.md — Camera2D-driven layer offsets
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-shaders-basics/SKILL.md — optional depth warp FX
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-adapt-3d-to-2d/SKILL.md
# =============================================================================
