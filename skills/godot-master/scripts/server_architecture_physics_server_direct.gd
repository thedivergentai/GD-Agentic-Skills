# physics_server_direct.gd
# Bypassing SceneTree overhead for high-density simulations
extends Node3D

# EXPERT NOTE: For MMO-scale logic, Nodes are too expensive. 
# Create bodies directly on the PhysicsServer3D and manage RIDs.

var server_bodies: Array[RID] = []

func spawn_server_body(xform: Transform3D) -> RID:
	var body_rid := PhysicsServer3D.body_create()
	PhysicsServer3D.body_set_mode(body_rid, PhysicsServer3D.BODY_MODE_KINEMATIC)
	# Link to the 3D world's physics space
	PhysicsServer3D.body_set_space(body_rid, get_world_3d().space)
	PhysicsServer3D.body_set_state(body_rid, PhysicsServer3D.BODY_STATE_TRANSFORM, xform)
	
	server_bodies.append(body_rid)
	return body_rid

func _exit_tree():
	for rid in server_bodies:
		PhysicsServer3D.free_rid(rid)

# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/performance/using_servers.html
# - https://docs.godotengine.org/en/stable/classes/class_physicsserver3d.html
# - https://docs.godotengine.org/en/stable/classes/class_rid.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-physics-3d/SKILL.md — node physics baseline before RID body_create
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md — when SceneTree bodies become too expensive
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-server-architecture/SKILL.md
# =============================================================================
