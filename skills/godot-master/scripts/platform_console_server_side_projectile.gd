class_name ServerSideProjectile
extends RefCounted

## Expert Object Management: Bypassing the SceneTree using Server APIs.
## Offloads CPU transform propagation for thousands of entities.

var _mesh_instance_rid: RID
var _body_rid: RID

func _init(world_2d_or_3d_rid: RID, scenario_rid: RID, mesh_rid: RID, shape_rid: RID) -> void:
	# Directly allocate physics on the C++ PhysicsServer
	_body_rid = PhysicsServer3D.body_create() # Change to 2D if needed
	PhysicsServer3D.body_set_space(_body_rid, world_2d_or_3d_rid)
	PhysicsServer3D.body_add_shape(_body_rid, shape_rid)
	
	# Directly allocate visuals on the GPU RenderingServer
	_mesh_instance_rid = RenderingServer.instance_create()
	RenderingServer.instance_set_base(_mesh_instance_rid, mesh_rid)
	RenderingServer.instance_set_scenario(_mesh_instance_rid, scenario_rid)

func update_transform(new_transform: Transform3D) -> void:
	# O(1) direct memory access, bypassing Node traversal
	PhysicsServer3D.body_set_state(_body_rid, PhysicsServer3D.BODY_STATE_TRANSFORM, new_transform)
	RenderingServer.instance_set_transform(_mesh_instance_rid, new_transform)

func destroy() -> void:
	PhysicsServer3D.free_rid(_body_rid)
	RenderingServer.free_rid(_mesh_instance_rid)

# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_renderingserver.html
# - https://docs.godotengine.org/en/stable/tutorials/performance/using_multiple_threads.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md — RID/server paths vs Node swarms
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-physics-3d/SKILL.md — PhysicsServer3D body lifecycle for projectiles
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-platform-console/SKILL.md
# =============================================================================
