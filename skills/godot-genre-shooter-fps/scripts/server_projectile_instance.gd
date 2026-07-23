# server_projectile_instance.gd
extends Node
class_name ServerProjectileInstance

# Nodeless Projectile Spawning via Servers
# Direct RenderingServer calls for high-volume minigun bullets.

var _bullet_rid: RID

func spawn_visual_bullet(mesh_rid: RID, xform: Transform3D) -> void:
    # Pattern: Create instance directly in visual server to bypass SceneTree overhead.
    _bullet_rid = RenderingServer.instance_create()
    RenderingServer.instance_set_base(_bullet_rid, mesh_rid)
    RenderingServer.instance_set_scenario(_bullet_rid, get_world_3d().scenario)
    RenderingServer.instance_set_transform(_bullet_rid, xform)

func update_visual(xform: Transform3D) -> void:
    if _bullet_rid.is_valid():
        RenderingServer.instance_set_transform(_bullet_rid, xform)

func _exit_tree() -> void:
    if _bullet_rid.is_valid():
        RenderingServer.free_rid(_bullet_rid)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/performance/using_servers.html
# - https://docs.godotengine.org/en/stable/classes/class_renderingserver.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md - RID visual bullets without nodes
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-multiplayer-networking/SKILL.md - server-authoritative spawn, client visuals only
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-shooter-fps/SKILL.md
# =============================================================================
