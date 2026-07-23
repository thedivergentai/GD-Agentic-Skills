# skills/3d-world-building/code/occlusion_setup.gd
extends Node3D

## Occlusion Culling Expert Pattern
## Blueprints for configuring OccluderInstance3D for draw-call reduction.

func setup_room_occlusion(room_node: Node3D) -> void:
    # 1. Create the OccluderInstance3D
    var occluder := OccluderInstance3D.new()
    occluder.name = "RoomOccluder"
    
    # 2. Assign or generate an OccluderPolygon3D
    # For simple rooms, a 'QuadOccluder3D' is most efficient.
    var poly := QuadOccluder3D.new()
    poly.size = Vector2(10, 5) # Match wall size
    occluder.occluder = poly
    
    room_node.add_child(occluder)

## EXPERT NOTE:
## Don't over-use complex occluders. Occlusion culling itself has a CPU cost.
## Best practice: Only occlusion-cull Large, Opaque objects (Walls, Ground, Big Rocks)
## that are guaranteed to hide many smaller objects behind them.

# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/3d/occlusion_culling.html
# - https://docs.godotengine.org/en/stable/classes/class_occluderinstance3d.html
# - https://docs.godotengine.org/en/stable/classes/class_quadoccluder3d.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md — occlusion CPU cost vs draw-call wins
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-lighting/SKILL.md — opaque occluders vs thin emissive/transparent walls
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-world-building/SKILL.md
# =============================================================================
