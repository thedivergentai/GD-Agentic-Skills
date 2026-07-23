# rts_targeting_logic.gd
extends RefCounted
class_name RTSTargetingLogic

# Fast Distance Squared Checking
# Bypasses expensive square-root math when filtering thousands of potential targets.

static func find_nearest_target(origin: Vector3, targets: Array[Node3D]) -> Node3D:
    var best_target: Node3D = null
    var min_dist_sq := INF
    
    for target in targets:
        # Pattern: Use distance_squared_to to save CPU cycles in mass loops.
        var d_sq := origin.distance_squared_to(target.global_position)
        if d_sq < min_dist_sq:
            min_dist_sq = d_sq
            best_target = target
            
    return best_target
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/math/vector_math.html
# - https://docs.godotengine.org/en/stable/tutorials/performance/using_servers.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-combat-system/SKILL.md — nearest-target filters before hit resolution
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md — distance-squared mass scans
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-rts/SKILL.md
# =============================================================================
