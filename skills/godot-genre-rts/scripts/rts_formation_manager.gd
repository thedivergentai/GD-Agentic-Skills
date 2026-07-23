class_name RTSFormationManager extends Node

## Moves a group of units in formation to a target destination using a single path query.
static func move_group_to_target(units: Array[CharacterBody3D], target_position: Vector3, map_rid: RID) -> void:
    if units.is_empty():
        return
        
    # 1. Calculate the Center of Mass (Average Position)
    var center_of_mass := Vector3.ZERO
    for unit in units:
        center_of_mass += unit.global_position
    center_of_mass /= units.size()
    
    # 2. Query NavigationServer for the optimized central path
    var central_path: PackedVector3Array = NavigationServer3D.map_get_path(
        map_rid,
        center_of_mass,
        target_position,
        true 
    )
    
    if central_path.is_empty():
        return
        
    var final_center_destination: Vector3 = central_path[central_path.size() - 1]
    
    # 3. Distribute commands with relative offsets to maintain formation
    for unit in units:
        var offset: Vector3 = unit.global_position - center_of_mass
        var unit_destination: Vector3 = final_center_destination + offset
        
        if unit.has_method("set_movement_target"):
            unit.set_movement_target(unit_destination)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-rts/SKILL.md
# =============================================================================
