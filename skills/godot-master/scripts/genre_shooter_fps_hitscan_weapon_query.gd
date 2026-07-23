# hitscan_weapon_query.gd
extends Node3D
class_name HitscanWeaponQuery

# High-Performance Hitscan Query (Nodeless)
# Fires a raycast instantly using the C++ physics server.

@export var damage := 25.0
@export var range := 1000.0

func fire_hitscan(camera: Camera3D, player_rid: RID) -> Dictionary:
    var space_state := get_world_3d().direct_space_state
    var viewport := get_viewport()
    var center_screen := viewport.get_visible_rect().size / 2.0
    
    var origin := camera.project_ray_origin(center_screen)
    var end := origin + camera.project_ray_normal(center_screen) * range
    
    var query := PhysicsRayQueryParameters3D.create(origin, end)
    # NEVER shoot yourself: Exclude player RID.
    query.exclude = [player_rid]
    query.collide_with_areas = false
    
    var result := space_state.intersect_ray(query)
    if not result.is_empty():
        var collider = result.get("collider")
        # Duck-typing damage application for decoupled logic.
        if collider.has_method(&"take_damage"):
            collider.take_damage(damage)
            
    return result
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_physicsdirectspacestate3d.html
# - https://docs.godotengine.org/en/stable/tutorials/physics/ray-casting.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-raycasting-queries/SKILL.md - nodeless space-state hitscan
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-multiplayer-networking/SKILL.md - server re-run of the same query shape
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-shooter-fps/SKILL.md
# =============================================================================
