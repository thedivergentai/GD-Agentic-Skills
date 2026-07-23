# skills/3d-world-building/code/lod_manager.gd
extends Node3D

## LOD (Level of Detail) Management Pattern
## Demonstrates setting distance-based visibility thresholds.

@export var lod_far_distance := 100.0
@export var lod_medium_distance := 50.0

func setup_mesh_lod(mesh_instance: MeshInstance3D) -> void:
    # Godot 4.3+ has automatic mesh LOD generation on import.
    # This script handles manual visibility/node swapping if needed.
    
    mesh_instance.visibility_range_end = lod_far_distance
    mesh_instance.visibility_range_end_margin = 10.0 # Fade margin
    
    # Enable hysteresis to prevent flickering at the threshold
    mesh_instance.visibility_range_fade_mode = GeometryInstance3D.VISIBILITY_RANGE_FADE_SELF

## EXPERT NOTE:
## Always prefer the Importer's automatic LOD generation for static meshes.
## Use manual Visibility Ranges (this script) only for complex hierarchical objects 
## or when swapping between a high-poly Mesh and a Billboards/Impostor.

# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/3d/mesh_lod.html
# - https://docs.godotengine.org/en/stable/tutorials/3d/visibility_ranges.html
# - https://docs.godotengine.org/en/stable/classes/class_geometryinstance3d.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-camera-systems/SKILL.md — distance thresholds relative to active camera
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md — when visibility ranges beat full mesh LOD
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-open-world/SKILL.md — HLOD / impostors at outdoor scale
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-world-building/SKILL.md
# =============================================================================
