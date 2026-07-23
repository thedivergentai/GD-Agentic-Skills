extends Area2D
class_name SimulatedDepthArea2D

## Expert Hitbox Management in 2.5D
## Prevents a ground attack from hitting a jumping character by simulating Z-height intersection

@export var base_z_height: float = 0.0
@export var z_thickness: float = 20.0  # How "tall" the hitbox is

func _ready() -> void:
    area_entered.connect(_on_area_entered)

func _on_area_entered(other_area: Area2D) -> void:
    if other_area is SimulatedDepthArea2D:
        if _check_z_overlap(other_area):
            print("Valid 3D Hit! Simulated hit detected at Z-height.")
            # Trigger combat logic...
        else:
            print("Missed! They were at different vertical heights!")

func _check_z_overlap(other: SimulatedDepthArea2D) -> bool:
    # 1D AABB intersection math applied to our simulated vertical "Z" dimension
    var my_top = base_z_height + z_thickness
    var my_bottom = base_z_height
    var other_top = other.base_z_height + other.z_thickness
    var other_bottom = other.base_z_height
    
    return my_top >= other_bottom and my_bottom <= other_top

## Call this to dynamically update height if attached to a jumping player
func update_current_z_height(new_z: float) -> void:
    base_z_height = new_z
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_area2d.html
# - https://docs.godotengine.org/en/stable/tutorials/physics/physics_introduction.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-2d-physics/SKILL.md — Area2D masks + custom height AABB
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-combat-system/SKILL.md — ground-vs-air hit validation
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-adapt-3d-to-2d/SKILL.md
# =============================================================================
