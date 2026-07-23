# monster_los_check.gd
extends Node

# High-Performance Monster Line-of-Sight (Stealth)
# Bypasses Area3D for immediate, physics-synced raycasting via DirectSpaceState.
func check_monster_los(monster: CharacterBody3D, player: Node3D) -> bool:
    var space_state := monster.get_world_3d().direct_space_state
    var query := PhysicsRayQueryParameters3D.create(monster.global_position, player.global_position)
    
    # EXTREMELY IMPORTANT: Exclude the monster's own RID from the raycast 
    # to prevent immediate self-intersection which returns false positives.
    query.exclude = [monster.get_rid()]
    
    var result := space_state.intersect_ray(query)
    
    # Returns true only if the ray hits the player without obstruction.
    return not result.is_empty() and result.collider == player
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/physics/ray-casting.html
# - https://docs.godotengine.org/en/stable/classes/class_physicsdirectspacestate3d.html
# - https://docs.godotengine.org/en/stable/classes/class_physicsrayqueryparameters3d.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-raycasting-queries/SKILL.md — intersect_ray masks and exclude lists
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-physics-3d/SKILL.md — collision layers for vision queries
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-navigation-pathfinding/SKILL.md — LoS feeds chase retargeting
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-horror/SKILL.md
# =============================================================================
