# multimesh_foliage_manager.gd
extends MultiMeshInstance3D
class_name MultiMeshFoliageManager

# High-Performance Foliage Renderer
# Batch-renders thousands of static meshes (trees, rocks) in a single GPU draw call.

func setup_batch(mesh: Mesh, transforms: Array[Transform3D]) -> void:
    # Pattern: Use MultiMesh to bypass individual Node3D overhead.
    multimesh = MultiMesh.new()
    multimesh.transform_format = MultiMesh.TRANSFORM_3D
    multimesh.mesh = mesh
    
    # Pre-allocate count to prevent resizing during population.
    multimesh.instance_count = transforms.size()
    
    for i in range(transforms.size()):
        multimesh.set_instance_transform(i, transforms[i])
        
    # Pattern: Enable visibility range to cull entire batches based on distance.
    visibility_range_end = 500.0
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/performance/using_multimesh.html
# - https://docs.godotengine.org/en/stable/classes/class_multimesh.html
# - https://docs.godotengine.org/en/stable/tutorials/3d/visibility_ranges.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md — partition MultiMesh for frustum culling
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-world-building/SKILL.md — landscape prop density without Node storms
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-open-world/SKILL.md
# =============================================================================
