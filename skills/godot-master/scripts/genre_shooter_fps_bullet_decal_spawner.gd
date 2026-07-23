# bullet_decal_spawner.gd
extends Node
class_name BulletDecalSpawner

# Spawning Dynamic Bullet Decals
# Correctly projects textures across uneven surfaces using the Decal node.

@export var bullet_hole_texture: Texture2D

func spawn_decal(hit_position: Vector3, hit_normal: Vector3) -> void:
    var decal := Decal.new()
    decal.texture_albedo = bullet_hole_texture
    decal.size = Vector3(0.1, 0.1, 0.1)
    
    get_tree().root.add_child(decal)
    decal.global_position = hit_position
    
    # Pattern: Align decal to surface normal.
    if hit_normal != Vector3.UP and hit_normal != Vector3.DOWN:
        decal.look_at(hit_position + hit_normal, Vector3.UP)
    elif hit_normal == Vector3.UP:
        decal.rotation_degrees.x = 90
    else:
        decal.rotation_degrees.x = -90
        
    # Optimization: Decals should have a lifespan.
    var timer := get_tree().create_timer(10.0)
    timer.timeout.connect(decal.queue_free)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/3d/using_decals.html
# - https://docs.godotengine.org/en/stable/classes/class_decal.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md - decal fade/pool budgets under fire spam
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-shooter/SKILL.md - shared impact polish patterns
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-shooter-fps/SKILL.md
# =============================================================================
