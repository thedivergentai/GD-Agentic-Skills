# rendering_ghost_spawner.gd
extends Node
class_name RenderingGhostSpawner

# Server-Side Rendering for Building Ghosts
# Bypasses SceneTree overhead for ghost visuals using RenderingServer.

var _ghost_rid: RID

func create_placement_ghost(mesh_rid: RID, scenario: RID) -> void:
    # Pattern: Directly instantiate in visual server to avoid costly Node lifecycle.
    _ghost_rid = RenderingServer.instance_create()
    RenderingServer.instance_set_base(_ghost_rid, mesh_rid)
    RenderingServer.instance_set_scenario(_ghost_rid, scenario)
    
    # Optional: Apply ghost shader/material.
    # RenderingServer.instance_set_surface_override_material(...)

func update_ghost_transform(xform: Transform3D) -> void:
    if _ghost_rid.is_valid():
        RenderingServer.instance_set_transform(_ghost_rid, xform)

func destroy_ghost() -> void:
    if _ghost_rid.is_valid():
        RenderingServer.free_rid(_ghost_rid)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_renderingserver.html
# - https://docs.godotengine.org/en/stable/tutorials/performance/using_servers.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md — RID ghosts without SceneTree cost
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-rts/SKILL.md
# =============================================================================
