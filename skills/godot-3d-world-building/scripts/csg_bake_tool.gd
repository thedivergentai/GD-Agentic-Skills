# skills/3d-world-building/code/csg_bake_tool.gd
@tool
extends Node3D

## CSG to Mesh Baking Workflow
## Tool script to automate the greybox-to-production transition.

@export var bake_now: bool = false:
    set(value):
        if value: bake_csg_hierarchy()

func bake_csg_hierarchy() -> void:
    var csg_root = get_node_or_null("CSGRoot")
    if not csg_root or not csg_root is CSGShape3D:
        push_error("Please provide a CSGShape3D root named 'CSGRoot'")
        return
        
    # 1. Force update to ensure current geometry is valid
    csg_root._update_shape() 
    
    # 2. Extract the baked mesh
    var meshes = csg_root.get_meshes() 
    # Godot returns [Transform, Mesh] pairs
    if meshes.size() < 2: return
    
    var final_mesh: Mesh = meshes[1]
    
    # 3. Create a static MeshInstance3D
    var result := MeshInstance3D.new()
    result.name = "BakedMesh_" + csg_root.name
    result.mesh = final_mesh
    
    # 4. Add to scene and cleanup
    get_parent().add_child(result)
    result.owner = get_tree().edited_scene_root
    result.global_transform = csg_root.global_transform
    
    print("CSG Baked successfully. You can now hide/delete the CSG nodes.")

## WHY BAKE?
## CSG nodes are expensive to calculate at runtime. 
## Baking to MeshInstance3D allows for Occlusion Culling, Baked Lightmaps, and LODs.

# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/3d/csg_tools.html
# - https://docs.godotengine.org/en/stable/classes/class_csgshape3d.html
# - https://docs.godotengine.org/en/stable/classes/class_meshinstance3d.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-materials/SKILL.md — materials preserved or reassigned on bake
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-physics-3d/SKILL.md — StaticBody collision after CSG → mesh conversion
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-world-building/SKILL.md
# =============================================================================
