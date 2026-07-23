# async_arena_baker.gd
extends Node
class_name AsyncArenaBaker

# Asynchronous Navigation Mesh Baking
# Prevents main thread freezes when updating terrain collision in MOBAs.

@export var navigation_region: NavigationRegion2D

func update_nav_mesh() -> void:
    if not navigation_region: return
    
    # Pattern: Bake on background thread. 
    # Godot 4 handles the threading internally when 'on_thread' is true.
    navigation_region.bake_navigation_mesh(true)
    
    # Wait for completion without locking the game loop.
    await navigation_region.bake_finished
    print("Arena navigation updated asynchronously.")
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/navigation/navigation_using_navigationmeshes.html
# - https://docs.godotengine.org/en/stable/tutorials/navigation/navigation_using_navigationservers.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-navigation-pathfinding/SKILL.md — threaded bake patterns
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-world-building/SKILL.md — arena collision vs nav source
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-moba/SKILL.md
# =============================================================================
