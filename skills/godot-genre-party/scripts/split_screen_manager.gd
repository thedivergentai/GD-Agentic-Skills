# split_screen_manager.gd
extends GridContainer
class_name SplitScreenManager

# Dynamic Split-Screen Viewport Synchronizer
# Ensures all viewports share the same 3D physics and rendering world.

@export var main_world_viewport: SubViewport

func add_player_viewport(player_id: int, camera_target: Node3D) -> SubViewport:
    var container := SubViewportContainer.new()
    container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    container.size_flags_vertical = Control.SIZE_EXPAND_FILL
    
    var viewport := SubViewport.new()
    # CRITICAL: Share the same World3D so players see each other.
    if main_world_viewport:
        viewport.world_3d = main_world_viewport.world_3d
    
    var camera := Camera3D.new()
    viewport.add_child(camera)
    
    container.add_child(viewport)
    add_child(container)
    
    return viewport
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/rendering/viewports.html
# - https://docs.godotengine.org/en/stable/classes/class_subviewport.html
# - https://docs.godotengine.org/en/stable/classes/class_subviewportcontainer.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-camera-systems/SKILL.md — per-player Camera3D in shared World3D
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md — GridContainer stretch layout
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-party/SKILL.md
# =============================================================================
